import 'dart:math';

import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/order_detail_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:fleamarket/src/widgets/price_text.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget{
  OrderDetail({
    Key key,
    this.order
  }) : super(key: key);

  final Order order;

  Widget _buildStatus(ExtLocale locale, int status){
    status = Random.secure().nextInt(4);
    Color color = Colors.black;
    
    // if(status == 0){
    //   color = Colors.green;
    // }else if(status == 1){
    //   color = Colors.orange[800];
    // }else if(status == 2){
    //   color = Colors.red;
    // }else if(status == 3){
    //   color = Colors.grey;
    // }
    return Text(locale.translation('order_type.$status'), 
      style: TextStyle(
        color: color,
        fontSize: 13
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderDetailViewModel>(
      model: OrderDetailViewModel(context, order),
      builder: (_, model, loading){
        User curUser = model.order.masterUser(model.userId);
        bool isSell = model.order.isSell(model.userId);
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.order_detail')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(locale.translation('combo_text.order_no', [model.order.orderid.toString()])),
                              _buildStatus(locale, model.order.status)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Padding(
                              //   padding: EdgeInsets.only(right: 16),
                              //   child: ExtCircleAvatar(curUser?.head, 30, strokeWidth: 0),
                              // ),
                              Text(locale.translation('combo_text.${isSell ? 'buyer' : 'seller'}', [curUser.nickname]),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700]
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: ExtNetworkImage(model.order.product.imgs[0], 
                                imageBuilder: (_, imageProvider){
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 16),
                                height: 80,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(model.order.product.title),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            PriceText(label: locale.translation('text.price'), price: model.order.product.price),
                                            PriceText(label: locale.translation('text.postage'), price: model.order.product.postage),
                                          ],
                                        ),
                                      )
                                    )
                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: Column(
                                    //     children: <Widget>[
                                          
                                    //       PriceText(label: locale.translation('text.total_price'), price: model.order.price)
                                    //     ],
                                    //   )
                                    // )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              // Text(locale.translation('text.total_price')),
                              PriceText(label: locale.translation('text.total_price'), price: model.order.price)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Text('收货地址'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Text('物流信息'),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomButton(
                      onTap: (){},
                      margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                      padding: EdgeInsets.all(16),
                      text: 'status ${model.order.status} 付款/发货/确认收货',
                    ),
                    CustomButton(
                      onTap: (){},
                      color: Colors.red,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      text: '取消订单',
                    )
                  ],
                )
              )
            ],
          ),
        );
      }
    );
  }

}