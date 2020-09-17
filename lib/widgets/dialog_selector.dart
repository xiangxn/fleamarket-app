import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'line_button_group.dart';
import 'line_button_item.dart';

class DialogSelector extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  DialogSelector({Key key, this.title, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context).theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: style.headerBackgroundColor,
        brightness: Brightness.light,
        textTheme: style.headerTextTheme,
        iconTheme: style.headerIconTheme,
      ),
      body: Wrap(
        children: <Widget>[
          LineButtonGroup(
            children: data.map((e) => LineButtonItem(text: e.keys.first, onTap: () => Navigator.of(context).pop(e))).toList(),
          )
        ],
      ),
    );
  }
}
