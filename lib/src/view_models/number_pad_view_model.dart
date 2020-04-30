import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberPadViewModel extends BaseViewModel{

  GoodsService _goodsService ;
  String _symbol ;
  FocusNode _pricingFocus = FocusNode();
  FocusNode _freightFocus = FocusNode();
  TextEditingController _pricingController = TextEditingController();
  TextEditingController _freightController = TextEditingController();
  List<dynamic> _inputs = [];
  List<dynamic> _chars ;
  List<dynamic> _btns ;

  String get symbol => _symbol;
  List<dynamic> get symbols => _goodsService.symbols;
  List<dynamic> get inputs => _inputs;
  List<dynamic> get chars => _chars;
  List<dynamic> get btns => _btns;

  NumberPadViewModel(BuildContext context, double pricingAmount, double freightAmount, String symbol) : super(context){
    _goodsService = Provider.of<GoodsService>(context, listen: false);
    _symbol = symbol ?? _goodsService.symbols.first['key'];
    _inputs = [
      {
        'text': super.locale.translation('number_pad.pricing'),
        'hint': super.locale.translation('number_pad.pricing_hint'),
        'controller': _pricingController,
        'focus': _pricingFocus
      },
      {
        'text': super.locale.translation('number_pad.freight'),
        'hint': super.locale.translation('number_pad.freight_hint'),
        'controller': _freightController,
        'focus': _freightFocus
      },
    ];
    if(pricingAmount > 0){
      _pricingController.text = pricingAmount.toString();
    }
    if(freightAmount > 0){
      _freightController.text = freightAmount.toString();
    }
    _chars = [[1,2,3],[4,5,6],[7,8,9],['.',0,Icons.keyboard_hide]];
    _btns = [Icons.backspace, super.locale.translation('number_pad.done')];
  }

  void handleNumberPad(String pad){
    TextEditingController controller ;
    if(_pricingFocus.hasFocus){
      controller = _pricingController;
    }else if(_freightFocus.hasFocus){
      controller = _freightController;
    }
    if(controller == null){
      return ;
    }

    String text = controller.text;
    RegExp reg = RegExp(r'^(?!00)\d{1,12}([.]\d{0,4})?$');
    Map<String, dynamic> done;

    switch (pad) {
      case 'DONE':
        done = {
          "pricingAmount": double.tryParse(_pricingController.text),
          "freightAmount": double.tryParse(_freightController.text),
          "symbol": _symbol
        };
        continue hide;
      hide:
      case 'HIDE':
        Navigator.of(context).pop(done);
        break;
      case 'BACK':
        if(text.isNotEmpty){
          text = text.substring(0, text.length - 1);
          _setInputText(controller, text);
        }
        break;
      default:
        text += pad;
        if(reg.hasMatch(text)){
          _setInputText(controller, text);
        }
    }
  }

  void _setInputText(TextEditingController controller, String text){
    controller.text = text;
    controller.selection = TextSelection.collapsed(offset: text.length);
  }

  void setSymbol(String symbol){
    _symbol = symbol;
  }

  @override
  void dispose() {
    super.dispose();
    _pricingController?.dispose();
    _freightController?.dispose();
    _pricingFocus?.dispose();
    _freightFocus?.dispose();
  }

  

}