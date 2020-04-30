import 'package:fleamarket/src/models/ext_result.dart';

typedef RefreshPageCallback = Future<ExtResult> Function({int pageNo, int pageSize});
typedef UpdateObjectCallback<T> = void Function({T obj});