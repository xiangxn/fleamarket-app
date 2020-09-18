import 'package:bitsflea/states/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget{
  
  CustomButton({
    Key key,
    @required this.onTap,
    @required this.text,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.color,
    this.fontSize,
    this.active,
    this.autoUnfocus
  }): super(key: key);

  final Function onTap;
  final String text;
  final double width;
  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color color;
  final double fontSize;
  final bool active;
  final bool autoUnfocus;

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: FlatButton(
        onPressed: this.onTap == null ? null : (){
          if(autoUnfocus ?? true){
            FocusScope.of(context).requestFocus(FocusNode());
          }
          this.onTap();
        },
        disabledTextColor: Colors.white,
        disabledColor: Colors.grey,
        color: active ?? true ? color ?? style.primarySwatch : Colors.white,
        textColor: active ?? true ? Colors.white : Colors.grey[600],
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: active ?? true ? BorderSide.none : BorderSide(color: Colors.grey[300])
        ),
        child: Container(
          padding: padding ?? EdgeInsets.all(0),
          child: Text(text, style: TextStyle(fontSize: this.fontSize ?? 16)),
        ),
      ),
    );
  }

}