import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/edit_withdrawal_view_model.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class EditWithdrawal extends StatelessWidget{
  EditWithdrawal({Key key, @required this.withdrawal}) : super(key: key);
  final String withdrawal;

  @override
  Widget build(BuildContext context) {
    return BaseView<EditWithdrawalViewModel>(
      model: EditWithdrawalViewModel(context, withdrawal),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.edit_withdrawal')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                onPressed: model.submit,
                child: Text(locale.translation('controller.complete')),
              )
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        autofocus: true,
                        enableSuggestions: false,
                        controller: model.controller,
                        autocorrect: false,
                        maxLines: 8,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: locale.translation('hint.withdrawal'),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: InputBorder.none
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: model.paste,
                          child: Text(
                            locale.translation('controller.paste'),
                            style: TextStyle(color: Colors.green),
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Style.backgroundColor
                  ),
                )
              ],
            )
          ),
        );
      },
    );
  }

}