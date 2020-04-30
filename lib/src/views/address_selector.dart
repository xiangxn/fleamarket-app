import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/address_selector_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';


class AddressSelector extends StatelessWidget {
  final String title;

  AddressSelector({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<AddressSelectorViewModel>(
      listen: true,
      model: AddressSelectorViewModel(context),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            title: Text(this.title),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            leading: IconButton(
              icon: Icon(model.isTop ? Icons.close : Icons.arrow_back_ios),
              onPressed: model.back
            ),
          ),
          body: SingleChildScrollView(
            controller: model.controller,
            physics: ClampingScrollPhysics(),
            child: Column(children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                child: Text(locale.translation('address_selector.cur_address')),
              ),
              Container(
                color: Colors.white,
                child: LineButtonItem(
                  text: model.location,
                  onTap: model.selectCurrent,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                child: Text(locale.translation('address_selector.change_address')),
              ),
              LineButtonGroup(
                children: model.district.districts.map((district) {
                  return LineButtonItem(
                    text: district.name,
                    onTap: () => model.selectAddress(district),
                  );
                }).toList(),
              )
            ]),
          ),
        );
      },
    );
  }
}
