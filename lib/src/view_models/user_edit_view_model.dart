import 'dart:typed_data';

import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/views/photos_selector.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class UserEditViewModel extends BaseViewModel {
  UserEditViewModel(BuildContext context) : super(context) {
    _controller = TextEditingController();
  }

  AssetEntity _photo;
  TextEditingController _controller;

  AssetEntity get photo => _photo;

  get controller => _controller;

  changeHead() async {
    Widget screen = PhotosSelector(
      title: super.locale.translation('publish.photos_selector'),
    );
    List<AssetEntity> photos = await super.dialog(screen);
    if (photos != null && photos.length != 0) {
      _photo = photos[0];
    }
  }

  submit() async {
    loading();
    Uint8List imgData;
    String name;
    if (_photo != null) imgData = await _photo.originBytes;
    if (_controller.text != null && _controller.text != "") name = _controller.text;
    final result = await accountService.setProfile(head: imgData, nickname: name);
    loading();
    if (result) {
      pop();
    } else {
      toast("保存失败");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
