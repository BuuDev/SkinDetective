import 'package:skin_detective/routes/routes.dart';
import 'package:flutter/widgets.dart'
    show BuildContext, GlobalKey, NavigatorState, Route;
import 'package:get_it/get_it.dart';

class NavigationService {
  static GlobalKey<NavigatorState>? _currentState;

  static set currentState(GlobalKey<NavigatorState> state) {
    _currentState = state;
  }

  static NavigatorState get _navState =>
      GetIt.instance.get<GlobalKey<NavigatorState>>().currentState!;

  static BuildContext get context => _navState.context;

  /// Goto auth stack screens
  static Future<T?> gotoAuth<T extends Object?>([String? initRoute]) {
    return _navState.pushNamedAndRemoveUntil(AppRoutes.auth, (route) => false,
        arguments: {'initRoute': initRoute});
  }

  /// Goto intro stack screens
  static Future<T?> introApp<T extends Object?>() {
    return _navState.pushNamedAndRemoveUntil(
      AppRoutes.intro,
      (route) => false,
    );
  }

  ///Goto app stack screens
  static Future<T?> gotoAppStack<T extends Object?>() {
    return _navState.pushNamedAndRemoveUntil(
      AppRoutes.appStack,
      (route) => false,
    );
  }

  static void popUntil(bool Function(Route<dynamic>) predicate,
      {bool isRootNavigation = false}) {
    if (isRootNavigation) {
      _navState.popUntil(predicate);
      return;
    }
    _currentState!.currentState!.popUntil(predicate);
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String page) {
    return _navState.pushNamedAndRemoveUntil(
      page,
      (route) => false,
    );
  }

  static Future<T?> gotoAnotherStack<T extends Object?>(
      {required String stackPage, String? initRoute}) {
    return _navState.pushNamedAndRemoveUntil(stackPage, (route) => false,
        arguments: {'initRoute': initRoute});
  }

  ///Open widgets of app are custemized
  static Future<T?> gotoWidgesCustom<T extends Object?>() {
    return _navState.pushNamed(AppRoutes.widgetsCustom);
  }
}
