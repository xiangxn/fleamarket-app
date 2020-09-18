import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
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

  UserModel() {
    if (user != null) {
      // print("read store.... $user");
      _readFollows();
      _readFavorites();
    }
  }

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    if (profile.user != null) profile.lastLogin = profile.user.userid;
    profile.user = user;
    notifyListeners();
  }

  set keys(List<EOSPrivateKey> keys) {
    profile.keys = keys;
  }

  void setToken(String token, String time) {
    profile.setToken(token, time);
    notifyListeners();
  }

  @override
  void logout() {
    // Global.profile = new Profile();
    // removeProfile();
    super.logout();
    _favorites.clear();
    _follows.clear();
    notifyListeners();
  }

  void _saveFavorites() {
    Global.prefs.setStringList(STORE_FAVORITES, _favorites.map((e) => e.toString()).toList());
  }

  void _readFavorites() {
    final list = Global.prefs.getStringList(STORE_FAVORITES);
    _favorites = new List<int>();
    if (list != null)
      list.forEach((e) {
        _favorites.add(int.tryParse(e));
      });
  }

  void setFavorites(List<int> value) {
    _favorites = value;
    // print("favorites: $_favorites");
    _saveFavorites();
  }

  bool hasFavorites(int productId) {
    // print("favorites: $_favorites");
    if (_favorites != null) return _favorites.contains(productId);
    return false;
  }

  void addFavorite(int productId) {
    if (_favorites.contains(productId)) return;
    _favorites.add(productId);
    user.favoriteTotal += 1;
    _saveFavorites();
    notifyListeners();
  }

  void removeFavorite(int productId) {
    if (_favorites.contains(productId) == false) return;
    _favorites.remove(productId);
    user.favoriteTotal -= 1;
    _saveFavorites();
    notifyListeners();
  }

  bool hasFollow(int userid) {
    if (_follows != null) return _follows.contains(userid);
    return false;
  }

  void addFollow(int userId) {
    if (_follows.contains(userId)) return;
    _follows.add(userId);
    user.followTotal += 1;
    _saveFollows();
    notifyListeners();
  }

  void removeFollow(int userId) {
    if (_follows.contains(userId) == false) return;
    _follows.remove(userId);
    user.followTotal -= 1;
    _saveFollows();
    notifyListeners();
  }

  void _saveFollows() {
    Global.prefs.setStringList(STORE_FOLLOWS, _follows.map((e) => e.toString()).toList());
  }

  void _readFollows() {
    final list = Global.prefs.getStringList(STORE_FOLLOWS);
    _follows = new List<int>();
    if (list != null)
      list.forEach((e) {
        _follows.add(int.tryParse(e));
      });
  }

  void setFollows(List<int> value) {
    _follows = value;
    _saveFollows();
  }
}
