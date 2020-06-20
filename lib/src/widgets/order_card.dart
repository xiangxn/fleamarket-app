import 'dart:math';

import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/order_card_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/price_text.dart';
import 'package:flutter/material.dart';

import 'ext_circle_avatar.dart';
import 'ext_network_image.dart';

class OrderCard extends StatelessWidget{

  OrderCard({
    Key key,
    this.order,
    this.updateOrder
  }) : super(key: key);

  final Order order;
  final UpdateObjectCallback<Order> updateOrder;

  Widget _buildStatus(ExtLocale locale, int status){
    status = Random.secure().nextInt(4);
    Color color = Colors.black;
    
    if(status == 0){
      color = Colors.green;
    }else if(status == 1){
      color = Colors.orange[800];
    }else if(status == 2){
      color = Colors.red;
    }else if(status == 3){
      color = Colors.grey;
    }
    return Text(locale.translation('order_type.$status'), 
      style: TextStyle(
        color: color,
        fontSize: 13
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderCardViewModel>(
      model: OrderCardViewModel(context, order, updateOrder),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        User curUser = model.order.masterUser(model.userId);
        bool isSell = model.order.isSell(model.userId);
        // if(model.order.seller == null){
        //   curUser = model.order.buyer;
        //   isSell = true;
        // }else{
        //   curUser = model.order.seller;
        //   isSell = false;
        // }
        return InkWell(
          onTap: model.toOrderDetail,
          child: Card(
            elevation: 0,
            child: Padding(
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
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: ExtCircleAvatar(curUser?.head, 30, strokeWidth: 0),
                        ),
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
                        child: ExtNetworkImage(model.order.product.img, 
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
                                child: PriceText(label: locale.translation('text.price'), price: model.order.price)
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}