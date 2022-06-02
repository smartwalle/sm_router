import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/context.dart';
import 'package:sm_router/src/route_node.dart';
import 'package:sm_router/src/route_registry.dart';
import 'package:sm_router/src/router_delegate.dart';
import 'package:sm_router/src/route_name.dart';

/// RouteState
class RouteState extends RouteInformationParser<PageContext> {
  RouteState() {
    _delegate = Delegate(
      navigatorWrapper: (context, route, navigator) {
        return navigator;
      },
      // navigatorWrapper: (context, route, navigator) {
      //   return _InheritedRouteState(
      //     routeState: this,
      //     child: navigator,
      //   );
      // },
    );
  }

  // static RouteState of(BuildContext context) {
  //   final _InheritedRouteState? widget = context.dependOnInheritedWidgetOfExactType<_InheritedRouteState>();
  //   assert(widget != null, 'RouteState not found in context');
  //   return widget!.routeState;
  // }

  static final RouteState instance = RouteState();

  late Delegate _delegate;

  RouterDelegate<PageContext> get routerDelegate => _delegate;

  RouteInformationParser<PageContext> get routeInformationParser => this;

  final _registry = Registry();

  final _random = Random(DateTime.now().millisecondsSinceEpoch);

  /// 注册未知路由提示页面.
  void setUnknownBuilder(RouterWidgetBuilder builder) {
    _registry.setUnknownBuilder(builder);
  }

  /// 注册 Page 生成器.
  void setPageBuilder(RouterPageBuilder pageBuilder) {
    _registry.pageBuilder = pageBuilder;
  }

  /// 注册全局拦截器.
  void use(RouterInterceptor interceptor) {
    _registry.use(interceptor);
  }

  /// 注册路由.
  RouteNode handle(String routeName, RouterWidgetBuilder builder, [RouterPageBuilder? pageBuilder]) {
    return _registry.handle(routeName, builder, pageBuilder);
  }

  /// 移除路由.
  void remove(String routeName) {
    _registry.remove(routeName);
  }

  void setRouterNeglect(bool value) {
    _delegate.routerNeglect = value;
  }

  void setNavigatorWrapper(NavigatorWrapper wrapper) {
    _delegate.navigatorWrapper = wrapper;
    // _delegate.navigatorWrapper = (context, route, navigator) {
    //   return _InheritedRouteState(
    //     routeState: this,
    //     child: wrapper(context, route, navigator),
    //   );
    // };
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.push(ctx);
  }

  void pushRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutes: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.pushRoutes(routes);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.pushReplacement(ctx, result);
  }

  void pushRoutesReplacement<T extends Object?>(List<RouteName> routeNames, {T? result}) {
    assert(routeNames.isNotEmpty, "pushRoutesReplacement: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.pushRoutesReplacement(routes, result);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, PagePredicate predicate, {Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.pushAndRemoveUntil(ctx, predicate);
  }

  void pushRoutesAndRemoveUntil(List<RouteName> routeNames, PagePredicate predicate) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveUntil: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.pushRoutesAndRemoveUntil(routes, predicate);
  }

  Future<T?> pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.pushAndRemoveAll(ctx);
  }

  void pushRoutesAndRemoveAll(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "pushRoutesAndRemoveAll: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.pushRoutesAndRemoveAll(routes);
  }

  void show(String routeName, {Object? arguments}) {
    return showRoutes([RouteName(routeName, arguments)]);
  }

  void showRoutes(List<RouteName> routeNames) {
    assert(routeNames.isNotEmpty, "showRoutes: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.pushRoutesAndRemoveAll(routes);
  }

  bool canPop() {
    return _delegate.canPop();
  }

  Future<bool> maybePop<T extends Object?>([T? result]) {
    return _delegate.maybePop(result);
  }

  Future<bool> pop<T extends Object?>([T? result]) {
    return _delegate.pop(result);
  }

  Future<bool> popMatched<T extends Object?>(PagePredicate predicate, [T? result]) {
    return _delegate.popMatched(predicate, result);
  }

  void popUntil(PagePredicate predicate) {
    _delegate.popUntil(predicate);
  }

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.popAndPush(ctx, result);
  }

  void popAndPushRoutes<T extends Object?>(List<RouteName> routeNames, [T? result]) {
    assert(routeNames.isNotEmpty, "popAndPushRoutes: routeNames must not be empty");
    var routes = [for (var name in routeNames) _buildContext(name.name, arguments: name.arguments)];
    return _delegate.popAndPushRoutes(routes, result);
  }

  Future<bool> popToRoot() {
    return _delegate.popToRoot();
  }

  PageContext _buildContext(String routeName, {Object? arguments}) {
    var key = ValueKey("$routeName-${_random.nextDouble()}");

    var ctx = PageContext(routeName, key, arguments);

    var node = _registry.getNode(ctx.routeName);

    Widget? child;

    try {
      for (var interceptor in [..._registry.interceptors, ...node.interceptors]) {
        child = interceptor(ctx);
        if (child != null) {
          // 如果拦截器返回结果为非空，则表示拦截器验证不通过，需要显示拦截器返回的 Widget。
          break;
        }
      }
    } on RouteSettings catch (e) {
      // 通过异常的方式处理路由重定向
      return _buildContext(e.name!, arguments: e.arguments);
    }

    // 拦截器没有返回 Widget，则需要调用路由处理器获取 Widget。
    child ??= node.builder(ctx);

    var pageBuilder = node.pageBuilder ?? _registry.pageBuilder;
    ctx.page = pageBuilder(ctx, child);

    return ctx;
  }

  /// 实现 RouteInformationParser
  @override
  Future<PageContext> parseRouteInformation(RouteInformation routeInformation) {
    String routeName = routeInformation.location ?? "/";
    var ctx = _buildContext(routeName);
    return SynchronousFuture(ctx);
  }

  @override
  RouteInformation restoreRouteInformation(PageContext configuration) {
    return RouteInformation(location: configuration.requestName);
  }
}

// class _InheritedRouteState extends InheritedWidget {
//   const _InheritedRouteState({
//     Key? key,
//     required this.routeState,
//     required super.child,
//   }) : super(key: key);
//
//   final RouteState routeState;
//
//   @override
//   bool updateShouldNotify(covariant _InheritedRouteState oldWidget) {
//     return oldWidget.routeState != routeState;
//   }
// }
