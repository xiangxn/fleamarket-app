import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/views/photos_selector.dart';
import 'package:flutter/material.dart';
import 'package:simple_photos_manager/simple_photo.dart';

class UserEditViewModel extends BaseViewModel{
  UserEditViewModel(BuildContext context) : super(context){
    _controller = TextEditingController();
  }

  SimplePhoto _photo ;
  TextEditingController _controller;

  SimplePhoto get photo => _photo;
  get controller => _controller;

  changeHead() async {
    Widget screen = PhotosSelector(
      title: super.locale.translation('publish.photos_selector'),
    );
    List<SimplePhoto> photos = await super.dialog(screen);
    if(photos != null && photos.length != 0){
      _photo = photos[0];
      // notifyListeners();
    }
  }

  submit(){
    //TODO: 处理更新用户业务
    super.pop();
  }  

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}