import 'package:flutter/material.dart';

class ExtFlatButton extends StatelessWidget{
  const ExtFlatButton({
    Key key,
    this.content,
    this.width,
    this.height,
    this.color,
    this.childWeight,
    this.childSize,
    this.childColor,
    this.shape,
    this.onTap
  }) : super(key: key);

  /// button content [String] or [IconData]
  final dynamic content;
  final double width;
  final double height;
  /// button background color
  final Color color;
  /// use in Text when content is String 
  final FontWeight childWeight;
  /// Text font size or Icon size
  final double childSize;
  /// Text font color or Icon color
  final Color childColor;
  /// see: 
  /// Border()
  /// RoundedRectangleBorder()
  final ShapeBorder shape;
  final Function onTap;

  Widget _build(){
    if(this.content is IconData){
      return Icon(
        this.content,
        size: this.childSize,
        color: this.childColor,
      );
    }else{
      return Text(
        this.content.toString(),
        style: TextStyle(
          color: this.childColor,
          fontSize: this.childSize,
          fontWeight: this.childWeight
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      height: this.height,
      child: FlatButton(
        shape: this.shape,
        color: this.color,
        onPressed: this.onTap,
        child: _build(),
      ),
    );
  }
  
}