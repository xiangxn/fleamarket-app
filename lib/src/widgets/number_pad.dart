import 'package:fleamarket/src/view_models/number_pad_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:flutter/material.dart';

import 'ext_flat_button.dart';

class NumberPad extends StatelessWidget{
  final double pricingAmount;
  final double freightAmount;
  final String symbol;

  NumberPad({Key key, this.pricingAmount, this.freightAmount, this.symbol}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<NumberPadViewModel>(
      model: NumberPadViewModel(context, this.pricingAmount, this.freightAmount, this.symbol),
      builder: (_, model, __){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// inputs
            ...model.inputs.map((input){
              bool isFirst = input == model.inputs.first;
                return TextField(
                  autofocus: isFirst,
                  controller: input['controller'],
                  focusNode: input['focus'],
                  //disableKeyboard: true,
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
                      value: model.symbol,//isFirst ? _pricingSymbol : _freightSymbol,
                      iconDisabledColor: Colors.transparent,
                      underline: Wrap(),
                      disabledHint: Text(model.symbol, style: TextStyle(color: Colors.black),),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                      ),
                      items: model.symbols.map((symbol){
                        return DropdownMenuItem(
                          value: symbol['key'],
                          child: Text(symbol['key'])
                        );
                      }).toList(), 
                      onChanged: !isFirst ? null : (s){
                        FocusScope.of(context).requestFocus(input['focus']);
                        model.setSymbol(s);
                      }
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300])
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300])
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300])
                    )
                  ),
                );
            }).toList(),
            /// number pad
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Table(
                      children: model.chars.map<TableRow>((chars){
                        return TableRow(
                          decoration: BoxDecoration(
                            border: model.chars.first == chars ? null : Border(top: BorderSide(color: Colors.grey[300]))
                          ),
                          children: chars.map<ExtFlatButton>((c){
                            return ExtFlatButton(
                              content: c,
                              height: 60,
                              shape: Border(right: BorderSide(color: Colors.grey[300])),
                              childSize: c is! IconData ? 18 : 28,
                              childColor: Colors.grey[700],
                              onTap: () => model.handleNumberPad(c is IconData ? 'HIDE' : c.toString()),
                            );
                          }).toList()
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: model.btns.map((c){
                      bool isStr = c is! IconData;
                      return ExtFlatButton(
                        content: c,
                        width: 80,
                        height: 120,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        color: isStr ? Colors.green : null,
                        childColor: isStr ? Colors.white : Colors.grey[700],
                        childSize: isStr ? 16 : 28,
                        onTap: () => model.handleNumberPad(isStr ? 'DONE' : 'BACK'),
                      );
                    }).toList()
                  )
                ],
              )
            )
          ]
        );
      },
    );
  }

}