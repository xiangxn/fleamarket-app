import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/view_models/goods_detail_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:fleamarket/src/widgets/price_text.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  Detail({Key key, @required this.goods}) : super(key: key);

  final Goods goods;

  Widget _buildImg(GoodsDetailViewModel model, int inx) {
    print("inx:$inx");
    String img = model.goods.imgs[inx];
    Widget imgWidget = ExtNetworkImage('$URL_IPFS_GATEWAY$img', borderRadius: BorderRadius.circular(4));
    Widget child = inx == 0 ? Hero(tag: 'goodsImg${goods.imgs[0].hashCode}${goods.productId}', child: imgWidget) : imgWidget;
    (child is Hero) ? print((child as Hero).tag) : null;
    return Card(margin: EdgeInsets.only(left: 10, bottom: 10, right: 10), child: child);
  }

  Widget _buildBottomButton(String text, int type, bool active, Function onTap) {
    print('--=-=-=-= build bottom button');
    IconData icon;
    switch (type) {
      case 1:
        icon = active ? Icons.favorite : Icons.favorite_border;
        break;
      case 2:
        icon = active ? Icons.star : Icons.star_border;
        break;
      default:
        icon = Icons.chat_bubble_outline;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: active ? Colors.green : Colors.grey[600],
            ),
            Text(
              text,
              style: TextStyle(
                color: active ? Colors.green : Colors.grey[600],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build detail ....');
    return BaseView<GoodsDetailViewModel>(
      listen: true,
      model: GoodsDetailViewModel(context, goods),
      builder: (_, model, __) {
        ExtLocale locale = model.locale;
        return WillPopScope(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(locale.translation('title.goods_detail')),
                backgroundColor: Style.headerBackgroundColor,
                brightness: Brightness.light,
                textTheme: Style.headerTextTheme,
                iconTheme: Style.headerIconTheme,
              ),
              body: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: <Widget>[
                                      ExtCircleAvatar(
                                        model.goods.seller.head,
                                        36,
                                        strokeWidth: 0,
                                      ),
                                      SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(model.goods.seller.nickname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                          Text(locale.translation('detail.location', [model.goods.position ?? '']),
                                              style: TextStyle(fontSize: 12, color: Colors.grey))
                                        ],
                                      )
                                    ],
                                  )),
                              Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    PriceText(label: locale.translation('detail.price'), price: model.goods.price, priceBold: true),
                                    PriceText(label: locale.translation('detail.postage'), price: model.goods.postage, priceBold: true),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(model.goods.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        model.goods.desc ?? '',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: model.goods.imgs.length,
                                  itemBuilder: (context, inx) => _buildImg(model, inx),
                                ),
                              ),
                              // ListTile(
                              //   dense: true,
                              //   title: Text('全部留言'),
                              // ),
                              // ListView.separated(
                              //   shrinkWrap: true,
                              //   primary: false,
                              //   itemCount: model.messages.length,
                              //   separatorBuilder: (_, i) => Divider(color: Colors.grey[300], height: 2,),
                              //   itemBuilder: (_, i) => ListTile(
                              //     leading: ExtCircleAvatar(
                              //       model.user.head,
                              //       40,
                              //       strokeWidth: 0,
                              //     ),
                              //     title: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(model.user.nickname,
                              //           style: TextStyle(
                              //             fontSize: 14
                              //           ),
                              //         ),
                              //         Text('1900-01-01 23:59:59',
                              //           style: TextStyle(
                              //             color: Colors.grey[600],
                              //             fontSize: 12
                              //           ),
                              //         )
                              //       ],
                              //     ),
                              //     subtitle: Text(model.messages[i]),
                              //   )
                              // )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: Style.shadowBottom,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            _buildBottomButton(locale.translation('detail.favorite'), 1, model.goods.hasCollection(model.userId), model.favorite),
                            _buildBottomButton(locale.translation('detail.focus'), 2, model.hasFocus, model.focus),
                            // _buildBottomButton('留言', 0, false, (){}),
                            Spacer(),
                            CustomButton(
                              text: locale.translation('detail.buy'),
                              height: 40,
                              onTap: model.toPreOrder,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            onWillPop: model.onBack);
      },
    );
  }
}
