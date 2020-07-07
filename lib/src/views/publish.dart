import 'dart:typed_data';

import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/view_models/publish_view_model.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'base_view.dart';

class Publish extends StatelessWidget {
  Publish({Key key, this.goods}) : super(key: key);
  final Goods goods;

  @override
  Widget build(BuildContext context) {
    return BaseView<PublishViewModel>(
      listen: true,
      model: PublishViewModel(context, goods),
      builder: (_, model, loading) {
        ExtLocale locale = model.locale;
        return Scaffold(
            key: model.scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(model.isUpdate ? locale.translation('title.edit_goods') : locale.translation('publish.title')),
              backgroundColor: Style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: Style.headerTextTheme,
              iconTheme: Style.headerIconTheme,
            ),
            body: model.busy
                ? loading
                : GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          primary: true,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: TextField(
                                  maxLines: 1,
                                  maxLength: model.titleLimit,
                                  maxLengthEnforced: false,
                                  textInputAction: TextInputAction.done,
                                  controller: model.titleController,
                                  focusNode: model.titleFocus,
                                  decoration: InputDecoration(
                                      hintText: locale.translation('publish.title_hint'),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(8),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: TextField(
                                  maxLines: 6,
                                  maxLength: model.descLimit,
                                  maxLengthEnforced: false,
                                  textInputAction: TextInputAction.done,
                                  controller: model.describeController,
                                  focusNode: model.describeFocus,
                                  decoration: InputDecoration(
                                      hintText: locale.translation('publish.desc_hint'),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(8),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: model.photosCount,
                                  itemBuilder: (_, i) {
                                    AssetEntity photo = i < model.photos.length ? model.photos[i] : null;
                                    return GestureDetector(
                                      onTap: model.selectPhotos,
                                      child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: photo != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: FutureBuilder(
                                                      future: photo.thumbData,
                                                      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                                        if (snapshot.hasData) return Image.memory(snapshot.data, fit: BoxFit.cover);
                                                        return CircularProgressIndicator();
                                                      }),
                                                )
                                              : Icon(Icons.add, color: Colors.grey, size: 28)),
                                    );
                                  },
                                ),
                              ),
                              LineButtonGroup(
                                children: [
                                  LineButtonItem(
                                      text: locale.translation('publish.prices'),
                                      prefixIcon: Icons.monetization_on,
                                      subText: model.prices,
                                      onTap: model.showNumberPad),
                                  LineButtonItem(
                                      text: locale.translation('publish.type'),
                                      prefixIcon: Icons.local_mall,
                                      subText: model.category.view,
                                      onTap: model.showTypeSelector),
                                  LineButtonItem(
                                      text: locale.translation('publish.address'),
                                      prefixIcon: Icons.location_on,
                                      subText: model.location,
                                      onTap: model.showAddressSelector),
                                ],
                              ),
                              CustomButton(
                                width: double.infinity,
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(16),
                                onTap: model.submit,
                                text: locale.translation(model.isUpdate ? 'controller.re_publish' : 'publish.publish_text'),
                              ),
                              Offstage(
                                offstage: !model.isUpdate,
                                child: CustomButton(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(16),
                                  color: Colors.red[500],
                                  onTap: model.delPublish,
                                  text: locale.translation('controller.del_publish'),
                                ),
                              )
                            ],
                          )),
                    ),
                  ));
      },
    );
  }
}
