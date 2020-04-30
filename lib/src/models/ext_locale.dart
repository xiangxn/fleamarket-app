import 'package:fleamarket/src/common/utils.dart';
import 'package:flutter/material.dart';

class ExtLocale extends ChangeNotifier{

  List<String> _supportLocales = ['zh'];

  String _locale;

  var _localeJSON;

  setLocale([String locale = 'zh']) async {
    if(_supportLocales.contains(locale) && _locale != locale){
      _locale = locale;
      var res = await Utils.getJson('assets/locales/$_locale.json');
      _localeJSON = res;
      notifyListeners();
      return ;
    }
    return ;
  }

  String translation(String find, [List<String> repalce]){
    if(_localeJSON == null){
      return '';
    }else{
      List<String> keys = find.split('.');
      var result = _localeJSON;
      for(String key in keys){
        result = result[key];
        if(result is String){
          result = keys.last == key ? result : '';
          break;
        }else if(keys.last == key){
          result = result is String ? result : '';
          break;
        }
      }
      if(repalce != null && result is String){
        for(String rep in repalce){
          result = result.replaceFirst(RegExp(r'@s'), rep);
        }
      }
      return result;
    }
  }

}