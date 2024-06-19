import 'dart:async';

// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detective/models/system_param/system_param.dart';
import 'package:skin_detective/models/user_info/user_info.dart';
import 'package:skin_detective/providers/user/user.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/apis/home/home.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/services/local_storage.dart';
import 'package:skin_detective/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'
    show BuildContextEasyLocalizationExtension;

enum AuthState { nonLogged, logged }

class AppVM with ChangeNotifier {
  AuthState authState = AuthState.nonLogged;

  SystemParam dataParams = SystemParam(
    id: 1,
    monthRequired: 1,
    activePost: ActivePost.on,
    totalPost: 1,
  );

  bool get isLogged => authState == AuthState.logged;

  void loginSuccess(UserInfo info) async {
    if (info.accessToken != null) {
      GetIt.instance<UserViewModel>().updateInfo(info.user);
      // Save token
      LocalStorage().setExpireIn(info.expiresIn!);
      await LocalStorage().setToken(info.accessToken!);

      authState = AuthState.logged;
      notifyListeners();

      if (!LocalStorage().getUserFirstLogged(info.user.id) &&
          info.user.avatar == null) {
        LocalStorage().setUserFirstLogged(info.user.id);
        NavigationService.gotoAnotherStack(stackPage: AppRoutes.updateInfo);
        return;
      }
      NavigationService.gotoAppStack();
    }
  }

  void refreshSuccess(UserInfo info) async {
    if (info.accessToken != null) {
      GetIt.instance<UserViewModel>().updateInfo(info.user);
      // Save token
      LocalStorage().setExpireIn(info.expiresIn!);

      await LocalStorage().setToken(info.accessToken!);

      authState = AuthState.logged;
      notifyListeners();
    } else {
      GetIt.instance<AppVM>().logout();
    }
  }

  void logoutSetting() {
    if (GetIt.instance<AppVM>().isLogged) {
      NavigationService.gotoAppStack();
      logout();
    } else {
      NavigationService.gotoAuth();
    }
  }

  void logout() {
    authState = AuthState.nonLogged;
    LocalStorage().setToken('');
    LocalStorage().setExpireIn(null);
    GetIt.instance<UserViewModel>().reset();

    notifyListeners();
  }

  /// Middleware to authen when into app
  Future<dynamic> authPending() async {
    await LocalStorage.init();

    if (LocalStorage().token.isEmpty) {
      return NavigationService.gotoAuth();
    }

    return NavigationService.gotoAppStack();
  }

  void middleWareHandle() async {
    await LocalStorage.init();
    LocalStorage storage = LocalStorage();

    if (!storage.firstLogin) {
      // nếu cài app đầu tiên
      NavigationService.introApp();
      /* Future.delayed(const Duration(milliseconds: 1500), () {
        NavigationService.introApp();
      }); */
    } else if (storage.token.isNotEmpty) {
      try {
        authState = AuthState.logged;

        UserInfo info = await UserService.client(isLoading: false)
            .refreshToken(LocalStorage().token);
        GetIt.instance<AppVM>().refreshSuccess(info);
      } catch (error) {
        authState = AuthState.nonLogged;
        debugPrint('request info: $error');
      }

      notifyListeners();
      NavigationService.gotoAppStack();
    } else {
      NavigationService.gotoAuth();
    }

    FlutterNativeSplash.remove();
  }

  void activePosts() async {
    try {
      dataParams = await HomeService.client(isLoading: false).activePost();

      notifyListeners();
    } catch (err) {
      debugPrint('$err');
    }
  }

  void changeLanguage(Locale locale, BuildContext context) {
    context.setLocale(locale);
  }
}
