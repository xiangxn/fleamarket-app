// import 'package:fleamarket/src/models/category.dart';
// import 'package:fleamarket/src/models/ext_page.dart';
// import 'package:fleamarket/src/models/goods.dart';
// import 'package:fleamarket/src/view_models/shop_view_model.dart';
// import 'package:fleamarket/src/widgets/custom_refresh_indicator.dart';
// import 'package:fleamarket/src/widgets/waterfall_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:provider/provider.dart';

// class WaterfallContainer extends StatelessWidget{
//   WaterfallContainer({
//     Key key,
//     @required this.page,
//     @required this.category,
//     @required this.model
//   }) : super(key: key);

//   final ExtPage page ;
//   final Category category;
//   final ShopViewModel model ;

//   @override
//   Widget build(BuildContext context){
//     return CustomRefreshIndicator(
//       autoInit: false,
//       onRefresh: () => model.fetchGoodsList(page: page, isRefresh: true),
//       onLoad: page.hasMore() ? () => model.fetchGoodsList(page: page) : null,
//       /// ListView，GridView等，在没配合AppBar使用时，出现顶部一个padding的问题
//       /// 使用MediaQuery.removePadding解决
//       child: MediaQuery.removePadding(
//         removeTop: true,
//         context: context,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 6),
//           child: StaggeredGridView.countBuilder(
//             physics: ClampingScrollPhysics(),
//             itemCount: page.data.length,
//             crossAxisCount: 4,
//             mainAxisSpacing: 6, // 垂直间距
//             crossAxisSpacing: 6, // 水平间距
//             itemBuilder: (context, i){
//               return Selector<ShopViewModel, Goods>(
//                 selector: (_, provider) => provider.findGoods(category, i),
//                 builder: (_, goods, __) => WaterfallItem(goods: goods, model: model)
//               );
//             },
//             staggeredTileBuilder: (inx) => new StaggeredTile.fit(2),
//           ),
//         ),
//       )
//     );
//   }
// }