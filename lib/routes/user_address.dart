import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddressRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserAddressProvider>(
      listen: true,
      provider: UserAddressProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_address.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
              actions: <Widget>[
                FlatButton(
                  child: Text(provider.translate('controller.add')),
                  onPressed: provider.toEdit,
                )
              ],
            ),
            body: FutureBuilder(
              future: provider.fetchAddress(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if ((provider.list?.length ?? 0) == 0) {
                    return Center(
                      child: Container(
                        child: Text(provider.translate('user_address.no_data_address')),
                      ),
                    );
                  } else {
                    return CustomRefreshIndicator(
                        onRefresh: () => provider.fetchAddress(),
                        child: ListView.builder(
                            itemCount: provider.list.length,
                            itemBuilder: (_, i) {
                              ReceiptAddress address = provider.list[i];
                              TextStyle activeStyle = TextStyle(color: Colors.white);
                              TextStyle inactiveStyle = TextStyle(color: Colors.grey[800]);
                              List<Widget> controller = [
                                FlatButton(
                                  onPressed: () => provider.delete(address),
                                  child: Text(provider.translate('controller.delete'), style: address.isDefault ? activeStyle : inactiveStyle),
                                ),
                                FlatButton(
                                  onPressed: () => provider.toEdit(address),
                                  child: Text(provider.translate('controller.edit'), style: address.isDefault ? activeStyle : inactiveStyle),
                                )
                              ];
                              if (!address.isDefault) {
                                controller.add(FlatButton(
                                  onPressed: () => provider.setDefault(address),
                                  child: Text(provider.translate('controller.set_default'), style: address.isDefault ? activeStyle : inactiveStyle),
                                ));
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Card(
                                  elevation: 0,
                                  color: address.isDefault ? Colors.green : Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(provider.translate('combo_text.consignee', translationParams: {"name": address.name}),
                                                style: address.isDefault ? activeStyle : inactiveStyle),
                                            Text(provider.translate('combo_text.contact', translationParams: {"value": address.phone}),
                                                style: address.isDefault ? activeStyle : inactiveStyle),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          child: Text(
                                              provider.translate('combo_text.shipping_address',
                                                  translationParams: {"addr": '${address.province}${address.city}${address.district}${address.address}'}),
                                              style: address.isDefault ? activeStyle : inactiveStyle),
                                        ),
                                        DecoratedBox(
                                            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[300]))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: controller,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }));
                  }
                }
                return loading;
              },
            ));
      },
    );
  }
}

class UserAddressProvider extends BaseProvider {
  UserAddressProvider(BuildContext context) : super(context);

  List<ReceiptAddress> _list = [];
  List<ReceiptAddress> get list => _list;

  fetchAddress() async {
    setBusy();
    final user = Provider.of<UserModel>(context, listen: false).user;
    var process = api.getRecAddrByUser(user.userid);
    final res = await processing(process, loading: false);
    if (res.code == 0) {
      _list = convertList(res.data, "recAddrByUser", ReceiptAddress());
    }
    setBusy();
  }

  toEdit([ReceiptAddress address]) async {
    var flag = await pushNamed(ROUTE_EDIT_ADDRESS, arguments: address);
    if (flag != null && flag) {
      notifyListeners();
    }
  }

  setDefault(ReceiptAddress address) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    showLoading();
    final res = await api.setDefaultAddr(address.rid, user.userid);
    closeLoading();
    if (res) {
      var data = List<ReceiptAddress>.from(_list);
      data.forEach((e) {
        if (e.rid == address.rid) {
          e.isDefault = true;
        } else {
          e.isDefault = false;
        }
        _list = data;
      });
    }
    notifyListeners();
  }

  delete(ReceiptAddress address) async {
    bool dialogRes = await confirm(translate('message.delete_address'));
    if (dialogRes) {
      final user = Provider.of<UserModel>(context, listen: false).user;
      showLoading();
      AddressRequest ar = AddressRequest();
      ar.rid = address.rid;
      ar.userid = user.userid;
      final res = await api.delRecAddr(ar);
      closeLoading();
      if (res) {
        var data = List<ReceiptAddress>.from(_list);
        data.removeWhere((e) => e.rid == address.rid);
      }
      notifyListeners();
    }
  }
}
