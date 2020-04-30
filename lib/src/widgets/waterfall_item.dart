// import 'package:fleamarket/src/models/goods.dart';
// import 'package:fleamarket/src/view_models/shop_view_model.dart';
// import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
// import 'package:fleamarket/src/widgets/ext_network_image.dart';
// import 'package:flutter/material.dart';

// class WaterfallItem extends StatelessWidget{
//   WaterfallItem({
//     Key key,
//     @required this.goods,
//     @required this.model
//   }): super(key: key);

//   final Goods goods;
//   final ShopViewModel model;

//   _handleTap(BuildContext context){
//     Navigator.of(context).pushNamed('detail');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: <Widget>[
//           Hero(
//             tag: 'goodsImg${goods.category}${goods.productId}',
//             child: ExtNetworkImage(
//               goods.img,
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
//               onTap: () => _handleTap(context),
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
//             child: Text(
//               goods.title, 
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold
//               ),
//               overflow: TextOverflow.ellipsis, 
//               maxLines: 2
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 ExtCircleAvatar(goods.owner.head, 20, strokeWidth: 0),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 6, right: 2),
//                     child: Text(
//                       goods.owner.nickname,
//                       textAlign: TextAlign.left,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[800]
//                         )
//                       ),
//                   ),
//                 ),
//                 GestureDetector(
//                   child: Row(
//                     children: <Widget>[
//                       Text(
//                         goods.collections.toString(), 
//                         style: TextStyle(
//                           fontSize: 12
//                         )
//                       ),
//                       SizedBox(width: 4),
//                       Icon(
//                         goods.hasCollection() ? Icons.favorite : Icons.favorite_border, 
//                         size: 14,
//                         color: goods.hasCollection() ? Colors.green : Colors.grey,
//                         )
//                     ],
//                   ),
//                   onTap: () => model.favorite(goods),
//                 )
//               ]
//             ),
//           )
//         ]
//       ),
//     );
//   }
// }