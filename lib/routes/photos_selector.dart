import 'dart:io';
import 'dart:typed_data';

import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotosSelectPage extends StatelessWidget {
  final String title;
  final int maxCount;
  final List<AssetEntity> selectedPhotos;

  PhotosSelectPage({Key key, this.title, this.maxCount, this.selectedPhotos}) : super(key: key);

  _buildCamera(PhotosSelectPageProvider provider) {
    return FutureBuilder(
        future: provider.initcamera(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && provider.cameraInit) {
            return ClipRect(
                child: Selector<PhotosSelectPageProvider, int>(
              selector: (ctx, provider) => provider.cameraId,
              builder: (ctx, cid, _) {
                return Container(
                  child: Transform.scale(
                    scale: 1 / provider.cameraController.value.aspectRatio,
                    child: Center(
                      child: AspectRatio(aspectRatio: provider.cameraController.value.aspectRatio, child: CameraPreview(provider.cameraController)),
                    ),
                  ),
                );
              },
            ));
          } else {
            return Container(color: Colors.black);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<PhotosSelectPageProvider>(
      provider: PhotosSelectPageProvider(context, this.maxCount, this.selectedPhotos),
      builder: (_, provider, child) {
        print('photos selector build .......');
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(this.title),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
            actions: <Widget>[FlatButton(onPressed: provider.done, child: Text(provider.translate('photos.done')))],
          ),
          body: Column(
            children: <Widget>[
              TabBar(
                controller: provider.tabController,
                labelColor: style.primarySwatch,
                unselectedLabelColor: Colors.black,
                tabs: provider.tabs.map((t) => Tab(text: t)).toList(),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: provider.offset,
                        duration: Duration(milliseconds: 150),
                        child: TabBarView(controller: provider.tabController, children: [
                          FutureBuilder(
                              future: provider.initPhotos(),
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return GridView.builder(
                                      physics: ClampingScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 1, crossAxisSpacing: 1, crossAxisCount: 4),
                                      itemCount: provider.photos.length,
                                      itemBuilder: (_, i) {
                                        AssetEntity photo = provider.photos[i];
                                        return GestureDetector(
                                          onTap: () => provider.selectPhoto(photo),
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
                                                child: Selector<PhotosSelectPageProvider, bool>(
                                                    selector: (ctx, provider) => provider.hasSelected(photo),
                                                    builder: (ctx, hasSelected, widget) {
                                                      return Icon(
                                                        hasSelected ? Icons.check_circle : Icons.check_circle_outline,
                                                        color: hasSelected ? style.primarySwatch : Colors.grey[500],
                                                      );
                                                    }))
                                          ]),
                                        );
                                      });
                                }
                                return child;
                              }),
                          Stack(
                            children: <Widget>[
                              _buildCamera(provider),
                              Selector<PhotosSelectPageProvider, List<AssetEntity>>(
                                  selector: (ctx, provider) => provider.selectedPhotos,
                                  builder: (ctx, list, _) {
                                    return Positioned(
                                      bottom: provider.offset,
                                      left: 0,
                                      right: 0,
                                      height: 90,
                                      child: Center(
                                          child: DecoratedBox(
                                              decoration: BoxDecoration(shape: BoxShape.circle, color: style.primarySwatch),
                                              child: IconButton(
                                                icon: Icon(Icons.camera_alt, color: Colors.white),
                                                onPressed: provider.takePhoto,
                                              ))),
                                    );
                                  }),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(Icons.loop, color: style.primarySwatch),
                                  onPressed: provider.switchCamera,
                                ),
                              )
                            ],
                          )
                        ])),
                    Selector<PhotosSelectPageProvider, List<AssetEntity>>(
                        selector: (ctx, provider) => provider.selectedPhotos,
                        builder: (ctx, list, _) {
                          return AnimatedPositioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: provider.offset,
                            duration: Duration(milliseconds: 150),
                            child: Container(
                                decoration: style.shadowBottom,
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(5),
                                    itemExtent: 75,
                                    itemCount: list.length,
                                    itemBuilder: (_, i) {
                                      AssetEntity photo = list[i];
                                      return GestureDetector(
                                          onTap: () => provider.selectPhoto(photo),
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
                                    })),
                          );
                        }),
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

