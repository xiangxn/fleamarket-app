import 'dart:typed_data';

import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:flutter/material.dart';

class ExtCircleAvatar extends StatelessWidget {
  ExtCircleAvatar(this.url, this.size, {Key key, this.strokeWidth = 3, this.strokeColor = Colors.white, this.data}) : super(key: key);

  final String url;
  final double size;
  final double strokeWidth;
  final Color strokeColor;
  final Uint8List data;

  _buildImg() {
    int intSize = this.size.round();
    if (this.data != null) {
      return CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: Image.memory(this.data, cacheWidth: intSize, cacheHeight: intSize).image,
      );
    } else {
      return ExtNetworkImage(
        getUrl,
        placeholder: false,
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: imageProvider,
          );
        },
      );
    }
  }

  String get getUrl {
    if (this.url == null || this.url == "") return DEFAULT_HEAD;
    return this.url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        color: this.strokeColor,
        border: Border.all(color: this.strokeColor, width: this.strokeWidth),
        borderRadius: BorderRadius.all(Radius.circular(this.size / 2)),
      ),
      child: _buildImg(),
    );
  }
}
