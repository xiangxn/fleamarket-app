import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/user_edit_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';

class UserEdit extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<UserEditViewModel>(
      listen: true,
      model: UserEditViewModel(context),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('user_edit.title')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                onPressed: model.submit,
                child: Text(locale.translation('user_edit.done')),
              )
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              children: <Widget>[
                LineButtonGroup(
                  margin: EdgeInsets.only(top: 10),
                  children: [
                    LineButtonItem(
                      text: locale.translation('user_edit.head'),
                      suffix: ExtCircleAvatar(model.currentUser?.head, 60, data: model.photo, strokeWidth: 0),
                      onTap: model.changeHead,
                    ),
                    LineButtonItem(
                      text: locale.translation('user_edit.nickname'),
                      suffix: Container(
                        child: TextField(
                          controller: model.controller,
                          autocorrect: false,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: model.currentUser?.nickname,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            border: InputBorder.none
                          ),
                        )
                      ),
                    )
                  ],
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