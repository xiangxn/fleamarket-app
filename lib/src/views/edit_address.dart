import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/edit_address_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAddress extends StatelessWidget{
  EditAddress({Key key, @required this.address}) : super(key: key);
  final Address address;

  Widget _buildLine({String text, String hint, TextInputType inputType, int maxLength, TextEditingController controller, Function onTap}){
    List<TextInputFormatter> formatters = [];
    if(maxLength != null && maxLength > 0){
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }
    return LineButtonItem(
      text: text,
      suffix: Container(
        child: TextField(
          keyboardType: inputType,
          enableSuggestions: false,
          controller: controller,
          autocorrect: false,
          inputFormatters: formatters,
          textAlign: TextAlign.right,
          maxLines: 1,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: InputBorder.none
          ),
          onTap: onTap,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BaseView<EditAddressViewModel>(
      listen: true,
      model: EditAddressViewModel(context, address),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true, 
            title: Text(locale.translation(address == null ? 'title.add_address' : 'title.edit_address')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                child: Text(locale.translation('controller.complete')),
                onPressed: model.submit,
              )
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Wrap(
              children: <Widget>[
                LineButtonGroup(
                  children: <Widget>[
                    _buildLine(
                      text: locale.translation('text.consignee'),
                      hint: locale.translation('hint.consignee'),
                      controller: model.consigneeController
                    ),
                    _buildLine(
                      text: locale.translation('text.contact'),
                      hint: locale.translation('hint.contact'),
                      inputType: TextInputType.numberWithOptions(),
                      maxLength: 11,
                      controller: model.phoneController,
                    ),
                    _buildLine(
                      text: locale.translation('text.location'),
                      hint: locale.translation('hint.location'),
                      controller: model.positionController,
                      onTap: model.showAddressSelector
                    ),
                    _buildLine(
                      text: locale.translation('text.sub_location'),
                      hint: locale.translation('hint.sub_location'),
                      controller: model.detailController
                    ),
                    _buildLine(
                      text: locale.translation('text.postcode'),
                      hint: locale.translation('hint.postcode'),
                      inputType: TextInputType.numberWithOptions(),
                      maxLength: 8,
                      controller: model.postcodeController
                    ),
                  ]
                )
              ],
            ),
          ),
        );
      },
    );
  }

}