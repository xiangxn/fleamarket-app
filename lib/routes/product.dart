import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/product_list.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  final ProductProvider provider;

  ProductPage({Key key, @required this.provider}) : super(key: key);

  Widget _createTabBar() {
    return FutureBuilder<bool>(
      initialData: false,
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
                    shouldRebuild: (pre, next) => false,
                    selector: (_, provider) => provider.getProductList(category),
                    builder: (_, page, __) {
                      print("tabbarview build......");
                      return ProductList(
                        productPage: page,
                        onGetData: provider.fetchProductList,
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
    print("product build ********");
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
  Map<int, DataPage<Product>> _map = new Map<int, DataPage<Product>>();
  TabController _tabController;

  List<Category> get categories => _categories;
  TabController get tabController => _tabController;

  final dataApi = DataApi();

  ProductProvider(BuildContext context) : super(context);

  Future<bool> getCategories() async {
    _categories = List<Category>();
    _categories.add(Category()
      ..cid = 0
      ..view = translate("category.0")
      //..view = "最新"
      ..parent = 0);
    BaseReply result = await dataApi.fetchCategories();
    if (result.code == 0) {
      final data = convertEdgeList<Category>(result.data, "categories", Category());
      data.forEach((e) {
        e.view = translate("category.${e.cid}");
        _categories.add(e);
      });
      _tabController = new TabController(length: _categories.length, vsync: this);
      await Future.wait(_categories.map((e) => fetchProductList(categoryid: e.cid, page: DataPage<Product>())));
      return true;
    }
    return false;
  }

  getProductList(Category category) {
    final page = _map[category.cid];
    // print("page: ${category.cid} $page");
    return page;
  }

  Future<DataPage<Product>> fetchProductList({int categoryid, DataPage<Product> page}) async {
    final res = await dataApi.fetchProductList(categoryid, page.pageNo, page.pageSize);
    // print("res:$res");
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, "productByCid", Product());
      if (data.data.length > 0) {
        data.update(page.data);
        _map[categoryid] = data;
        return data;
      } else {
        return page;
      }
    }
    return page;
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
