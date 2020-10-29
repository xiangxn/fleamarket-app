import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class InputShipmentNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<InputShipmentNumberProvider>(
      provider: InputShipmentNumberProvider(context),
      builder: (_, model, __) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 100),
          child: TextField(
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
                hintText: model.translate('order_detail.hint_enter_number'),
                suffix: CustomButton(
                  autoUnfocus: false,
                  onTap: model.onSubmit,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  text: model.translate('controller.ok'),
                )),
          ),
        );
      },
    );
  }
}

class InputShipmentNumberProvider extends BaseProvider {
  InputShipmentNumberProvider(BuildContext context) : super(context);
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  TextEditingController get controller => _controller;
  FocusNode get focusNode => _focusNode;

  void onSubmit([String str]) async {
    str ??= _controller.text;
    FocusScope.of(context).requestFocus(_focusNode);
    if (str.isEmpty) {
      this.showToast(translate('order_detail.number_err_msg'));
    } else {
      this.pop(str);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _focusNode?.dispose();
  }
}
