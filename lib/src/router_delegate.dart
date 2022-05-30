import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/context.dart';

/// RouterDelegate
class Delegate extends RouterDelegate<PageContext> with PopNavigatorRouterDelegateMixin<PageContext>, ChangeNotifier {
  Delegate();

  final List<PageContext> _stack = [];

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
    if (_stack.isNotEmpty) {
      final page = _stack.last;
      if (configuration.requestName == page.requestName) {
        return SynchronousFuture(null);
      }
    }

    _stack.clear();
    _stack.add(configuration);
    _update();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    assert(!_disposed);
    return Navigator(
      key: navigatorKey,
      pages: [for (var ctx in _stack) ctx.page],
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (route.didPop(result)) {
      var ctx = _stack.removeLast();
      ctx.result.complete(result);
      _update();
      return true;
    }
    return false;
  }

  void _update() {
    assert(!_disposed);
    notifyListeners();
  }

  Future<T?> push<T extends Object?>(PageContext ctx) async {
    _stack.add(ctx);
    _update();
    return await ctx.result.future;
  }

  Future<T?> replace<T extends Object?, TO extends Object?>(
    PageContext ctx, {
    TO? result,
    Object? arguments,
  }) {
    if (_stack.isNotEmpty) {
      var ctx = _stack.removeLast();
      ctx.result.complete(result);
    }
    return push(ctx);
  }

  bool canPop() {
    return _stack.isNotEmpty;
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
    var ctx = _stack.removeLast();
    ctx.result.complete(result);
    _update();
    return SynchronousFuture(true);
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

// TODO replace all
// TODO pop until
