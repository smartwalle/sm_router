import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/router_context.dart';
import 'package:sm_router/src/route_name.dart';
import 'package:sm_router/src/route.dart';
import 'package:sm_router/src/route_registry.dart';

typedef KIRoutePredicate = bool Function(KIRouterContext ctx);

/// KIRouterDelegate
class KIRouterDelegate extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  KIRouterDelegate();

  final _registry = KIRouteRegistry();

  KIRouteRegistry get registry => _registry;

  final List<KIRouterState> _stack = [];

  bool _disposed = false;

  // 浏览器标签默认 title
  String? defaultTitle;

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
    var state = _buildState(configuration, null);
    if (state != null) {
      _stack.clear();
      _stack.add(state);
      _update();
    }
    return SynchronousFuture(null);
  }

  // 备用方案
  // @override
  // Future<void> setNewRoutePath(String configuration) {
  //   if (_stack.length >= 2) {
  //     var prev = _stack[_stack.length - 2];
  //     if (prev.requestName == configuration) {
  //       _stack.removeLast();
  //       _update();
  //       return SynchronousFuture(null);
  //     }
  //   }
  //
  //   var state = _buildState(configuration, null);
  //   _stack.add(state);
  //   _update();
  //   return SynchronousFuture(null);
  // }

  @override
  Widget build(BuildContext context) {
    assert(!_disposed);
    assert(_stack.isNotEmpty, "Router stack must not be empty");

    List<Page<dynamic>> pages = [for (var route in _stack) route.page];

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
      observers: _registry.observers,
    );

    var state = _stack.last;

    title = state.title ?? defaultTitle;

    return state.navigatorWrapper(state, navigator);
  }

  set title(String? title) {
    if (kIsWeb) {
      SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
        label: title,
      ));
    }
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
      var state = _stack.removeLast();
      state.result.complete(result);
    }
  }

  void _update() {
    assert(!_disposed);
    notifyListeners();
  }

  KIRouterState? _buildState(String routeName, Object? arguments) {
    var uri = Uri.parse(routeName);

    var route = _registry.route(uri.path);
    return __buildState(
      route.title,
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

  KIRouterState? __buildState(
    String? title,
    Uri uri,
    Object? arguments,
    KIRouterError? error,
    List<KIRouterInterceptor> interceptors,
    KIRouterWidgetBuilder builder,
    KIPageKeyBuilder keyBuilder,
    KIRouterPageBuilder pageBuilder,
    KINavigatorWrapper navigatorWrapper,
  ) {
    var state = KIRouterState(uri, title, arguments, error);

    try {
      state.key = keyBuilder(state);
      state.navigatorWrapper = navigatorWrapper;

      for (var interceptor in interceptors) {
        var redirect = interceptor(state);
        if (redirect != null) {
          if (redirect is KIDiscard) {
            return null;
          }
          return _buildState(redirect.name!, redirect.arguments);
        }
      }

      state.page = pageBuilder(state, builder(state));
    } catch (error, stack) {
      return __buildState(
        title,
        uri,
        arguments,
        KIRouterError(error, stack),
        _registry.interceptors,
        _registry.errorRoute.builder,
        _registry.errorRoute.keyBuilder ?? _registry.keyBuilder,
        _registry.errorRoute.pageBuilder ?? _registry.pageBuilder,
        _registry.errorRoute.navigatorWrapper ?? _registry.navigatorWrapper,
      );
    }

    return state;
  }

  Future<T?> push<T extends Object?>(String routeName, Object? arguments) async {
    var state = _buildState(routeName, arguments);
    if (state != null) {
      _stack.add(state);
      _update();
      return await state.result.future;
    }
  }

  void _pushRoutes(List<KIRouteName> routeNames) {
    List<KIRouterState> states = <KIRouterState>[];

    for (var name in routeNames) {
      var state = _buildState(name.encode(), name.arguments);
      if (state != null) {
        states.add(state);
      }
    }

    if (states.isNotEmpty) {
      _stack.addAll(states);
      _update();
    }
  }

  void pushRoutes(List<KIRouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutes: routeNames must not be empty");
    return _pushRoutes(routeNames);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName, TO? result, Object? arguments) {
    _pop(result);
    return push(routeName, arguments);
  }

  void pushRoutesReplacement<T extends Object?>(List<KIRouteName> routeNames, T? result) {
    assert(routeNames.isNotEmpty, "pushRoutesReplacement: routeNames must not be empty");
    _pop(result);
    return _pushRoutes(routeNames);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, KIRoutePredicate predicate, Object? arguments) {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return push(routeName, arguments);
  }

  void pushRoutesAndRemoveUntil(List<KIRouteName> routeNames, KIRoutePredicate predicate) {
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

  void pushRoutesAndRemoveAll(List<KIRouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveAll: routeNames must not be empty");
    _stack.removeRange(0, _stack.length);
    return _pushRoutes(routeNames);
  }

  void show<T extends Object?>(String routeName, Object? arguments) {
    return pushAndRemoveAll(routeName, arguments);
  }

  void showRoutes(List<KIRouteName> routeNames) {
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

  Future<bool> popMatched<T extends Object?>(KIRoutePredicate predicate, T? result) {
    if (_stack.length <= 1) {
      return SynchronousFuture(false);
    }

    var state = _stack.last;
    if (predicate(state) == false) {
      return SynchronousFuture(false);
    }

    return pop(result);
  }

  void popUntil(KIRoutePredicate predicate) {
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

  void popAndPushRoutes<T extends Object?>(List<KIRouteName> routeNames, T? result) async {
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

  bool contains(KIRoutePredicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    return index != -1;
  }

  KIRouterContext? get top => _stack.last;
}
