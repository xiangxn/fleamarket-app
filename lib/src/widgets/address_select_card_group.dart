import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/widgets/address_select_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressSelectCardGroup extends StatelessWidget{
  AddressSelectCardGroup({
    Key key,
    this.addressList
  }) : super(key: key);

  final List<Address> addressList;

  @override
  Widget build(BuildContext context) {
    ExtLocale locale = Provider.of<ExtLocale>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(locale.translation('title.address_select')),
        backgroundColor: Style.headerBackgroundColor,
        brightness: Brightness.light,
        textTheme: Style.headerTextTheme,
        iconTheme: Style.headerIconTheme,
      ),
      body: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: addressList.length,
        itemBuilder: (_, i){
          return AddressSelectCard(
            address: addressList[i],
            onTap: () => Navigator.of(context).pop(addressList[i])
          );
        }
      ),
    );
  }

}