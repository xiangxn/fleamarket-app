import 'package:flutter/material.dart';

class SheetButton extends StatelessWidget{

  SheetButton({
    Key key,
    @required this.text,
    this.tag,
    this.height = 60,
    this.color = Colors.black,
    this.bgColor = Colors.white,
    this.handleTap 
  }): super(key: key);

  final String text;
  final dynamic tag;
  final double height;
  final Color color;
  final Color bgColor;
  final Function handleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: bgColor,
        height: height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).pop();
        if(handleTap != null){
          handleTap(tag);
        }
      },
    );
  }

}