import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_detective/models/user/user.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._();

  //key storage
  static const String jwtToken = 'access_token';
  static const String enableIntro = 'enable_intro';
  static const String expiresIn = 'expires_in';
  static const String _userInfo = 'user-info';
  static const String userFirstLogged = 'user-First-Logged';

  SharedPreferences? _pref;

  SharedPreferences get store => _pref!;

  LocalStorage._();

  factory LocalStorage() => _instance;

  static LocalStorage get instance => _instance;

  static Future<void> init() async {
    instance._pref ??= await SharedPreferences.getInstance();
    return Future.value();
  }

  Future<bool>? remove(String key) {
    if (store.containsKey(key)) {
      return store.remove(key);
    }

    return Future.value(false);
  }

  //Get and set
  Future<bool> setToken(String token) {
    return store.setString(LocalStorage.jwtToken, token);
  }

  String get token => store.getString(LocalStorage.jwtToken) ?? '';

  //expires_in
  Future<bool> setExpireIn(int? expire) {
    if (expire == null) {
      return store.remove(LocalStorage.expiresIn);
    }
    return store.setInt(LocalStorage.expiresIn, expire);
  }

  int? get expireIn => store.getInt(LocalStorage.expiresIn);

  //expires_in
  Future<bool> setFirstOpenApp(bool isOpen) {
    return store.setBool(LocalStorage.enableIntro, isOpen);
  }

  bool get firstLogin => store.getBool(LocalStorage.enableIntro) ?? false;

  //TODO: Get | Set user info to local
  Future<bool> setInfoUser(User info) {
    return store.setString(_userInfo, jsonEncode(info.toJson()));
  }

  User? get userInfo {
    String? userInfo = store.getString(_userInfo);
    if (userInfo == null) {
      return null;
    }
    return User.fromJson(jsonDecode(userInfo));
  }

  Future<bool> setUserFirstLogged(int id) {
    return store.setBool('$userFirstLogged-$id', true);
  }

  bool getUserFirstLogged(int id) {
    return store.getBool('$userFirstLogged-$id') ?? false;
  }

  //TODO: Get | Set fcm token
  set fcmToken(String token) {
    store.setString('fcm_token', token);
  }

  String get fcmToken {
    return store.getString('fcmToken') ?? '';
  }
}
