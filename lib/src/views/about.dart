import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/view_models/about_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<AboutViewModel>(
      listen: true,
      model: AboutViewModel(context),
      builder: (_, model, loading){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.locale.translation('title.about')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: model.busy ? 
              loading : 
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Text(
                  model.readme, 
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16
                  ),
                ),
              ),
          ),
        );
      },
    );
  }
}