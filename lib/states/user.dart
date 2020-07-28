import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/profile.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'profile.dart';

class UserModel extends ProfileChangeNotifier {
  //只保存id,用于快速检查
  List<int> _favorites;
  List<int> _follows;
  User get user => profile.user;
  List<EOSPrivateKey> get keys => profile.keys;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    if (user?.userid != profile.user?.userid) {
      profile.lastLogin = profile.user?.userid;
      profile.user = user;
      notifyListeners();
    }
  }

  set keys(List<EOSPrivateKey> keys){
    profile.keys = keys;
  }

  void setToken(String token, String time) {
    profile.setToken(token, time);
    notifyListeners();
  }

  void logout() {
    Global.profile = new Profile();
    notifyListeners();
  }

  void _saveFavorites() {
    Global.prefs.setStringList(STORE_FAVORITES, _favorites.map((e) => e.toString()));
  }

  void setFavorites(List<int> value) {
    _favorites = value;
    _saveFavorites();
  }

  bool hasFavorites(int productId) {
    if (_favorites != null) return _favorites.contains(productId);
    return false;
  }

  void addFavorite(int productId) {
    if (_favorites.contains(productId)) return;
    _favorites.add(productId);
    _saveFavorites();
  }

  void removeFavorite(int productId) {
    if (_favorites.contains(productId) == false) return;
    _favorites.remove(productId);
    _saveFavorites();
  }

  bool hasFollow(int userid) {
    if (_follows != null) return _follows.contains(userid);
    return false;
  }
}
