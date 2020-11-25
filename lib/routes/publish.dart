import 'dart:typed_data';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/common/location_data.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/address_selector.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:bitsflea/widgets/number_pad.dart';
import 'package:bitsflea/widgets/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'photos_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PublishRoute extends StatelessWidget {
  final Product product;
  PublishRoute({Key key, this.product}) : super(key: key);

  Widget _buildImg(PublishProvider provider, dynamic photo) {
    if (photo.runtimeType == AssetEntity) {
      AssetEntity p = (photo as AssetEntity);
      return FutureBuilder(
          future: p.thumbData,
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) return Image.memory(snapshot.data, fit: BoxFit.cover);
            return CircularProgressIndicator();
          });
    }
    return ExtNetworkImage('$URL_IPFS_GATEWAY$photo');
  }

  Widget _buildImgs(PublishProvider provider) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: provider.photosCount,
      itemBuilder: (_, i) {
        final photo = i < provider.photos.length ? provider.photos[i] : null;
        return GestureDetector(
          onTap: provider.selectPhotos,
          child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: photo != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(4), child: _buildImg(provider, photo))
                  : Icon(Icons.add, color: Colors.grey, size: 28)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<PublishProvider>(
      listen: true,
      provider: PublishProvider(context, product),
      builder: (_, provider, loading) {
        Global.console("publish build........");
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
            key: provider.scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.isUpdate ? provider.translate('publish.edit_goods') : provider.translate('publish.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: provider.busy
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
                                  maxLength: provider.titleLimit,
                                  maxLengthEnforced: false,
                                  textInputAction: TextInputAction.done,
                                  controller: provider.titleController,
                                  focusNode: provider.titleFocus,
                                  decoration: InputDecoration(
                                      hintText: provider.translate('publish.title_hint'),
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
                                  maxLength: provider.descLimit,
                                  maxLengthEnforced: false,
                                  textInputAction: TextInputAction.done,
                                  controller: provider.describeController,
                                  focusNode: provider.describeFocus,
                                  decoration: InputDecoration(
                                      hintText: provider.translate('publish.desc_hint'),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(8),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none))),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(8, 8, 8, 8), child: _buildImgs(provider)),
                              LineButtonGroup(
                                children: [
                                  LineButtonItem(
                                      text: provider.translate('publish.prices'),
                                      prefixIcon: Icons.monetization_on,
                                      subText: provider.prices,
                                      onTap: provider.showNumberPad),
                                  LineButtonItem(
                                      text: provider.translate('publish.type'),
                                      prefixIcon: FontAwesomeIcons.buffer,
                                      subText: provider.category.view,
                                      onTap: provider.showTypeSelector),
                                  LineButtonItem(
                                      text: provider.translate('publish.address'),
                                      prefixIcon: Icons.location_on,
                                      // prefixIconSize: 26,
                                      prefixPadding: 9,
                                      subText: provider.location,
                                      onTap: provider.showAddressSelector),
                                  Material(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 12),
                                              child: Icon(Icons.new_releases, size: 22, color: style.primarySwatch),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(provider.translate("publish.is_new")),
                                            ),
                                            Switch(value: provider.isNew, onChanged: provider.setIsNew),
                                          ],
                                        ),
                                      )),
                                  Material(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 12),
                                              child: Icon(Icons.verified, size: 22, color: style.primarySwatch),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(provider.translate("publish.is_returns")),
                                            ),
                                            Switch(value: provider.isReturn, onChanged: provider.setIsReturn),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              Offstage(
                                  offstage: provider.isUpdate,
                                  child: CustomButton(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.all(16),
                                    color: Colors.orange,
                                    onTap: provider.submit,
                                    text: provider.translate('publish.publish_text'),
                                  )),
                              Offstage(
                                  offstage: !(provider.product.status == ProductStatus.delisted),
                                  child: CustomButton(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.all(16),
                                    color: Colors.orange,
                                    onTap: provider.submit,
                                    text: provider.translate('controller.re_publish'),
                                  )),
                              Offstage(
                                  offstage: !(provider.product.status == ProductStatus.normal),
                                  child: CustomButton(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(8),
                                    padding: EdgeInsets.all(16),
                                    color: Colors.orange,
                                    onTap: provider.delPublish,
                                    text: provider.translate('controller.del_publish'),
                                  ))
                            ],
                          )),
                    ),
                  ));
      },
    );
  }
}

