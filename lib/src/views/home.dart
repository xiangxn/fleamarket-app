import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/view_models/personal_view_model.dart';
import 'package:fleamarket/src/view_models/shop_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/views/personal.dart';
import 'package:fleamarket/src/views/shop.dart';
import 'package:fleamarket/src/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget{

  final buttonIcons = [FontAwesomeIcons.home, FontAwesomeIcons.userAlt];

  @override
  Widget build(BuildContext context) {
    print('************************** home build **************************');
    return BaseView<HomeViewModel>(
      model: HomeViewModel(context),
      builder: (context2, model, __){
        print('************************** home view model build **************************');
        return Selector<HomeViewModel, int>(
          selector: (_, provider) => provider.pageInx,
          builder: (_, pageInx, __){
            return Scaffold(
              appBar: PreferredSize(
                child: AppBar(
                  brightness: Brightness.light,
                  backgroundColor: Style.backgroundColor,
                  elevation: 0,
                ), 
                preferredSize: Size.fromHeight(0)
              ),
              body: IndexedStack(
                index: pageInx,
                children: <Widget>[
                  Shop(model: model.shopViewModel),
                  Personal(model: model.personalViewModel)
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buttonIcons.map((icon){
                    int inx = buttonIcons.indexOf(icon);
                    return Padding(
                      padding: inx == 0 ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
                      child: IconButton(
                        icon: Icon(
                          icon, 
                          size: 24, 
                          color: pageInx == inx ? Colors.green : Colors.grey
                        ),
                        onPressed: () => model.setPage(inx),
                      ),
                    );
                  }).toList(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add, size: 32),
                onPressed: model.toPublish,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            );
          },
        );
      }
    );
  }
}