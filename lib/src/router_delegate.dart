import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/context.dart';

typedef Predicate = bool Function(Context ctx);

typedef NavigatorWrapper = Widget Function(BuildContext context, Context route, Navigator navigator);

/// RouterDelegate
class Delegate extends RouterDelegate<PageContext> with PopNavigatorRouterDelegateMixin<PageContext>, ChangeNotifier {
  Delegate({
    required this.navigatorWrapper,
  });

  NavigatorWrapper navigatorWrapper;

  final List<PageContext> _stack = [];

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
  PageContext? get currentConfiguration {
    return _stack.isNotEmpty ? _stack.last : null;
  }

  @override
  Future<void> setNewRoutePath(PageContext configuration) {
    _stack.clear();
    _stack.add(configuration);
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
        pages = [for (var route in _stack) route.page];
      });
    } else {
      pages = [for (var route in _stack) route.page];
    }

    var navigator = Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );

    return navigatorWrapper(context, _stack.last, navigator);
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
    var ctx = _stack.removeLast();
    ctx.result.complete(result);
  }

  void _update() {
    assert(!_disposed);
    notifyListeners();
  }

  Future<T?> push<T extends Object?>(PageContext route) async {
    _stack.add(route);
    _update();
    return await route.result.future;
  }

  void pushRoutes(List<PageContext> routes) {
    _stack.addAll(routes);
    _update();
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(PageContext route, [TO? result]) {
    if (_stack.isNotEmpty) {
      _pop(result);
    }
    return push(route);
  }

  void pushRoutesReplacement<T extends Object?>(List<PageContext> routes, [T? result]) {
    if (_stack.isNotEmpty) {
      _pop(result);
    }
    return pushRoutes(routes);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(PageContext route, Predicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return push(route);
  }

  void pushRoutesAndRemoveUntil(List<PageContext> routes, Predicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    return pushRoutes(routes);
  }

  void pushAndRemoveAll<T extends Object?>(PageContext route) {
    _stack.removeRange(0, _stack.length);
    push(route);
  }

  void pushRoutesAndRemoveAll(List<PageContext> routes) {
    _stack.removeRange(0, _stack.length);
    return pushRoutes(routes);
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

    var ctx = _stack.last;
    if (predicate(ctx) == false) {
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

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(PageContext route, [TO? result]) async {
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return push(route);
  }

  void popAndPushRoutes<T extends Object?>(List<PageContext> routes, [T? result]) async {
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return pushRoutes(routes);
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
