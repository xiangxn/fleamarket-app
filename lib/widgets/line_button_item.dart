import 'package:bitsflea/states/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LineButtonItem extends StatelessWidget {
  LineButtonItem(
      {Key key, this.text, this.subText, this.prefix, this.suffix, this.prefixIcon, this.suffixIcon, this.onTap, this.prefixIconSize, this.prefixPadding})
      : super(key: key);

  final String text;
  final String subText;
  final Widget prefix;
  final Widget suffix;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Function onTap;
  final double prefixIconSize;
  final double prefixPadding;

  List<Widget> _buildMiddle() {
    List<Widget> widgets = [];
    if (this.text != null || this.prefix != null) {
      widgets.add(Expanded(
        child: this.prefix != null
            ? this.prefix
            : Text(
                this.text,
                style: TextStyle(color: Colors.grey[900]),
              ),
      ));
    }
    if (this.subText != null || this.suffix != null) {
      widgets.add(Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerRight,
            child: this.suffix != null
                ? this.suffix
                : Text(
                    this.subText ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
          )));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.grey[300],
        onTap: this.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: <Widget>[
              Offstage(
                  offstage: this.prefixIcon == null,
                  child: Padding(
                    padding: EdgeInsets.only(right: this.prefixPadding??12),
                    // child: Icon(this.prefixIcon, size: 24, color: Colors.grey[600]),
                    child: Icon(this.prefixIcon, size: this.prefixIconSize ?? 24, color: style.primarySwatch),
                  )),
              ..._buildMiddle(),
              Offstage(
                  offstage: this.onTap == null,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(this.suffixIcon ?? Icons.arrow_forward_ios, size: 20, color: Colors.grey[400]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
