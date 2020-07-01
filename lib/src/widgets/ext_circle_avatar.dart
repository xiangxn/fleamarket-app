import 'dart:typed_data';

import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ExtCircleAvatar extends StatelessWidget {
  ExtCircleAvatar(this.url, this.size, {Key key, this.strokeWidth = 3, this.strokeColor = Colors.white, this.data}) : super(key: key);

  final String url;
  final double size;
  final double strokeWidth;
  final Color strokeColor;
  final AssetEntity data;

  _createImg() {
    int intSize = this.size.round();
    if (data != null) {
      return FutureBuilder(
        future: data.thumbData,
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          return CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: Image.memory(snapshot.data, cacheWidth: intSize, cacheHeight: intSize).image,
          );
        },
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
    return this.url ?? DEFAULT_HEAD;
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
      child: _createImg(),
    );
  }
}
