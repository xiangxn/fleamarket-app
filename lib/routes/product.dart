import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/product_list.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class ProductRoute extends StatelessWidget {
  final ProductProvider provider;

  ProductRoute({Key key, @required this.provider}) : super(key: key);

  Widget _createTabBar() {
    return FutureBuilder<bool>(
      future: provider.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(children: <Widget>[
            TabBar(
              controller: provider.tabController,
              isScrollable: true,
              indicatorColor: Colors.grey[700],
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.only(bottom: 10.0),
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
              ),
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: provider.categories.map((c) => Tab(text: c.view)).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
              child: SearchWidget(isBtn: true),
            ),
            Expanded(
              child: TabBarView(
                controller: provider.tabController,
                children: provider.categories.map((category) {
                  return Selector<ProductProvider, DataPage>(
                    selector: (_, provider) => provider.getProductList(category),
                    builder: (_, page, __) {
                      return ProductList(
                        goodsPage: page,
                        refresh: provider.fetchGoodsList,
                        category: category.cid,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ]);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<ProductProvider>(
      listen: false,
      provider: this.provider,
      builder: (_, provider, child) {
        return _createTabBar();
      },
    );
  }
}

class ProductProvider extends BaseProvider implements TickerProvider {
  List<Category> _categories;
  List<DataPage<Product>> _list = [];
  TabController _tabController;

  List<Category> get categories => _categories;
  TabController get tabController => _tabController;

  final dataApi = DataApi();

  ProductProvider(BuildContext context) : super(context);

  Future<bool> getCategories() async {
    _categories = List<Category>();
    _categories.add(Category()
      ..cid = 0
      ..view = FlutterI18n.translate(context, "category.0")
      //..view = "最新"
      ..parent = 0);
    BaseReply result = await dataApi.fetchCategories();
    if (result.code == 0) {
      final data = convertEdgeList(result.data, "categories");
      data.forEach((e) {
        var c = Category();
        c.mergeFromProto3Json(e['node']);
        c.view = FlutterI18n.translate(context, "category.${c.cid}");
        _categories.add(c);
      });

      _list = List<DataPage<Product>>.generate(_categories.length, (i) => DataPage<Product>());
      _tabController = new TabController(length: _categories.length, vsync: this);
      await Future.wait(_list.map((p) => fetchGoodsList(page: p, isRefresh: true, notify: false)));
      return true;
    }
    return false;
  }

  getProductList(Category category) {
    int idx = _categories.indexOf(category);
    return _list[idx];
  }

  fetchGoodsList({DataPage<Product> page, bool isRefresh = false, bool notify = true}) async {
    var userModel = Provider.of<UserModel>(context, listen: false);
    int inx = _list.indexOf(page);
    Category category = _categories[inx];
    if (isRefresh) {
      page.clean();
    } else {
      page.incres();
    }
    // showLoading();
    final res = await dataApi.fetchProductList(category.cid, page.pageNo, page.pageSize, userid: userModel.user == null ? 0 : userModel.user.userid);
    // print("res:$res");
    // closeLoading();
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, Product(), "productByCid");
      data.update(page.data);
      _list[inx] = data;
      if (notify) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }
}
