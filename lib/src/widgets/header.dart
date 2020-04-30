import 'package:fleamarket/src/common/style.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{

  Header({
    Key key,
    @required this.title,
    this.onBack
  }): super(key: key);

  final String title;
  final Function onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.shadowBottom,
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: this.onBack ?? () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: Text(title, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )),
          )
        ],
      ),
    );
  }

}