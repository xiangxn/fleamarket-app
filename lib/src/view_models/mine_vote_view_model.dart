import 'dart:math';

import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

List<String> testHeadImg = [
  'https://pic.feizl.com/upload/allimg/190731/gxtxwuahnllnk3m.jpg',
  'https://images.liqucn.com/img/h1/h994/img201802021024070_info300X300.jpg',
  'http://img.gos68.com/uploads/20190621/16/1561104522-WiFxsBeSJD.jpeg',
];

class MineVoteViewModel extends BaseViewModel{
  MineVoteViewModel(BuildContext context) : super(context){
    fetchReviewers();
  }

  List<Map<String, dynamic>> _list;
  List<Map<String, dynamic>> get list => _list;

  fetchReviewers() async {
    super.setBusy();
    await Future.delayed(Duration(milliseconds: 600));
    _list = List<Map<String, dynamic>>.generate(20, (i) {
      return {
        'head': testHeadImg[Random.secure().nextInt(testHeadImg.length)],
        'name': '一个用户昵称',
        'score': Random.secure().nextInt(1000) + 500,
        'vote': Random.secure().nextInt(100),
        'hasSupport': false,
        'hasAgainst': false
      };
    });
    super.setBusy();
    notifyListeners();
  }

  support(int i){
    dynamic obj = _list[i];
    _list[i] = {
      'head': obj['head'],
      'name': obj['name'],
      'score': obj['score'],
      'vote': obj['vote'] + 1,
      'hasSupport': true,
      'hasAgainst': obj['hasAgainst']
    };
    notifyListeners();
  }

  against(int i){
    dynamic obj = _list[i];
    _list[i] = {
      'head': obj['head'],
      'name': obj['name'],
      'score': obj['score'],
      'vote': obj['vote'] - 1,
      'hasSupport': obj['hasSupport'],
      'hasAgainst': true
    };
    notifyListeners();
  }

}