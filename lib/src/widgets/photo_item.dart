import 'dart:io';

import 'package:flutter/material.dart';

class PhotoItem extends StatefulWidget{

  PhotoItem({
    Key key,
    @required this.path,
    this.width = 200
  }): super(key: key);

  final String path;
  int width;

  @override
  State<StatefulWidget> createState() => _PhotoItem();

}

class _PhotoItem extends State<PhotoItem>{

  Widget _child = Padding(
    padding: EdgeInsets.all(20),
    child: CircularProgressIndicator(
      strokeWidth: 2,
    )
  );

  @override
  void initState() {
    super.initState();
    Image tmp = Image(
      image: Image.file(
        File(widget.path),
        cacheWidth: widget.width,
      ).image,
      fit: BoxFit.cover,
    );

    tmp.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _){
      setState(() {
        _child = tmp;
      });
      print('image绘制完成');
    }));
  }

  @override
  Widget build(BuildContext context) {
    
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation){
        return ScaleTransition(child: child, scale: animation);
      },
      child: _child,
    );
    // return Image(
    //   image: Image.file(
    //     File(path),
    //     cacheWidth: this.width,
    //   ).image,
    //   fit: BoxFit.cover,
    // );
  }
}