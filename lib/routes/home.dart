import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/style.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/product.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatelessWidget {
  final buttonIcons = [FontAwesomeIcons.search, FontAwesomeIcons.userAlt];

  @override
  Widget build(BuildContext context) {
    print('************************** home build **************************');
    return BaseRoute<HomeProvider>(
      provider: HomeProvider(context),
      builder: (_, provider, __) {
        return Selector<HomeProvider, int>(
          selector: (_, pv) => pv.pageIndex,
          builder: (_, pageIndex, __) {
            print('************************** home view model build **************************');
            final theme = Provider.of<ThemeModel>(context);
            return Scaffold(
              appBar: PreferredSize(
                  child: AppBar(
                    brightness: Brightness.light,
                    backgroundColor: Style.backgroundColor,
                    elevation: 0,
                  ),
                  preferredSize: Size.fromHeight(0)),
              body: IndexedStack(
                index: pageIndex,
                children: <Widget>[
                  ProductRoute(provider: provider.productProvider),
                  //   Personal(model: model.personalViewModel)
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: buttonIcons.map((icon) {
                    int inx = buttonIcons.indexOf(icon);
                    return Padding(
                      padding: inx == 0 ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
                      child: IconButton(
                        icon: Icon(icon, size: 24, color: pageIndex == inx ? theme.themeColor : Colors.grey),
                        onPressed: () => provider.setPage(inx),
                      ),
                    );
                  }).toList(),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add, size: 32),
                onPressed: () => null,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            );
          },
        );
      },
    );
  }
}

class HomeProvider extends BaseProvider {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  ProductProvider _productProvider;

  ProductProvider get productProvider => _productProvider;

  HomeProvider(BuildContext context) : super(context) {
    _productProvider = new ProductProvider(context);

    
  }

  setPage(int inx) async {
    if (_pageIndex != inx) {
      var user = Provider.of<UserModel>(context, listen: false);
      if (inx == 1 && user.isLogin == false) {
        var res = await pushNamed(ROUTE_LOGIN);
        if (res == 0) {
          _pageIndex = inx;
          notifyListeners();
        }
      } else {
        _pageIndex = inx;
        notifyListeners();
      }
    }
  }

  toPublish() async {
    var user = Provider.of<UserModel>(context, listen: false);
    if (user != null) {
      await pushNamed(ROUTE_PUBLISH);
    } else {
      await pushNamed(ROUTE_LOGIN);
    }
  }
}
