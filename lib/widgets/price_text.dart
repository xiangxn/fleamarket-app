import 'package:bitsflea/common/funs.dart';
import 'package:flutter/material.dart';

class PriceText extends StatelessWidget{
  PriceText({
    Key key,
    this.label,
    this.price,
    this.fontSize,
    this.priceBold,
    this.priceColor
  }): super(key: key);

  final String label;
  final String price;
  final double fontSize;
  final bool priceBold;
  final Color priceColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label ?? '',
        children: [
          TextSpan(
            text: formatPrice2(price),
            style: TextStyle(
              color: priceColor ?? Colors.orange[700],
              fontWeight: priceBold ?? false ? FontWeight.bold : FontWeight.normal
            )
          )
        ]
      ),
      style: TextStyle(
        fontSize: fontSize ?? 12,
        color: Colors.grey[700]
      ),
    );
  }

}