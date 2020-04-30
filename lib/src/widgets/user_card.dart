import 'dart:math';

import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/user_card_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ext_circle_avatar.dart';

class UserCard extends StatelessWidget{
  UserCard({
    Key key,
    this.user,
    this.updateUser
  }) : super(key: key);
  final User user;
  final UpdateObjectCallback<User> updateUser;
  @override
  Widget build(BuildContext context) {
    return BaseView<UserCardViewModel>(
      listen: true,
      model: UserCardViewModel(context, user, updateUser),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return InkWell(
          onTap: model.toUserHome,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: ExtCircleAvatar(user.head, 60, strokeWidth: 0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(user.nickname),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    user?.isReviewer == 0 ? 
                                      FontAwesomeIcons.solidUser :
                                      FontAwesomeIcons.userTie ,
                                    color: Colors.grey[700],
                                    size: 14,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      user?.isReviewer == 0 ? 
                                        locale.translation('personal.user_normal') :
                                        locale.translation('personal.user_reviewer') ,
                                      style: Style.smallFont,
                                    ),
                                  )
                                ],
                              ),
                              Text(locale.translation('combo_text.user_score', [(user.creditValue ?? 0).toString()]), 
                                style: Style.smallFont,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    CustomButton(
                      fontSize: 14,
                      width: 60,
                      height: 30,
                      active: !model.isFocus,
                      onTap: model.focusUser,
                      text: model.isFocus ? locale.translation('text.unfocus') : locale.translation('text.focus'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}