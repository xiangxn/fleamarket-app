import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/mine_address_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class MineAddress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineAddressViewModel>(
      listen: true,
      model: MineAddressViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.mine_address')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                child: Text(locale.translation('controller.add')),
                onPressed: model.toEdit,
              )
            ],
          ),
          body: model.busy ? loading : (model.list?.length ?? 0) == 0 ? 
            Center(
              child: Container(
                child: Text(locale.translation('text.no_data_address')),
              ),
            ) :
            CustomRefreshIndicator(
              onRefresh: () => model.fetchAddress(),
              child: ListView.builder(
                // physics: ClampingScrollPhysics(),
                itemCount: model.list.length,
                itemBuilder: (_, i){
                  Address address = model.list[i];
                  TextStyle activeStyle = TextStyle(color: Colors.white);
                  TextStyle inactiveStyle = TextStyle(color: Colors.grey[800]);
                  List<Widget> controller = [
                    FlatButton(
                      onPressed: () => model.delete(address),
                      child: Text(locale.translation('controller.delete'), style: address.isDefault ? activeStyle : inactiveStyle),
                    ),
                    FlatButton(
                      onPressed: () => model.toEdit(address),
                      child: Text(locale.translation('controller.edit'), style: address.isDefault ? activeStyle : inactiveStyle),
                    )
                  ];
                  if(!address.isDefault){
                    controller.add(FlatButton(
                      onPressed: () => model.setDefault(address),
                      child: Text(locale.translation('controller.set_default'), style: address.isDefault ? activeStyle : inactiveStyle),
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
                                Text(locale.translation('combo_text.consignee', [address.name]), style: address.isDefault ? activeStyle : inactiveStyle),
                                Text(locale.translation('combo_text.contact', [address.phone]), style: address.isDefault ? activeStyle : inactiveStyle),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                locale.translation('combo_text.shipping_address', ['${address.position} ${address.address}']),
                                style: address.isDefault ? activeStyle : inactiveStyle
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[300])
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: controller,
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              )
            )
        );
      },
    );
  }
}