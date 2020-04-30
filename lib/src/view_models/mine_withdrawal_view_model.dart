import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class MineWithdrawalViewModel extends BaseViewModel{
  MineWithdrawalViewModel(BuildContext context) : super(context);

  List<List<String>> _list = [
    ['FMT', ''],
    ['BOS', ''],
    ['EOS', ''],
    ['BTS', ''],
    ['ETH', ''],
  ];
  List<List<String>> get list => _list;

  toEdit(List<String> withdrawal) async {
    int inx = _list.indexOf(withdrawal);
    var bindAddr = await super.pushNamed(EDIT_WITHDRAWAL_ROUTE, arguments: withdrawal[1]);
    if(bindAddr != null){
      _list[inx] = [withdrawal[0], bindAddr];
      notifyListeners();
    }
  }
}