class PublishProvider extends BaseProvider {
  LocationData _locationData;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FocusNode _titleFocus = FocusNode();
  FocusNode _describeFocus = FocusNode();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  List<Category> _categories;
  Category _category;
  Product _product;
  String _location;

  double _pricingAmount = 0;
  double _freightAmount = 0;
  String _symbol;
  List<dynamic> _photos = [];
  int _maxCount = 8;
  bool _isUpdate = false;
  bool _isNew = false;
  bool _isReturn = true;

  PublishProvider(BuildContext context, Product product) : super(context) {
    _product = product ?? Product();
    _init();
  }

  bool get isNew => _isNew;
  bool get isReturn => _isReturn;
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
    String freight =
        _freightAmount == 0 ? translate('publish.none_freight') : translate('publish.freight', translationParams: {"amount": _freightAmount.toString()});
    return '$total（$freight）$_symbol';
  }

  get pricingAmount {
    return _pricingAmount.toStringAsFixed(COIN_PRECISION[_symbol]);
  }

  get freightAmount {
    return _freightAmount.toStringAsFixed(COIN_PRECISION[_symbol]);
  }

  get titleLimit => 20;
  get descLimit => 100;
  bool get isUpdate => _isUpdate;
  Product get product => _product;

  Future<BaseReply> fetchCategories() async {
    BaseReply res = await api.fetchCategories();
    if (res.code == 0) {
      _categories = convertEdgeList<Category>(res.data, "categories", Category());
    }
    return res;
  }

  _checkPrice(String price) {
    assert(price != null);
    assert(price.length > 1);
    final ps = price.split(" ");
    assert(ps.length == 2);
    return ps;
  }

  _getAmount(String price) {
    final ps = _checkPrice(price);
    double amount = 0;
    try {
      amount = double.parse(ps[0]);
    } catch (e) {
      amount = 0;
    }
    return amount;
  }

  _getSymbol(String price) {
    final ps = _checkPrice(price);
    return ps[1];
  }

  _init() async {
    setBusy();
    await fetchCategories();
    if (_product.productId != 0) {
      _isUpdate = true;
      final result = await api.fetchProductInfo(_product.productId);
      if (result.code == 0) {
        _product = convertEdge<Product>(result.data, "products", Product());
      }
      _pricingAmount = _getAmount(_product.price);
      _freightAmount = _getAmount(_product.postage);
      _symbol = _getSymbol(_product.price);
      _isNew = _product.isNew;
      _isReturn = _product.isReturns;
    } else {
      _pricingAmount = 0;
      _freightAmount = 0;
      _symbol = COIN_PRECISION.keys.first;
    }

    _titleController.text = _product.title ?? '';
    _describeController.text = _product.description ?? '';
    _location = _product.position ?? _location;
    _category = _product.category ?? _categories[_categories.length - 1];

    //处理已经上传的图片
    if (_product.photos.length > 0) {
      _photos.addAll(_product.photos);
    }

    await Future.delayed(Duration(milliseconds: 500));
    _locationData = LocationData(api);
    setBusy();
    notifyListeners();
  }

  checkHasFocus() {
    if (_titleFocus.hasFocus || _describeFocus.hasFocus) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  showNumberPad() async {
    checkHasFocus();
    Map<String, dynamic> prices = await showModalBottomSheet(
        context: context,
        builder: (_) => NumberPad(
              pricingAmount: _pricingAmount,
              freightAmount: _freightAmount,
              symbol: _symbol,
            ));
    if (prices != null) {
      _pricingAmount = prices['pricingAmount'] ?? 0;
      _freightAmount = prices['freightAmount'] ?? 0;
      _symbol = prices['symbol'];
      notifyListeners();
    }
  }

  showTypeSelector() async {
    checkHasFocus();
    Widget screen = TypeSelector(
      title: translate('publish.type_selector'),
      categories: _categories,
    );
    Category ctype = await this.showDialog(screen);
    if (ctype != null) {
      _category = ctype;
      notifyListeners();
    }
  }

  showAddressSelector() async {
    checkHasFocus();
    Widget screen = AddressSelector(
      title: translate('publish.address_selector'),
      locationData: _locationData,
    );
    Address local = await this.showDialog(screen);
    if (local != null) {
      _location = local.toString();
      notifyListeners();
    }
  }

  selectPhotos() async {
    Widget screen = PhotosSelectPage(
      title: translate('publish.photos_selector'),
      maxCount: _maxCount,
      selectedPhotos: [..._photos],
    );
    List<dynamic> photos = await this.showDialog(screen);
    if (photos != null && photos.length != 0) {
      _photos = photos;
      notifyListeners();
    }
  }

  Future<Map<int, BaseReply>> _uploadFile(Uint8List data, int index) async {
    BaseReply res = await api.uploadFile(data);
    return {index: res};
  }

  Future<bool> _publishProduct(EOSPrivateKey actKey, String eosid, int userId, Map product, List<dynamic> photos) async {
    if (photos != null) {
      var list = (product['photos'] as List);
      if (list.length < photos.length) {
        list.length = photos.length;
      }
      var futures = List<Future<Map<int, BaseReply>>>();
      for (int i = 0; i < photos.length; i++) {
        if (photos[i].runtimeType == AssetEntity) {
          final photo = (photos[i] as AssetEntity);
          final data = await photo.originBytes;
          futures.add(_uploadFile(data, i));
        } else {
          list[i] = photos[i];
        }
      }
      if (futures.length > 0) {
        try {
          showLoading(this.translate("dialog.uploading"));
          final resList = await Future.wait(futures);
          closeLoading();
          Global.console("uploadFiles: $resList");
          if (resList.length > 0) {
            resList.forEach((f) {
              if (f.values.first.code == 0) {
                list[f.keys.first] = f.values.first.msg;
              } else {
                Global.console("uploadFiles: upload failed. [${f.values.first.msg}]");
              }
            });
          }
        } catch (e) {
          Global.console("uploadFiles Error: $e");
          return false;
        }
      }
    }
    // print("product: $product");
    showLoading();
    final res = await api.publishProduct(actKey, eosid, userId, product);
    closeLoading();
    return res;
  }

  submit() async {
    _product.title = _titleController.text;
    _product.description = _describeController.text;
    _product.price = '${this.pricingAmount} ${this._symbol}';
    _product.postage = '${this.freightAmount} ${this._symbol}';
    _product.position = this._location;
    _product.status = ProductStatus.publish;
    _product.isReturns = this.isReturn;
    _product.isNew = this.isNew;
    if (_product.title.isEmpty) {
      showToast(translate('message.goods_title_empty'));
      return;
    } else if (_product.title.length > this.titleLimit) {
      showToast(translate('message.goods_title_limit'));
      return;
    } else if (_product.description.isEmpty) {
      showToast(translate('message.goods_desc_empty'));
      return;
    } else if (_product.description.length > this.descLimit) {
      showToast(translate('message.goods_desc_limit'));
      return;
    } else if (this._photos.length == 0) {
      showToast(translate('message.goods_photos_empty'));
      return;
    } else if (this._pricingAmount == 0) {
      showToast(translate('message.goods_price_empty'));
      return;
    } else if (_product.position == null || _product.position.isEmpty) {
      showToast(translate('message.goods_location_empty'));
      return;
    }
    bool isDo = true;
    if (this._isUpdate) {
      isDo = await confirm(translate('message.goods_re_publish'));
    }
    if (isDo) {
      final um = Provider.of<UserModel>(context, listen: false);
      // showLoading();
      Map product = {
        "pid": _product.productId,
        "uid": um.user.userid,
        "title": _product.title,
        "description": _product.description,
        "photos": [],
        "category": _category.cid,
        "status": _product.status,
        "is_new": _product.isNew,
        "is_returns": _product.isReturns,
        "reviewer": 0,
        "sale_method": 0,
        "price": _product.price,
        "transaction_method": 1,
        "stock_count": 1,
        "is_retail": false,
        "postage": _product.postage,
        "position": _product.position,
        "release_time": DateTime.now().toIso8601String()
      };
      final result = await _publishProduct(um.keys[1], um.user.eosid, um.user.userid, product, _photos);
      // closeLoading();
      if (result) {
        if (this._isUpdate)
          pop(_product);
        else
          pop();
      } else {
        showToast(translate("publish.failure"));
      }
    }
  }

  delPublish() async {
    if (await confirm(translate('message.goods_del_publish'))) {
      showLoading();
      final um = Provider.of<UserModel>(context, listen: false);
      final user = um.user;
      final res = await api.pulloff(um.keys[1], user.userid, user.eosid, _product.productId);
      closeLoading();
      if (res.code == 0) {
        pop();
      } else {
        showToast(getErrorMessage(res.msg));
      }
    }
  }

  setIsNew(v) {
    this._isNew = v;
    notifyListeners();
  }

  setIsReturn(v) {
    this._isReturn = v;
    notifyListeners();
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
