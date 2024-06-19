import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:skin_detective/routes/routes.dart';
import 'package:skin_detective/services/navigation.dart';

typedef FunctionBuilder = Widget Function(BuildContext);

class NestedNavigation extends ModalRoute<dynamic> {
  final String initRoute;
  final Route<dynamic>? Function(RouteSettings settings) onGenerateRoute;
  final bool barrierDismiss;
  final Duration? duration;
  final List<SingleChildWidget> providers;

  final GlobalKey<NavigatorState> _navState = GlobalKey();

  NestedNavigation({
    required this.initRoute,
    required this.onGenerateRoute,
    this.barrierDismiss = false,
    this.duration,
    this.providers = const [],
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => barrierDismiss;

  @override
  String? get barrierLabel => '$initRoute Stack';

  @override
  Future<RoutePopDisposition> willPop() async {
    if (_navState.currentState!.canPop()) {
      _navState.currentState!.pop();
    }
    return Future.value(RoutePopDisposition.doNotPop);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    var child = Navigator(
      key: _navState,
      initialRoute: initRoute,
      onGenerateRoute: onGenerateRoute,
    );

    NavigationService.currentState = _navState;

    if (providers.isEmpty) {
      return child;
    }

    return MultiProvider(
      providers: providers,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration =>
      duration ?? const Duration(milliseconds: 300);
}

Route<dynamic>? _getRoute(dynamic pageRoute, RouteSettings settings) {
  if (pageRoute is Route) {
    return pageRoute;
  }

  if (pageRoute is FunctionBuilder) {
    return MaterialPageRoute(
      builder: pageRoute,
      settings: settings,
    );
  }

  if (pageRoute is Map) {
    Map routes = pageRoute;
    List<SingleChildWidget>? providers = routes[AppRoutes.providers];

    ///Xóa provider keys object
    routes.remove(AppRoutes.providers);

    String? initRoute =
        (settings.arguments as Map<String, dynamic>?)?['initRoute'];

    return NestedNavigation(
      providers: providers ?? [],
      initRoute: initRoute ?? '${routes.keys.first}',
      onGenerateRoute: (_settings) {
        return generateRoute(_settings, routes as Map<String, dynamic>);
      },
    );
  }
  return null;
}

Route<dynamic>? generateRoute(
  RouteSettings settings,
  Map<String, dynamic> routes,
) {
  var pageRoute = routes[settings.name];

  return _getRoute(pageRoute, settings);
}
