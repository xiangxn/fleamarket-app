import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

class InputSingleString extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final String errorMessage;
  final bool canEmpty;
  InputSingleString({Key key, this.hintText, this.maxLines, this.errorMessage, this.canEmpty}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseRoute<InputSingleStringProvider>(
      provider: InputSingleStringProvider(context, errorMessage: this.errorMessage, canEmpty: this.canEmpty),
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
            maxLines: this.maxLines ?? 1,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 8),
                isDense: true,
                hintText: this.hintText == null ? model.translate('order_detail.hint_enter_number') : this.hintText,
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

class InputSingleStringProvider extends BaseProvider {
  InputSingleStringProvider(BuildContext context, {String errorMessage, bool canEmpty = false}) : super(context) {
    this._errorMessage = errorMessage ?? translate('order_detail.number_err_msg');
    this._canEmpty = canEmpty;
  }
  bool _canEmpty;
  String _errorMessage;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  TextEditingController get controller => _controller;
  FocusNode get focusNode => _focusNode;

  void onSubmit([String str]) async {
    str ??= _controller.text;
    FocusScope.of(context).requestFocus(_focusNode);
    if (!_canEmpty && str.isEmpty) {
      this.showToast(_errorMessage);
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
