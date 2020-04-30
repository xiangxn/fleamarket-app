import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/confirm_password_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ConfirmPassword extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<ConfirmPasswordViewModel>(
      model: ConfirmPasswordViewModel(context),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 100),
          child: TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: model.controller,
            focusNode: model.focusNode,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: model.onSubmit,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8),
              isDense: true,
              hintText: locale.translation('hint.password'),
              suffix: CustomButton(
                autoUnfocus: false,
                onTap: model.onSubmit,
                margin: EdgeInsets.symmetric(horizontal: 4),
                text: locale.translation('controller.ok'),
              )
            ),
            
          ),
        );
      },
    );    
  }

}