import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MineFocusViewModel extends BaseViewModel{
  MineFocusViewModel(BuildContext context) : super(context){
    _accountService = Provider.of(context, listen: false);
  }

  AccountService _accountService;

  Future<ExtResult> fetchFocus({int pageNo, int pageSize}) {
    return _accountService.fetchFocus(super.user.userid, pageNo, pageSize);
  }

}