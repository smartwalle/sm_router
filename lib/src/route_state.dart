import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/route_information_parser.dart';
import 'package:sm_router/src/route_node.dart';
import 'package:sm_router/src/router_delegate.dart';
import 'package:sm_router/src/route_name.dart';

/// RouteState
class RouteState {
  RouteState() {
    _delegate = Delegate(
      navigatorWrapper: (ctx, navigator) {
        return navigator;
      },
      // navigatorWrapper: (ctx, navigator) {
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

  RouterDelegate<String> get routerDelegate => _delegate;

  final _routeParser = RouteParser();

  RouteInformationParser<String> get routeInformationParser => _routeParser;

  /// 注册未知路由提示页面.
  void setUnknownBuilder(RouterWidgetBuilder builder) {
    _delegate.registry.setUnknownBuilder(builder);
  }

  /// 注册 Page 生成器.
  void setPageBuilder(RouterPageBuilder pageBuilder) {
    _delegate.registry.pageBuilder = pageBuilder;
  }

  /// 注册全局拦截器.
  void use(RouterInterceptor interceptor) {
    _delegate.registry.use(interceptor);
  }

  /// 注册路由.
  RouteNode handle(String routeName, RouterWidgetBuilder builder, [RouterPageBuilder? pageBuilder]) {
    return _delegate.registry.handle(routeName, builder, pageBuilder);
  }

  /// 移除路由.
  void remove(String routeName) {
    _delegate.registry.remove(routeName);
  }

  void setRouterNeglect(bool value) {
    _delegate.routerNeglect = value;
  }

  void setNavigatorWrapper(NavigatorWrapper wrapper) {
    _delegate.navigatorWrapper = wrapper;
    // _delegate.navigatorWrapper = (ctx, navigator) {
    //   return _InheritedRouteState(
    //     routeState: this,
    //     child: wrapper(ctx, navigator),
    //   );
    // };
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.push(routeName, arguments);
  }

  void pushRoutes(List<RouteName> routeNames) {
    return _delegate.pushRoutes(routeNames);
  }

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    return _delegate.pushReplacement(routeName, result, arguments);
  }

  void pushRoutesReplacement<T extends Object?>(List<RouteName> routeNames, {T? result}) {
    return _delegate.pushRoutesReplacement(routeNames, result);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, Predicate predicate, {Object? arguments}) {
    return _delegate.pushAndRemoveUntil(routeName, predicate, arguments);
  }

  void pushRoutesAndRemoveUntil(List<RouteName> routeNames, Predicate predicate) {
    return _delegate.pushRoutesAndRemoveUntil(routeNames, predicate);
  }

  void pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.pushAndRemoveAll(routeName, arguments);
  }

  void pushRoutesAndRemoveAll(List<RouteName> routeNames) {
    return _delegate.pushRoutesAndRemoveAll(routeNames);
  }

  void show<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.show(routeName, arguments);
  }

  void showRoutes(List<RouteName> routeNames) {
    return _delegate.showRoutes(routeNames);
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

  Future<bool> popMatched<T extends Object?>(Predicate predicate, [T? result]) {
    return _delegate.popMatched(predicate, result);
  }

  void popUntil(Predicate predicate) {
    _delegate.popUntil(predicate);
  }

  Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    return _delegate.popAndPush(routeName, result, arguments);
  }

  void popAndPushRoutes<T extends Object?>(List<RouteName> routeNames, [T? result]) {
    return _delegate.popAndPushRoutes(routeNames, result);
  }

  Future<bool> popToRoot() {
    return _delegate.popToRoot();
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
