import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/address_select_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressSelectCardGroup extends StatelessWidget {
  AddressSelectCardGroup({Key key, this.addressList}) : super(key: key);

  final List<ReceiptAddress> addressList;

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<AddressSelectCardGroupProvider>(
      provider: AddressSelectCardGroupProvider(context),
      builder: (_, provider, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(provider.translate('order.address_select')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
          ),
          body: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: addressList.length,
              itemBuilder: (_, i) {
                return AddressSelectCard(address: addressList[i], onTap: () => provider.pop(addressList[i]));
              }),
        );
      },
    );
  }
}

class AddressSelectCardGroupProvider extends BaseProvider {
  AddressSelectCardGroupProvider(BuildContext context) : super(context);
}
