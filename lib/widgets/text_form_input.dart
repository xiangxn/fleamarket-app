import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Validator = String Function(String);

class TextFormInput extends StatelessWidget {
  TextFormInput(
      {Key key,
      this.spKey,
      this.keyboardType,
      this.textInputAction,
      this.obscure,
      this.autoFocus,
      this.validator,
      this.autoValidate,
      this.onSaved,
      this.enableInteractiveSelection,
      this.inputFormatters,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.padding,
      this.margin,
      this.contentPadding})
      : super(key: key);

  final Key spKey;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscure;
  final bool autoFocus;
  final Validator validator;
  final bool autoValidate;
  final Function onSaved;
  final bool enableInteractiveSelection;
  final List<TextInputFormatter> inputFormatters;
  final String hintText;
  final IconData prefixIcon;
  final Widget suffixIcon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;

  OutlineInputBorder _commonBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(style: BorderStyle.solid, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: TextFormField(
          key: spKey,
          autofocus: false,
          autovalidate: autoValidate ?? false,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscure ?? false,
          validator: validator,
          onSaved: onSaved,
          enableInteractiveSelection: enableInteractiveSelection ?? true,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: contentPadding ?? EdgeInsets.all(16),
              hintText: hintText,
              focusedBorder: _commonBorder(Colors.green),
              enabledBorder: _commonBorder(Colors.grey[200]),
              errorBorder: _commonBorder(Colors.red),
              focusedErrorBorder: _commonBorder(Colors.red),
              prefixIcon: Icon(prefixIcon, size: 16),
              suffixIcon: suffixIcon)),
    );
  }
}
