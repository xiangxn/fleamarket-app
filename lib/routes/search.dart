import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/product_list.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchRoute extends StatelessWidget {
  Widget _buildChild(SearchProvider provider, Widget loading, BuildContext context) {
    if (provider.firstShow || provider.hasFocus || provider.search.isEmpty) {
      return _history(provider, context);
    } else {
      return _productList(provider, loading, context);
    }
  }

  Widget _history(SearchProvider provider, BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(FlutterI18n.translate(context, 'search.history')),
          trailing: IconButton(
            icon: Icon(FontAwesomeIcons.trashAlt, size: 18),
            onPressed: provider.clearHistory,
          ),
        ),
        Expanded(
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            separatorBuilder: (_, i) => Divider(color: Colors.grey[300], indent: 16, endIndent: 16),
            itemCount: provider.history.length,
            itemBuilder: (_, i) {
              return ListTile(
                dense: true,
                title: Text(
                  provider.history[i],
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                onTap: () => provider.onSearchSubmit(provider.history[i]),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _productList(SearchProvider provider, Widget loading, BuildContext context) {
    if (provider.busy) {
      return loading;
    } else {
      return ProductList(productPage: provider.pageData, onGetData: provider.fetchProductList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<SearchProvider>(
        listen: true,
        provider: SearchProvider(context),
        builder: (_, provider, loading) {
          final theme = Provider.of<ThemeModel>(context, listen: false).theme;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                titleSpacing: 2,
                title: SearchWidget(
                  isBtn: false,
                  onFocus: provider.onSearchFocus,
                  onSubmit: provider.onSearchSubmit,
                  controller: provider.controller,
                ),
                backgroundColor: theme.backgroundColor,
                elevation: 0,
                brightness: Brightness.light,
                textTheme: theme.headerTextTheme,
                iconTheme: theme.headerIconTheme,
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  SizedBox(
                    width: 60,
                    child: FlatButton(
                      onPressed: provider.onBack,
                      child: Text(FlutterI18n.translate(context, 'search.cancel')),
                    ),
                  )
                ],
              ),
              body: GestureDetector(
                onTap: provider.unfocus,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  child: _buildChild(provider, loading, context),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ));
        });
  }
}

class SearchProvider extends BaseProvider {
  List<String> _history;
  bool _hasFocus = false;
  bool _firstShow = true;
  TextEditingController _controller;
  DataPage<Product> _page;

  SearchProvider(BuildContext context) : super(context) {
    _history = Global.prefs.getStringList(STORE_SEARCH_HISTORY) ?? [];
    _controller = TextEditingController();
  }

  List<String> get history => _history;
  bool get hasFocus => _hasFocus;
  bool get firstShow => _firstShow;
  String get search => _controller.text;
  TextEditingController get controller => _controller;
  DataPage<Product> get pageData => _page;

  switchFirst() {
    if (_firstShow) {
      _firstShow = false;
    }
  }

  onSearchFocus(bool hasFocus) {
    switchFirst();
    _hasFocus = hasFocus;
    notifyListeners();
  }

  unfocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  onSearchSubmit(String val) async {
    print("onSearchSubmit.................");
    switchFirst();
    unfocus();
    _controller.text = val ?? '';
    if (search.isNotEmpty) {
      if (!_history.contains(search)) {
        _history.insert(0, search);
        Global.prefs.setStringList(STORE_SEARCH_HISTORY, _history);
      }
      setBusy();
      // notifyListeners();
      _page = await fetchProductList(page: DataPage<Product>());
      setBusy();
    }
    notifyListeners();
  }

  onBack() {
    if (_hasFocus) {
      _controller.text = '';
      unfocus();
    } else {
      pop();
    }
  }

  clearHistory() {
    if (_history.isNotEmpty) {
      _history.clear();
      Global.prefs.remove(STORE_SEARCH_HISTORY);
      notifyListeners();
    }
  }

  Future<DataPage<Product>> fetchProductList({int categoryid, DataPage<Product> page}) async {
    final res = await api.searchProductByTitle(_controller.text, page.pageNo, page.pageSize);
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, "productByTitle", Product());
      data.update(page.data);
      return data;
    }
    return page;
  }
}
