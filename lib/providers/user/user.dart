import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skin_detective/models/user/user.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/services/local_storage.dart';

class UserViewModel with ChangeNotifier {
  User data = User.userEmpty;

  UserViewModel() {
    _initData();
  }

  void _initData() async {
    data = LocalStorage().userInfo ?? User.userEmpty;
    notifyListeners();
  }

  void updateInfo(User info) {
    data = info;
    notifyListeners();

    LocalStorage().setInfoUser(data);
  }

  ///Request api to get info
  Future<void> requestInfo() async {
    try {
      var info =
          await UserService.client(isLoading: false)
              .getInfo();
      data = info;
      // await NavigationService.gotoAppStack();
      notifyListeners();
      return Future.value();
    } on DioError catch (e) {
      debugPrint('$e');
      return Future.error(e);
    }
  }

  void reset() {
    data = User.userEmpty;
    notifyListeners();
  }
}
