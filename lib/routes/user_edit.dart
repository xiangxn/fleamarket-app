import 'dart:typed_data';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/photos_selector.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class UserEditRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserEditProvider>(
      listen: true,
      provider: UserEditProvider(context),
      builder: (ctx, provider, __) {
        final style = Provider.of<ThemeModel>(ctx, listen: false).theme;
        final user = Provider.of<UserModel>(ctx).user;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(provider.translate('user_edit.title')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                onPressed: provider.submit,
                child: Text(provider.translate('user_edit.done')),
              )
            ],
          ),
          body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: <Widget>[
                  LineButtonGroup(
                    margin: EdgeInsets.only(top: 10),
                    children: [
                      LineButtonItem(
                        text: provider.translate('user_edit.head'),
                        suffix: ExtCircleAvatar(user?.head ?? DEFAULT_HEAD, 60, data: provider.photo, strokeWidth: 0),
                        onTap: provider.changeHead,
                      ),
                      LineButtonItem(
                        text: provider.translate('user_edit.nickname'),
                        suffix: Container(
                            child: TextField(
                          controller: provider.controller,
                          autocorrect: false,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          decoration: InputDecoration(
                              isDense: true, hintText: user?.nickname, contentPadding: EdgeInsets.symmetric(vertical: 0), border: InputBorder.none),
                        )),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(color: style.backgroundColor),
                  )
                ],
              )),
        );
      },
    );
  }
}

class UserEditProvider extends BaseProvider {
  AssetEntity _photo;
  TextEditingController _controller;

  AssetEntity get photo => _photo;

  get controller => _controller;
  UserEditProvider(BuildContext context) : super(context) {
    _controller = new TextEditingController();
  }

  changeHead() async {
    Widget screen = PhotosSelectPage(
      title: translate('publish.photos_selector'),
    );
    List<dynamic> photos = await this.showDialog(screen);
    if (photos != null && photos.length != 0) {
      _photo = photos[0];
      notifyListeners();
    }
  }

  Future<bool> _setProfile({Uint8List head, String nickname}) async {
    final um = Provider.of<UserModel>(context, listen: false);
    final user = um.user;
    final keys = um.keys;
    if (head == null && nickname == null) return true;
    String headHash;
    String nn;
    if (head != null) {
      showLoading(this.translate("dialog.uploading"));
      final result = await api.uploadFile(head);
      closeLoading();
      if (result.code == 0) {
        headHash = result.msg;
      }
    }
    if (nickname != null && nickname.length > 0) {
      nn = nickname;
    }
    //print("head:$headHash, nickname:$nn");
    showLoading();
    final result = await api.setProfile(keys[1], user.eosid, head: headHash, nickname: nn);
    closeLoading();
    if (result) {
      // if (headHash != null) user.head = URL_IPFS_GATEWAY + headHash;
      if (headHash != null) user.head = headHash;
      if (nickname != null) user.nickname = nickname;
    }
    return result;
  }

  submit() async {
    // showLoading();
    Uint8List imgData;
    String name;
    if (_photo != null) imgData = await _photo.originBytes;
    if (_controller.text != null && _controller.text != "") name = _controller.text;
    final result = await _setProfile(head: imgData, nickname: name);
    // closeLoading();
    if (result) {
      pop();
    } else {
      showToast(translate("user_edit.save_failure"));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