class PhotosSelectPageProvider extends BaseProvider implements TickerProvider {
  TabController _tabController;
  List<String> _tabs;
  CameraController _cameraController;
  List<CameraDescription> _cameras;
  int _cameraId = 0;
  List<AssetEntity> _photos = [];
  List<AssetEntity> _selectedPhotos;
  double _offset = 0;
  int _maxCount;

  TabController get tabController => _tabController;
  List<String> get tabs => _tabs;
  CameraController get cameraController => _cameraController;
  bool get cameraInit => _cameraController?.value?.isInitialized ?? false;
  List<AssetEntity> get photos => _photos;
  List<AssetEntity> get selectedPhotos => _selectedPhotos;
  double get offset => _offset;
  int get cameraId => _cameraId;

  PhotosSelectPageProvider(BuildContext context, int maxCount, List<AssetEntity> selectedPhotos) : super(context) {
    _tabs = [translate('photos.album'), translate('photos.camera')];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _maxCount = maxCount ?? 1;
    _selectedPhotos = _maxCount > 1 ? selectedPhotos ?? [] : [];
    resetOffset();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _cameraController?.dispose();
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }

  init() async {
    setBusy();
    // 等待页面完全弹出后再请求权限，否则会造成UI线程阻塞，出现弹出一半就跳出权限提示框
    await Future.delayed(Duration(milliseconds: 500));
    bool flag = await checkPermission();
    if (flag) {
      // await initPhotos();
      // await initcamera();
    }
    setBusy();
  }

  Future<bool> checkPermission() async {
    Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.photos, PermissionGroup.camera]);

    if (status[PermissionGroup.photos] != PermissionStatus.granted || status[PermissionGroup.camera] != PermissionStatus.granted) {
      bool res = await confirm(translate('permission.album_camera'));
      if (res) {
        PermissionHandler().openAppSettings();
      } else {
        pop();
      }
      return false;
    }
    return true;
  }

  initPhotos() async {
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(type: RequestType.image);
    List<AssetEntity> photos = [];
    for (int i = 0; i < list.length; i++) {
      final aes = await list[i].getAssetListRange(start: 0, end: 1000);
      photos.addAll(aes);
    }
    _photos = photos;
    // notifyListeners();
  }

  initcamera() async {
    _cameras = await availableCameras();
    if (_cameras.length > 0) {
      _cameraController = CameraController(_cameras[_cameraId], ResolutionPreset.high);
      await _cameraController.initialize();
      // notifyListeners();
    }
  }

  resetOffset() {
    _offset = _selectedPhotos.length > 0 ? 80 : 0;
  }

  bool hasSelected(AssetEntity photo) {
    return _selectedPhotos.indexWhere((p) => p.id == photo.id) >= 0;
  }

  selectPhoto(AssetEntity photo) {
    bool flag = true;
    var list = [..._selectedPhotos];
    if (hasSelected(photo)) {
      list.removeWhere((p) => p.id == photo.id);
    } else {
      if (list.length >= _maxCount) {
        flag = false;
        showToast(translate('photos.max_photos', translationParams: {"max": _maxCount.toString()}));
      } else {
        list.add(photo);
      }
    }
    _selectedPhotos = list;
    if (_maxCount == 1) {
      done();
    } else if (flag) {
      resetOffset();
      notifyListeners();
    }
  }

  switchCamera() async {
    if (_cameras.length >= 2) {
      _cameraId = _cameraId == 0 ? 1 : 0;
      _cameraController = CameraController(_cameras[_cameraId], ResolutionPreset.medium);
      await _cameraController.initialize();
      notifyListeners();
    }
  }

  takePhoto() async {
    if (_selectedPhotos.length < _maxCount) {
      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/tmp.png';
      await _cameraController.takePicture(path);
      AssetEntity ae = await PhotoManager.editor.saveImageWithPath(path);
      var list = [..._selectedPhotos];
      list.add(ae);
      _selectedPhotos = list;
      if (_maxCount == 1) {
        done();
      } else {
        resetOffset();
        notifyListeners();
      }
    } else {
      showToast(translate('photos.max_photos', translationParams: {"max": _maxCount.toString()}));
    }
  }

  done() {
    pop(_selectedPhotos);
    print('完成照片选择...');
  }
}
