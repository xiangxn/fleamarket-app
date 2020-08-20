import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/common/style.dart';
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
    } else if (provider.productPage.data.isEmpty) {
      return Center(
        child: Text(FlutterI18n.translate(context, 'search.no_data')),
      );
    } else {
      return ProductList(productPage: provider.productPage, refresh: provider.fetchProductList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<SearchProvider>(
        listen: true,
        provider: SearchProvider(context),
        builder: (_, provider, loading) {
          final theme = Provider.of<ThemeModel>(context).theme;
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
  DataPage<Product> _productPage;
  bool _hasFocus = false;
  bool _firstShow = true;
  TextEditingController _controller;
  DataApi _api = DataApi();

  SearchProvider(BuildContext context) : super(context) {
    _history = Global.prefs.getStringList(STORE_SEARCH_HISTORY) ?? [];
    _productPage = DataPage<Product>();
    _controller = TextEditingController();
  }

  DataPage<Product> get productPage => _productPage;
  List<String> get history => _history;
  bool get hasFocus => _hasFocus;
  bool get firstShow => _firstShow;
  String get search => _controller.text;
  TextEditingController get controller => _controller;

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
    switchFirst();
    unfocus();
    _controller.text = val ?? '';
    if (search.isNotEmpty) {
      if (!_history.contains(search)) {
        _history.insert(0, search);
        Global.prefs.setStringList(STORE_SEARCH_HISTORY, _history);
      }
      setBusy();
      notifyListeners();
      await fetchProductList(notify: false);
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

  fetchProductList({int categoryid, DataPage<Product> page, bool isRefresh = true, bool notify = true}) async {
    if (isRefresh) {
      _productPage.clean();
    } else {
      _productPage.incres();
    }
    final res = await _api.searchProductByTitle(_controller.text, _productPage.pageNo, _productPage.pageSize);
    if (res.code == 0) {
      var page = convertPageList<Product>(res.data, "productByTitle", Product());
      _productPage.update(page.data);
      if (notify) {
        notifyListeners();
      }
    }
  }
}
