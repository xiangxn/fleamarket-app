import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotosSelectorViewModel extends BaseViewModel implements TickerProvider {
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

  PhotosSelectorViewModel(BuildContext context, int maxCount, List<AssetEntity> selectedPhotos) : super(context) {
    _tabs = [super.locale.translation('photos.album'), super.locale.translation('photos.camera')];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _maxCount = maxCount ?? 1;
    _selectedPhotos = _maxCount > 1 ? selectedPhotos ?? [] : [];
    resetOffset();
    init();
  }

  init() async {
    super.setBusy();
    // 等待页面完全弹出后再请求权限，否则会造成UI线程阻塞，出现弹出一半就跳出权限提示框
    await Future.delayed(Duration(milliseconds: 500));
    bool flag = await checkPermission();
    if (flag) {
      await initPhotos();
      await initcamera();
    }
    super.setBusy();
  }

  Future<bool> checkPermission() async {
    Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([PermissionGroup.photos, PermissionGroup.camera]);

    if (status[PermissionGroup.photos] != PermissionStatus.granted || status[PermissionGroup.camera] != PermissionStatus.granted) {
      bool res = await super.confirm(super.locale.translation('permission.album_camera'));
      if (res) {
        PermissionHandler().openAppSettings();
      } else {
        super.pop();
      }
      return false;
    }
    return true;
  }

  initPhotos() async {
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(type: RequestType.image);
    List<AssetEntity> photos = [];
    for (int i = 0; i < list.length; i++) {
      final aes = await list[i].getAssetListRange(start: 0, end: 300);
      photos.addAll(aes);
    }
    _photos = photos;
    notifyListeners();
  }

  initcamera() async {
    _cameras = await availableCameras();
    if (_cameras.length > 0) {
      _cameraController = CameraController(_cameras[_cameraId], ResolutionPreset.high);
      await _cameraController.initialize();
      notifyListeners();
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
    if (hasSelected(photo)) {
      _selectedPhotos.removeWhere((p) => p.id == photo.id);
    } else {
      if (_selectedPhotos.length >= _maxCount) {
        flag = false;
        super.toast(super.locale.translation('photos.max_photos', [_maxCount.toString()]));
      } else {
        _selectedPhotos.add(photo);
      }
    }
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
      _selectedPhotos.add(ae);
      if (_maxCount == 1) {
        done();
      } else {
        resetOffset();
        notifyListeners();
      }
    } else {
      super.toast(super.locale.translation('photos.max_photos', [_maxCount.toString()]));
    }
  }

  done() {
    super.pop(_selectedPhotos);
    print('完成');
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _cameraController?.dispose();
  }
}
