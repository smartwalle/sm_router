import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/context.dart';

typedef PagePredicate = bool Function(Context ctx);

/// RouterDelegate
class Delegate extends RouterDelegate<PageContext> with PopNavigatorRouterDelegateMixin<PageContext>, ChangeNotifier {
  Delegate();

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

    List<Page<dynamic>> pages = [];

    if (routerNeglect) {
      Router.neglect(context, () {
        pages = [for (var ctx in _stack) ctx.page];
      });
    } else {
      pages = [for (var ctx in _stack) ctx.page];
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );
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

  Future<T?> push<T extends Object?>(PageContext ctx) async {
    _stack.add(ctx);
    _update();
    return await ctx.result.future;
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(PageContext ctx, [TO? result]) {
    if (_stack.isNotEmpty) {
      _pop(result);
    }
    return push(ctx);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(PageContext ctx, PagePredicate predicate) async {
    var index = _stack.lastIndexWhere(predicate);
    if (index != -1) {
      _stack.removeRange(index + 1, _stack.length);
    }
    _stack.add(ctx);
    _update();
    return await ctx.result.future;
  }

  Future<T?> pushAndRemoveAll<T extends Object?>(PageContext ctx) async {
    _stack.removeRange(0, _stack.length);
    _stack.add(ctx);
    _update();
    return await ctx.result.future;
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

  Future<bool> popMatched<T extends Object?>(PagePredicate predicate, [T? result]) {
    if (_stack.isEmpty) {
      return SynchronousFuture(false);
    }

    var ctx = _stack.last;
    if (predicate(ctx) == false) {
      return SynchronousFuture(false);
    }

    return pop(result);
  }

  void popUntil(PagePredicate predicate) {
    var index = _stack.lastIndexWhere(predicate);
    if (index == -1) {
      return;
    }

    _stack.removeRange(index + 1, _stack.length);
    _update();
  }

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(PageContext ctx, [TO? result]) async {
    final NavigatorState? state = navigatorKey.currentState;
    if (state != null) {
      await state.maybePop(result);
    }
    return push(ctx);
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
