import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/photos_selector_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotosSelector extends StatelessWidget {
  final String title;
  final int maxCount;
  final List<AssetEntity> selectedPhotos;

  PhotosSelector({Key key, this.title, this.maxCount, this.selectedPhotos}) : super(key: key);

  _buildCamera(PhotosSelectorViewModel model) {
    if (model.cameraInit) {
      return ClipRect(
        child: Container(
          child: Transform.scale(
            scale: 1 / model.cameraController.value.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: model.cameraController.value.aspectRatio,
                child: CameraPreview(model.cameraController),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<PhotosSelectorViewModel>(
      listen: true,
      model: PhotosSelectorViewModel(context, this.maxCount, this.selectedPhotos),
      builder: (_, model, child) {
        print('photos selector build .......');
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(this.title),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            actions: <Widget>[FlatButton(onPressed: model.done, child: Text(locale.translation('photos.done')))],
          ),
          body: Column(
            children: <Widget>[
              TabBar(
                controller: model.tabController,
                labelColor: Style.mainColor,
                unselectedLabelColor: Colors.black,
                tabs: model.tabs.map((t) => Tab(text: t)).toList(),
              ),
              Expanded(
                child: model.busy
                    ? child
                    : Stack(
                        children: <Widget>[
                          AnimatedPositioned(
                              left: 0,
                              top: 0,
                              right: 0,
                              bottom: model.offset,
                              duration: Duration(milliseconds: 150),
                              child: TabBarView(controller: model.tabController, children: [
                                GridView.builder(
                                    physics: ClampingScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 1, crossAxisSpacing: 1, crossAxisCount: 4),
                                    itemCount: model.photos.length,
                                    itemBuilder: (_, i) {
                                      AssetEntity photo = model.photos[i];
                                      bool hasSelected = model.hasSelected(photo);
                                      return GestureDetector(
                                        onTap: () => model.selectPhoto(photo),
                                        child: Stack(children: [
                                          Positioned.fill(
                                              child: FutureBuilder(
                                            future: photo.thumbData,
                                            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                              if (snapshot.hasData)
                                                return Image.memory(snapshot.data, fit: BoxFit.cover);
                                              else
                                                return CircularProgressIndicator();
                                            },
                                          )),
                                          Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Icon(
                                                hasSelected ? Icons.check_circle : Icons.check_circle_outline,
                                                color: hasSelected ? Colors.green : Colors.grey[500],
                                              ))
                                        ]),
                                      );
                                    }),
                                Stack(
                                  children: <Widget>[
                                    _buildCamera(model),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      height: 90,
                                      child: Center(
                                          child: DecoratedBox(
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                              child: IconButton(
                                                icon: Icon(Icons.camera_alt, color: Colors.white),
                                                onPressed: model.takePhoto,
                                              ))),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        icon: Icon(Icons.loop, color: Colors.green),
                                        onPressed: model.switchCamera,
                                      ),
                                    )
                                  ],
                                )
                              ])),
                          AnimatedPositioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: model.offset,
                            duration: Duration(milliseconds: 150),
                            child: Container(
                              decoration: Style.shadowBottom,
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.all(5),
                                  itemExtent: 75,
                                  itemCount: model.selectedPhotos.length,
                                  itemBuilder: (_, i) {
                                    AssetEntity photo = model.selectedPhotos[i];
                                    return GestureDetector(
                                        onTap: () => model.selectPhoto(photo),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                                          child: Stack(children: [
                                            Positioned.fill(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(3),
                                                    child: FutureBuilder(
                                                      future: photo.thumbData,
                                                      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                                        if (snapshot.hasData)
                                                          return Image.memory(snapshot.data, fit: BoxFit.cover);
                                                        else
                                                          return CircularProgressIndicator();
                                                      },
                                                    ))),
                                            Positioned(
                                                top: 3,
                                                right: 3,
                                                child: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                  size: 18,
                                                ))
                                          ]),
                                        ));
                                  }),
                            ),
                          )
                        ],
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
