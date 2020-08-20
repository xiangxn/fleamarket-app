import 'dart:typed_data';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/location_data.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/address_selector.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:bitsflea/widgets/number_pad.dart';
import 'package:bitsflea/widgets/type_selector.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'photos_selector.dart';

class PublishRoute extends StatelessWidget {
  final Product product;
  PublishRoute({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("publish build........");
    return BaseRoute<PublishProvider>(
      listen: true,
      provider: PublishProvider(context, product),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            key: provider.scaffoldKey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.isUpdate ? provider.translate('title.edit_goods') : provider.translate('publish.title')),
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
                                  itemCount: provider.photosCount,
                                  itemBuilder: (_, i) {
                                    AssetEntity photo = i < provider.photos.length ? provider.photos[i] : null;
                                    return GestureDetector(
                                      onTap: provider.selectPhotos,
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
                                      text: provider.translate('publish.prices'),
                                      prefixIcon: Icons.monetization_on,
                                      subText: provider.prices,
                                      onTap: provider.showNumberPad),
                                  LineButtonItem(
                                      text: provider.translate('publish.type'),
                                      prefixIcon: Icons.local_mall,
                                      subText: provider.category.view,
                                      onTap: provider.showTypeSelector),
                                  LineButtonItem(
                                      text: provider.translate('publish.address'),
                                      prefixIcon: Icons.location_on,
                                      subText: provider.location,
                                      onTap: provider.showAddressSelector),
                                ],
                              ),
                              CustomButton(
                                width: double.infinity,
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(16),
                                onTap: provider.submit,
                                text: provider.translate(provider.isUpdate ? 'controller.re_publish' : 'publish.publish_text'),
                              ),
                              Offstage(
                                offstage: !provider.isUpdate,
                                child: CustomButton(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(16),
                                  color: Colors.red[500],
                                  onTap: provider.delPublish,
                                  text: provider.translate('controller.del_publish'),
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
  List<AssetEntity> _photos = [];
  int _maxCount = 8;
  bool _isUpdate = false;

  PublishProvider(BuildContext context, Product product) : super(context) {
    _product = product ?? Product();
    _locationData = LocationData(api);
    _location = _locationData.getAddress();
    _init();
  }

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
  get isUpdate => _isUpdate;
  get product => _product;

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
    assert(ps.length != 2);
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
    } else {
      _pricingAmount = 0;
      _freightAmount = 0;
      _symbol = COIN_PRECISION.keys.first;
    }

    _titleController.text = _product.title ?? '';
    _describeController.text = _product.description ?? '';
    _location = _product.position ?? _location;
    _category = _product.category ?? _categories[_categories.length - 1];

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
    );
    String adcode = await this.showDialog(screen);
    if (adcode != null) {
      _location = _locationData.getAddress(adcode);
      notifyListeners();
    }
  }

  selectPhotos() async {
    Widget screen = PhotosSelectPage(
      title: translate('publish.photos_selector'),
      maxCount: _maxCount,
      selectedPhotos: [..._photos],
    );
    List<AssetEntity> photos = await this.showDialog(screen);
    if (photos != null && photos.length != 0) {
      _photos = photos;
      notifyListeners();
    }
  }

  Future<bool> _publishProduct(EOSPrivateKey actKey, String eosid, int userId, Map product, List<AssetEntity> photos) async {
    if (photos != null) {
      var futures = List<Future<BaseReply>>();
      for (int i = 0; i < photos.length; i++) {
        var data = await photos[i].originBytes;
        futures.add(api.uploadFile(data));
      }
      try {
        final resList = await Future.wait(futures);
        print("uploadFiles: $resList");
        if (resList.length > 0) {
          resList.forEach((f) {
            if (f.code == 0) (product['photos'] as List).add(f.msg);
          });
        }
      } catch (e) {
        print(e);
        return false;
      }
    }
    // print("product: $product");
    return await api.publishProduct(actKey, eosid, userId, product);
  }

  submit() async {
    _product.title = _titleController.text;
    _product.description = _describeController.text;
    _product.price = '${this.pricingAmount} ${this._symbol}';
    _product.postage = '${this.freightAmount} ${this._symbol}';
    _product.position = this._location;
    if (_product.title.isEmpty) {
      showToast(translate('message.goods_title_empty'));
    } else if (_product.title.length > this.titleLimit) {
      showToast(translate('message.goods_title_limit'));
    } else if (_product.description.isEmpty) {
      showToast(translate('message.goods_desc_empty'));
    } else if (_product.description.length > this.descLimit) {
      showToast(translate('message.goods_desc_limit'));
    } else if (this._photos.length == 0) {
      showToast(translate('message.goods_photos_empty'));
    } else if (this._pricingAmount == 0) {
      showToast(translate('message.goods_price_empty'));
    } else if (_product.position == null || _product.position.isEmpty) {
      showToast(translate('message.goods_location_empty'));
    }
    if (this._isUpdate) {
      if (await super.confirm(translate('message.goods_re_publish'))) {
        // toast('重新编辑');
        super.pop();
      }
    } else {
      final um = Provider.of<UserModel>(context, listen: false);
      showLoading();
      Map product = {
        "pid": 0,
        "uid": um.user.userid,
        "title": _product.title,
        "description": _product.description,
        "photos": [],
        "category": _category.cid,
        "status": 0,
        "is_new": true,
        "is_returns": false,
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
      closeLoading();
      if (result) {
        pop();
      } else {
        showToast(translate("publish.failure"));
      }
    }
  }

  delPublish() async {
    if (await confirm(translate('message.goods_del_publish'))) {
      pop();
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
