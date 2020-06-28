import 'dart:typed_data';

import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/services/location_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/views/address_selector.dart';
import 'package:fleamarket/src/views/photos_selector.dart';
import 'package:fleamarket/src/views/type_selector.dart';
import 'package:fleamarket/src/widgets/number_pad.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PublishViewModel extends BaseViewModel{
  GoodsService _goodsService ;
  LocationService _locationService ;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FocusNode _titleFocus = FocusNode();
  FocusNode _describeFocus = FocusNode();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  List<Category> _categories ;
  Category _category ;
  String _location ;
  // String _locationAdcode ;
  double _pricingAmount = 0;
  double _freightAmount = 0;
  String _symbol ;
  List<AssetEntity> _photos = [];
  int _maxCount = 8;
  bool _isUpdate = false;
  Goods _goods ;

  get scaffoldKey => _scaffoldKey;
  get titleFocus => _titleFocus;
  get describeFocus => _describeFocus;
  get titleController => _titleController;
  get describeController => _describeController;
  get categories => _categories;
  get category => _category;
  get location => _location;
  get photos => _photos;
  get photosCount => _photos.length == _maxCount ? _photos.length : _photos.length + 1;
  get prices {
    double total = _pricingAmount + _freightAmount;
    String freight = _freightAmount == 0 ? 
      super.locale.translation('publish.none_freight') : 
      super.locale.translation('publish.freight', [_freightAmount.toString()]);
    return '$total（$freight）$_symbol';
  }
  get titleLimit => 20;
  get descLimit => 100;
  get isUpdate => _isUpdate;
  get goods => _goods;

  PublishViewModel(BuildContext context, Goods param) : super(context){
    _goodsService = Provider.of<GoodsService>(context, listen: false);
    _locationService = Provider.of<LocationService>(context, listen: false);
    _categories = _goodsService.categories;
    _category = _categories.last;
    _location = _locationService.getAddress();
    _symbol = _goodsService.symbols.first['key'];
    _goods = param ?? Goods();
    init();
  }

  init() async {
    super.setBusy();
    if(_goods.productId != null){
      _isUpdate = true;
      var process = _goodsService.fetchGoodsInfo(_goods.productId, userId);
      ExtResult res = await super.processing(process, showLoading: false);
      if(res.code == 0){
        _goods = res.data;
      }
    }
    _titleController.text = _goods.title ?? '';
    _describeController.text = _goods.desc ?? '';
    _location = _goods.position ?? _locationService.getAddress();
    _category = _categories[_goods.category ?? _categories.length - 1];
    _pricingAmount = _goods.priceAmount ?? 0;
    _freightAmount = _goods.postageAmount ?? 0;
    _symbol = _goods.symbol ?? _goodsService.symbols.first['key'];

    _goods.imgs = _goods.imgs ?? List<String>();
    // _photos = await Future.wait(_goods.imgs.map<Future<AssetEntity>>((path) async {
    //   Uint8List imgData = await Utils.getImageData(path);
    //   var ae = AssetEntity(id:path);
    //   ae.
    //   return SimplePhoto(path, 0, 0, 0, imgData);
    // }).toList());
    super.setBusy();
    notifyListeners();
  }

  showNumberPad() async {
    checkHasFocus();
    Map<String, dynamic> prices = await showModalBottomSheet(
      context: context,
      builder: (_) => NumberPad(pricingAmount: _pricingAmount, freightAmount: _freightAmount, symbol: _symbol,)
    );
    if(prices != null){
      _pricingAmount = prices['pricingAmount'] ?? 0;
      _freightAmount = prices['freightAmount'] ?? 0;
      _symbol = prices['symbol'];
      notifyListeners();
    }
  }

  showTypeSelector() async {
    checkHasFocus();
    Widget screen = TypeSelector(
      title: super.locale.translation('publish.type_selector'),
      categories: _categories,
    );
    Category category = await super.dialog(screen);
    if(category != null){
      _category = category;
    }
  }

  showAddressSelector() async {
    checkHasFocus();
    Widget screen = AddressSelector(
      title: super.locale.translation('publish.address_selector'),
    );
    String adcode = await super.dialog(screen);
    if(adcode != null){
      _location = _locationService.getAddress(adcode);
    }
  }

  checkHasFocus(){
    if(_titleFocus.hasFocus || _describeFocus.hasFocus){
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  selectPhotos() async {
    Widget screen = PhotosSelector(
      title: super.locale.translation('publish.photos_selector'),
      maxCount: _maxCount,
      selectedPhotos: [..._photos],
    );
    List<AssetEntity> photos = await super.dialog(screen);
    if(photos != null && photos.length != 0){
      _photos = photos;
    }
  }

  submit() async {
    _goods.title = _titleController.text;
    _goods.desc = _describeController.text;
    _goods.price = '${this._pricingAmount} ${this._symbol}';
    _goods.postage = '${this._freightAmount} ${this._symbol}';
    _goods.position = this._location;
    if(_goods.title.isEmpty){
      toast(super.locale.translation('message.goods_title_empty'));
    }else if(_goods.title.length > this.titleLimit){
      toast(super.locale.translation('message.goods_title_limit'));
    }else if(_goods.desc.isEmpty){
      toast(super.locale.translation('message.goods_desc_empty'));
    }else if(_goods.desc.length > this.descLimit){
      toast(super.locale.translation('message.goods_desc_limit'));
    }else if(this._photos.length == 0){
      toast(super.locale.translation('message.goods_photos_empty'));
    }else if(this._pricingAmount == 0){
      toast(super.locale.translation('message.goods_price_empty'));
    }else if(this._location == null || this._location.isEmpty){
      toast(super.locale.translation('message.goods_location_empty'));
    }else{
      if(this._isUpdate){
        if(await super.confirm(super.locale.translation('message.goods_re_publish'))){
          // toast('重新编辑');
          super.pop();
        }
      }else{
        // toast('提交');
        super.pop();
      }
    }
  }

  delPublish() async {
    if(await super.confirm(super.locale.translation('message.goods_del_publish'))){
      // toast('下架商品');
      super.pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _describeFocus?.dispose();
    _titleFocus?.dispose();
    _describeController?.dispose();
    _titleController?.dispose();
  }
}