import 'package:flutter/material.dart';

class LineButtonGroup extends StatelessWidget{

  LineButtonGroup(
    {
      Key key,
      @required this.children,
      this.margin,
      this.padding
    }
  ) : super(key: key);

  final List<Widget> children;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context, 
        child: ListView.separated(
          padding: EdgeInsets.all(0),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (_, i) => Divider(
            color: Colors.grey[300],
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          itemCount: children.length,
          itemBuilder: (_, i){
            return Container(
              alignment: Alignment.centerLeft,
              child: children[i]
            );
          }
        )
      )
    );
  }

}