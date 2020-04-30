import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class MineBalancesViewModel extends BaseViewModel{
  MineBalancesViewModel(BuildContext context) : super(context);

  List<String> _assets = [
    '998948934.8934 FMT',
    '10000.0000 BOS',
    '500000.3242 EOS',
    '130.0001 BTC',
    '50040.0000 BTS',
    '3948588.0203 NULS',
    '7843824324.4351 BNB',
    '2787493.0000 ETC'
  ];
  List<String> get assets => _assets;

}