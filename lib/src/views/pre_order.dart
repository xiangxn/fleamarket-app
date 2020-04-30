import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/view_models/pre_order_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/address_select_card.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:fleamarket/src/widgets/price_text.dart';
import 'package:flutter/material.dart';

class PreOrder extends StatelessWidget{
  PreOrder({
    Key key,
    this.goods
  }) : super(key: key);

  final Goods goods;

  @override
  Widget build(BuildContext context) {
    return BaseView<PreOrderViewModel>(
      listen: true,
      model: PreOrderViewModel(context, goods),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.pre_order')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: ExtNetworkImage(goods.imgs[0], 
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
                                    child: Text(goods.title),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          PriceText(label: locale.translation('text.price'), price: goods.price),
                                          PriceText(label: locale.translation('text.postage'), price: goods.postage)
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  AddressSelectCard(
                    onTap: model.selectAddress,
                    address: model.address,
                    noDataHints: locale.translation('message.address_no_data'),
                  )
                ],
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      PriceText(
                        label: locale.translation('text.total_price'), 
                        price: goods.total, 
                        fontSize: 14, 
                        priceBold: true
                      ),
                      CustomButton(
                        onTap: model.submit,
                        text: locale.translation('controller.confirm_buy'),
                      )
                    ],
                  ),
                ),
              )
            ]
          ),
        );
      },
    );
  }
}