import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';

typedef GetDataCallback = Future<DataPage<Product>> Function({DataPage<Product> page, int categoryid});
typedef UpdateObjectCallback<T> = Future<void> Function({T obj});
typedef RefreshPageCallback<T> = Future<T> Function({int pageNo, int pageSize, String key, String key2});
