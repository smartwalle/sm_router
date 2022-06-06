import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/route_registry.dart';

typedef Predicate = bool Function(Context ctx);

typedef NavigatorWrapper = Widget Function(Context ctx, Navigator navigator);

/// RouterDelegate
class Delegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  Delegate({
    required this.navigatorWrapper,
  });

  NavigatorWrapper navigatorWrapper;

  final registry = Registry();

  final _random = Random(DateTime.now().millisecondsSinceEpoch);

  final List<RouteContext> _stack = [];

  bool routerNeglect = false;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration {
    return _stack.isNotEmpty ? _stack.last.requestName : null;
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    var route = _buildRouteContext(configuration);
    _stack.clear();
    _stack.add(route);
    _update();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    assert(!_disposed);
    assert(_stack.isNotEmpty, "Router stack must not be empty");

    List<Page<dynamic>> pages = [];

    if (routerNeglect) {
      Router.neglect(context, () {
        pages = [for (var route in _stack) _buildPage(route)];
      });
    } else {
      pages = [for (var route in _stack) _buildPage(route)];
    }

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );

    return navigatorWrapper(_stack.last, navigator);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (route.didPop(result)) {
      _pop(result);
      _update();
      return true;
    }
    return false;
  }

  void _pop(dynamic result) {
    var route = _stack.removeLast();
    route.result.complete(result);
  }

  void _update() {
    assert(!_disposed);
    notifyListeners();
  }

  RouteContext _buildRouteContext(String routeName, {Object? arguments}) {
    var key = ValueKey("$routeName-${_random.nextDouble()}");
    var node = registry.getNode(routeName);
    var route = RouteContext(routeName, key, arguments, node);

    for (var interceptor in [...registry.interceptors, ...node.interceptors]) {
      var redirect = interceptor(route);
      if (redirect != null) {
        return _buildRouteContext(redirect.name!, arguments: redirect.arguments);
      }
    }

    return route;
  }

  Page<dynamic> _buildPage(RouteContext route) {
    var node = route.node;
    var child = node.builder(route);
    var pageBuilder = node.pageBuilder ?? registry.pageBuilder;
    return pageBuilder(route, child);
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) async {
    var route = _buildRouteContext(routeName, arguments: arguments);
    _stack.add(route);
    _update();
    return await route.result.future;
  }

  void _pushRoutes(List<RouteName> routeNames) {
    var routes = [for (var name in routeNames) _buildRouteContext(name.name, arguments: name.arguments)];
    _stack.addAll(routes);
    _update();
  }

  void pushRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutes: routeNames must not be empty");
    return _pushRoutes(routeNames);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    if (_stack.isNotEmpty) {
      _pop(result);
    }
    return push(routeName, arguments: arguments);
  }

  void pushRoutesReplacement<T extends Object?>(List<RouteName> routeNames, {T? result}) {
    assert(routeNames.isNotEmpty, "pushRoutesReplacement: routeNames must not be empty");
    if (_stack.isNotEmpty) {
      _pop(result);
    }
    return _pushRoutes(routeNames);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, Predicate predicate, {Object? arguments}) {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return push(routeName, arguments: arguments);
  }

  void pushRoutesAndRemoveUntil(List<RouteName> routeNames, Predicate predicate) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveUntil: routeNames must not be empty");
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return _pushRoutes(routeNames);
  }

  void pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    _stack.removeRange(0, _stack.length);
    push(routeName, arguments: arguments);
  }

  void pushRoutesAndRemoveAll(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveAll: routeNames must not be empty");
    _stack.removeRange(0, _stack.length);
    return pushRoutes(routeNames);
  }

  void show<T extends Object?>(String routeName, {Object? arguments}) {
    return pushAndRemoveAll(routeName, arguments: arguments);
  }

  void showRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "showRoutes: routeNames must not be empty");
    _stack.removeRange(0, _stack.length);
    return pushRoutes(routeNames);
  }

  bool canPop() {
    return _stack.length > 1;
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    if (_stack.length <= 1) {
      return SynchronousFuture(false);
    }
    return pop(result);
  }

  // Future<bool> pop<T extends Object?>([T? result]) async {
  //   final NavigatorState? state = navigatorKey.currentState;
  //   if (state == null) {
  //     return SynchronousFuture<bool>(false);
  //   }
  //   return state.maybePop(result);
  // }

  Future<bool> pop<T extends Object?>([T? result]) {
    _pop(result);
    _update();
    return SynchronousFuture(true);
  }

  Future<bool> popMatched<T extends Object?>(Predicate predicate, [T? result]) {
    if (_stack.isEmpty) {
      return SynchronousFuture(false);
    }

    var route = _stack.last;
    if (predicate(route) == false) {
      return SynchronousFuture(false);
    }

    return pop(result);
  }

  void popUntil(Predicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    if (index == -1) {
      return;
    }

    _stack.removeRange(index + 1, _stack.length);
    _update();
  }

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) async {
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return push(routeName, arguments: arguments);
  }

  void popAndPushRoutes<T extends Object?>(List<RouteName> routeNames, [T? result]) async {
    assert(routeNames.isNotEmpty, "popAndPushRoutes: routeNames must not be empty");
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return pushRoutes(routeNames);
  }

  Future<bool> popToRoot() {
    if (_stack.isEmpty) {
      return SynchronousFuture(false);
    }
    _stack.removeRange(1, _stack.length);
    _update();
    return SynchronousFuture(true);
  }
}
