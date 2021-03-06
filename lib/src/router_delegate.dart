import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/context.dart';
import 'package:sm_router/src/route_name.dart';
import 'package:sm_router/src/route_node.dart';
import 'package:sm_router/src/route_registry.dart';

typedef Predicate = bool Function(Context ctx);

/// RouterDelegate
class Delegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  Delegate();

  final _registry = Registry();

  Registry get registry => _registry;

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
    var route = _buildContext(configuration, null);
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
        pages = [for (var ctx in _stack) ctx.page];
      });
    } else {
      pages = [for (var route in _stack) route.page];
    }

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );

    var ctx = _stack.last;
    return ctx.navigatorWrapper(ctx, navigator);
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
    if (_stack.isNotEmpty) {
      var route = _stack.removeLast();
      route.result.complete(result);
    }
  }

  void _update() {
    assert(!_disposed);
    notifyListeners();
  }

  RouteContext _buildContext(String routeName, Object? arguments) {
    var uri = Uri.parse(routeName);

    var route = _registry.route(uri.path);
    return __buildContext(
      uri,
      arguments,
      null,
      [..._registry.interceptors, ...route.interceptors],
      route.builder,
      route.keyBuilder ?? _registry.keyBuilder,
      route.pageBuilder ?? _registry.pageBuilder,
      route.navigatorWrapper ?? _registry.navigatorWrapper,
    );
  }

  RouteContext __buildContext(
    Uri uri,
    Object? arguments,
    RouteError? error,
    List<RouterInterceptor> interceptors,
    RouterWidgetBuilder builder,
    KeyBuilder keyBuilder,
    RouterPageBuilder pageBuilder,
    NavigatorWrapper navigatorWrapper,
  ) {
    var ctx = RouteContext(uri, arguments, error);

    try {
      ctx.key = keyBuilder(ctx);
      ctx.navigatorWrapper = navigatorWrapper;

      for (var interceptor in interceptors) {
        var redirect = interceptor(ctx);
        if (redirect != null) {
          return _buildContext(redirect.name!, redirect.arguments);
        }
      }

      ctx.page = pageBuilder(ctx, builder(ctx));
    } catch (error, stack) {
      return __buildContext(
        uri,
        arguments,
        RouteError(error, stack),
        _registry.interceptors,
        _registry.errorRoute.builder,
        _registry.errorRoute.keyBuilder ?? _registry.keyBuilder,
        _registry.errorRoute.pageBuilder ?? _registry.pageBuilder,
        _registry.errorRoute.navigatorWrapper ?? _registry.navigatorWrapper,
      );
    }

    return ctx;
  }

  Future<T?> push<T extends Object?>(String routeName, Object? arguments) async {
    var route = _buildContext(routeName, arguments);
    _stack.add(route);
    _update();
    return await route.result.future;
  }

  void _pushRoutes(List<RouteName> routeNames) {
    var routes = [for (var name in routeNames) _buildContext(name.name, name.arguments)];
    _stack.addAll(routes);
    _update();
  }

  void pushRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutes: routeNames must not be empty");
    return _pushRoutes(routeNames);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName, TO? result, Object? arguments) {
    _pop(result);
    return push(routeName, arguments);
  }

  void pushRoutesReplacement<T extends Object?>(List<RouteName> routeNames, T? result) {
    assert(routeNames.isNotEmpty, "pushRoutesReplacement: routeNames must not be empty");
    _pop(result);
    return _pushRoutes(routeNames);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, Predicate predicate, Object? arguments) {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return push(routeName, arguments);
  }

  void pushRoutesAndRemoveUntil(List<RouteName> routeNames, Predicate predicate) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveUntil: routeNames must not be empty");
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return _pushRoutes(routeNames);
  }

  void pushAndRemoveAll<T extends Object?>(String routeName, Object? arguments) {
    _stack.removeRange(0, _stack.length);
    push(routeName, arguments);
  }

  void pushRoutesAndRemoveAll(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveAll: routeNames must not be empty");
    _stack.removeRange(0, _stack.length);
    return _pushRoutes(routeNames);
  }

  void show<T extends Object?>(String routeName, Object? arguments) {
    return pushAndRemoveAll(routeName, arguments);
  }

  void showRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "showRoutes: routeNames must not be empty");
    _stack.removeRange(0, _stack.length);
    return _pushRoutes(routeNames);
  }

  bool canPop() {
    return _stack.length > 1;
  }

  // Future<bool> pop<T extends Object?>([T? result]) async {
  //   final NavigatorState? state = navigatorKey.currentState;
  //   if (state == null) {
  //     return SynchronousFuture<bool>(false);
  //   }
  //   return state.maybePop(result);
  // }

  Future<bool> pop<T extends Object?>(T? result) {
    if (_stack.length <= 1) {
      return SynchronousFuture(false);
    }
    _pop(result);
    _update();
    return SynchronousFuture(true);
  }

  Future<bool> popMatched<T extends Object?>(Predicate predicate, T? result) {
    if (_stack.length <= 1) {
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

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName, TO? result, Object? arguments) async {
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return push(routeName, arguments);
  }

  void popAndPushRoutes<T extends Object?>(List<RouteName> routeNames, T? result) async {
    assert(routeNames.isNotEmpty, "popAndPushRoutes: routeNames must not be empty");
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return _pushRoutes(routeNames);
  }

  Future<bool> popToRoot() {
    if (_stack.isEmpty) {
      return SynchronousFuture(false);
    }
    _stack.removeRange(1, _stack.length);
    _update();
    return SynchronousFuture(true);
  }

  bool contains(Predicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    return index != -1;
  }

  Context? get top => _stack.last;
}
