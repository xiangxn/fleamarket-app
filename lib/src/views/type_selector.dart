import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget{

  final String title;
  final List<Category> categories;

  TypeSelector({
    Key key,
    this.title,
    this.categories
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: Style.headerBackgroundColor,
        brightness: Brightness.light,
        textTheme: Style.headerTextTheme,
        iconTheme: Style.headerIconTheme,
      ),
      body: Wrap(
        children: <Widget>[
          LineButtonGroup(
            children: categories.map((category) => LineButtonItem(
              text: category.view,
              onTap: () => Navigator.of(context).pop(category)
            )).toList(),
          )
        ],
      ),
    );
  }
  
}