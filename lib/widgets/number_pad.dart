import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:flutter/material.dart';

import 'ext_flat_button.dart';

class NumberPad extends StatelessWidget {
  final double pricingAmount;
  final double freightAmount;
  final String symbol;
  final List<String> symbolList;

  NumberPad({Key key, this.pricingAmount, this.freightAmount, this.symbol, this.symbolList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseRoute<NumberPadProvider>(
      provider: NumberPadProvider(context, this.pricingAmount, this.freightAmount, this.symbol, this.symbolList),
      builder: (_, provider, __) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          /// inputs
          ...provider.inputs.map((input) {
            bool isFirst = input == provider.inputs.first;
            return TextField(
              autofocus: isFirst,
              controller: input['controller'],
              focusNode: input['focus'],
              disableKeyboard: true,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                  hintText: input['hint'],
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  prefixIcon: Container(
                    width: 60,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(input['text']),
                  ),
                  suffixIcon: DropdownButton(
                      value: provider.symbol, //isFirst ? _pricingSymbol : _freightSymbol,
                      iconDisabledColor: Colors.transparent,
                      underline: Wrap(),
                      disabledHint: Text(
                        provider.symbol,
                        style: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      items: provider.symbols.map((symbol) {
                        return DropdownMenuItem(value: symbol, child: Text(symbol));
                      }).toList(),
                      onChanged: !isFirst
                          ? null
                          : (s) {
                              FocusScope.of(context).requestFocus(input['focus']);
                              provider.setSymbol(s);
                            }),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]))),
            );
          }).toList(),

          /// number pad
          DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Table(
                      children: provider.chars.map<TableRow>((chars) {
                        return TableRow(
                            decoration: BoxDecoration(border: provider.chars.first == chars ? null : Border(top: BorderSide(color: Colors.grey[300]))),
                            children: chars.map<ExtFlatButton>((c) {
                              return ExtFlatButton(
                                content: c,
                                height: 60,
                                shape: Border(right: BorderSide(color: Colors.grey[300])),
                                childSize: c is! IconData ? 18 : 28,
                                childColor: Colors.grey[700],
                                onTap: () => provider.handleNumberPad(c is IconData ? 'HIDE' : c.toString()),
                              );
                            }).toList());
                      }).toList(),
                    ),
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: provider.btns.map((c) {
                        bool isStr = c is! IconData;
                        return ExtFlatButton(
                          content: c,
                          width: 80,
                          height: 120,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          color: isStr ? Colors.green : null,
                          childColor: isStr ? Colors.white : Colors.grey[700],
                          childSize: isStr ? 16 : 28,
                          onTap: () => provider.handleNumberPad(isStr ? 'DONE' : 'BACK'),
                        );
                      }).toList())
                ],
              ))
        ]);
      },
    );
  }
}

class NumberPadProvider extends BaseProvider {
  String _symbol;
  List<String> _symbolList;
  FocusNode _pricingFocus = FocusNode();
  FocusNode _freightFocus = FocusNode();
  TextEditingController _pricingController = TextEditingController();
  TextEditingController _freightController = TextEditingController();
  List<dynamic> _inputs = [];
  List<dynamic> _chars;
  List<dynamic> _btns;

  String get symbol => _symbol;
  List<dynamic> get symbols => _symbolList;
  List<dynamic> get inputs => _inputs;
  List<dynamic> get chars => _chars;
  List<dynamic> get btns => _btns;
  NumberPadProvider(BuildContext context, double pricingAmount, double freightAmount, String symbol, List<String> symbolList) : super(context) {
    _symbolList = symbolList ?? COIN_PRECISION.keys.toList();
    _symbol = symbol ?? _symbolList[0];
    _inputs = [
      {'text': translate('number_pad.pricing'), 'hint': translate('number_pad.pricing_hint'), 'controller': _pricingController, 'focus': _pricingFocus},
      {'text': translate('number_pad.freight'), 'hint': translate('number_pad.freight_hint'), 'controller': _freightController, 'focus': _freightFocus},
    ];
    if (pricingAmount > 0) {
      _pricingController.text = pricingAmount.toString();
    }
    if (freightAmount > 0) {
      _freightController.text = freightAmount.toString();
    }
    _chars = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      ['.', 0, Icons.keyboard_hide]
    ];
    _btns = [Icons.backspace, translate('number_pad.done')];
  }

  void handleNumberPad(String pad) {
    TextEditingController controller;
    if (_pricingFocus.hasFocus) {
      controller = _pricingController;
    } else if (_freightFocus.hasFocus) {
      controller = _freightController;
    }
    if (controller == null) {
      return;
    }

    String text = controller.text;
    RegExp reg = RegExp(r'^(?!00)\d{1,12}([.]\d{0,4})?$');
    Map<String, dynamic> done;

    switch (pad) {
      case 'DONE':
        done = {"pricingAmount": double.tryParse(_pricingController.text), "freightAmount": double.tryParse(_freightController.text), "symbol": _symbol};
        continue hide;
      hide:
      case 'HIDE':
        Navigator.of(context).pop(done);
        break;
      case 'BACK':
        if (text.isNotEmpty) {
          text = text.substring(0, text.length - 1);
          _setInputText(controller, text);
        }
        break;
      default:
        text += pad;
        if (reg.hasMatch(text)) {
          _setInputText(controller, text);
        }
    }
  }

  void _setInputText(TextEditingController controller, String text) {
    controller.text = text;
    controller.selection = TextSelection.collapsed(offset: text.length);
  }

  void setSymbol(String symbol) {
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
