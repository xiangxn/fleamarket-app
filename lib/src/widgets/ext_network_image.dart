import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef void OnTapEvent();

class ExtNetworkImage extends StatelessWidget{
  ExtNetworkImage(
    this.url, 
    {
      Key key,
      this.width,
      this.height,
      this.borderRadius,
      this.placeholder,
      this.imageBuilder,
      this.onTap
    }
  ): super(key: key);

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final dynamic placeholder;
  final ImageWidgetBuilder imageBuilder;
  final OnTapEvent onTap;

  Widget _placeholder(context, url){
    assert(this.placeholder is bool || this.placeholder is Widget || this.placeholder == null);
    var p ;
    if(this.placeholder == null || this.placeholder is bool){
      p = this.placeholder ?? true ? Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          )
        )
      ) : null;
    }else if(this.placeholder is Widget){
      p = this.placeholder;
    }
    return p;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: ClipRRect(
        borderRadius: this.borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: this.url,
          width: this.width,
          height: this.height,
          placeholder: _placeholder,
          imageBuilder: this.imageBuilder
        ),
      ),
    );
  }

}