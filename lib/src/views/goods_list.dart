import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/view_models/goods_list_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_refresh_indicator.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GoodsList extends StatefulWidget{
  GoodsList({
    Key key,
    @required this.goodsPage,
    this.refresh,
    this.controller,
    this.category,
  }) : super(key: key);

  final ExtPage<Goods> goodsPage;
  final Function({ExtPage<Goods> page, bool isRefresh}) refresh;
  final ScrollController controller;
  final int category;

  @override
  State<StatefulWidget> createState() => _GoodsList();

}
class _GoodsList extends State<GoodsList> with AutomaticKeepAliveClientMixin{
  Future<void> onRefresh() async {
    if(widget.refresh != null){
      return widget.refresh(page: widget.goodsPage, isRefresh: true);
    }
  }

  Future<void> onLoad() async {
    if(widget.refresh != null){
      return widget.refresh(page: widget.goodsPage, isRefresh: false);
    }
  }

  Icon _buildFavoriteIcon(Goods goods, User user){
    bool isFavorite = goods.hasCollection(user?.userid ?? 0);
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border, 
      size: 14,
      color: isFavorite ? Colors.green : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ExtPage goodsPage = widget.goodsPage;
    return BaseView<GoodsListViewModel>(
      model: GoodsListViewModel(context),
      builder: (_, model, __){
        return CustomRefreshIndicator(
          onRefresh: onRefresh,
          onLoad: goodsPage.hasMore() ? onLoad : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: StaggeredGridView.countBuilder(
              controller: widget.controller,
              // physics: ClampingScrollPhysics(),
              itemCount: goodsPage.data.length,
              staggeredTileBuilder: (inx) => StaggeredTile.fit(2),
              crossAxisCount: 4,
              mainAxisSpacing: 6, // 垂直间距
              crossAxisSpacing: 6, // 水平间距
              itemBuilder: (context, i){
                return Selector<GoodsListViewModel, Goods>(
                  selector: (_, __) => goodsPage.data[i],
                  builder: (_, goods, __){
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Hero(
                            tag: 'goodsImg${goods.imgs[0].hashCode}${goods.productId}${widget.category}',
                            child: ExtNetworkImage(
                              '$URL_IPFS_GATEWAY${goods.imgs[0]}',
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                              onTap: () => model.toDetail(goodsPage.data, i),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              goods.title, 
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              overflow: TextOverflow.ellipsis, 
                              maxLines: 2
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    goods.price.split(' ')[1],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    goods.price.split(' ')[0],
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    ),
                                    overflow: TextOverflow.ellipsis, 
                                    maxLines: 1
                                  ),
                                ],
                              ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ExtCircleAvatar(goods.seller.head, 20, strokeWidth: 0),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 6, right: 2),
                                    child: Text(
                                      goods.seller.nickname,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[800]
                                        )
                                      ),
                                  ),
                                ),
                                InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        goods.collections.toString(), 
                                        style: TextStyle(
                                          fontSize: 12
                                        )
                                      ),
                                      SizedBox(width: 4),
                                      _buildFavoriteIcon(goods, model.currentUser)
                                    ],
                                  ),
                                  onTap: () => model.favorite(goodsPage.data, i),
                                )
                              ]
                            ),
                          ),
                        ]
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;

}