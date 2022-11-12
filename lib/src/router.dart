import 'package:flutter/material.dart';
import 'package:sm_router/src/router_context.dart';
import 'package:sm_router/src/route_information_parser.dart';
import 'package:sm_router/src/route_name.dart';
import 'package:sm_router/src/route.dart';
import 'package:sm_router/src/router_delegate.dart';
import 'package:sm_router/src/route_information_provider.dart';

class KIRouter {
  KIRouter._internal();

  static final _delegate = KIRouterDelegate();

  static final _routeParser = KIRouteInformationParser();

  static RouterDelegate<String> get routerDelegate => _delegate;

  static RouteInformationParser<String> get routeInformationParser => _routeParser;

  static RouteInformationProvider routeInformationProvider(String initialLocation) {
    return KIRouteInformationProvider(initialLocation: initialLocation);
  }

  /// 注册未知路由提示页面.
  static void setUnknownBuilder(KIRouterWidgetBuilder builder) {
    _delegate.registry.setUnknownBuilder(builder);
  }

  /// 注册错误提示页面.
  static void setErrorBuilder(KIRouterWidgetBuilder builder) {
    _delegate.registry.setErrorBuilder(builder);
  }

  /// 注册 Page 生成器.
  static void setPageBuilder(KIRouterPageBuilder pageBuilder) {
    _delegate.registry.pageBuilder = pageBuilder;
  }

  /// 注册全局拦截器.
  static void use(KIRouterInterceptor interceptor) {
    _delegate.registry.use(interceptor);
  }

  /// 注册路由.
  static KIRoute handle(
    String routeName,
    KIRouterWidgetBuilder builder, {
    KIRouteKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    return _delegate.registry.handle(
      routeName,
      builder,
      keyBuilder: keyBuilder,
      pageBuilder: pageBuilder,
      navigatorWrapper: navigatorWrapper,
    );
  }

  /// 移除路由.
  static void remove(String routeName) {
    _delegate.registry.remove(routeName);
  }

  static void setNavigatorWrapper(KINavigatorWrapper wrapper) {
    _delegate.registry.navigatorWrapper = wrapper;
  }

  static void setKeyBuilder(KIRouteKeyBuilder builder) {
    _delegate.registry.keyBuilder = builder;
  }

  static Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.push(routeName, arguments);
  }

  static void pushRoutes(List<KIRouteName> routeNames) {
    return _delegate.pushRoutes(routeNames);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) {
    return _delegate.pushReplacement(routeName, result, arguments);
  }

  static void pushRoutesReplacement<T extends Object?>(List<KIRouteName> routeNames, {T? result}) {
    return _delegate.pushRoutesReplacement(routeNames, result);
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, KIRoutePredicate predicate, {Object? arguments}) {
    return _delegate.pushAndRemoveUntil(routeName, predicate, arguments);
  }

  static void pushRoutesAndRemoveUntil(List<KIRouteName> routeNames, KIRoutePredicate predicate) {
    return _delegate.pushRoutesAndRemoveUntil(routeNames, predicate);
  }

  static void pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.pushAndRemoveAll(routeName, arguments);
  }

  static void pushRoutesAndRemoveAll(List<KIRouteName> routeNames) {
    return _delegate.pushRoutesAndRemoveAll(routeNames);
  }

  static Future<T?> replace<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) {
    return _delegate.pushReplacement(routeName, result, arguments);
  }

  static void show<T extends Object?>(String routeName, {Object? arguments}) {
    return _delegate.show(routeName, arguments);
  }

  static void showRoutes(List<KIRouteName> routeNames) {
    return _delegate.showRoutes(routeNames);
  }

  static bool canPop() {
    return _delegate.canPop();
  }

  static Future<bool> pop<T extends Object?>([T? result]) {
    return _delegate.pop(result);
  }

  static Future<bool> popMatched<T extends Object?>(KIRoutePredicate predicate, [T? result]) {
    return _delegate.popMatched(predicate, result);
  }

  static void popUntil(KIRoutePredicate predicate) {
    _delegate.popUntil(predicate);
  }

  static Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) {
    return _delegate.popAndPush(routeName, result, arguments);
  }

  static void popAndPushRoutes<T extends Object?>(List<KIRouteName> routeNames, [T? result]) {
    return _delegate.popAndPushRoutes(routeNames, result);
  }

  static Future<bool> popToRoot() {
    return _delegate.popToRoot();
  }

  static bool contains(KIRoutePredicate predicate) {
    return _delegate.contains(predicate);
  }

  static KIRouterContext? get top => _delegate.top;

  static void navigate(BuildContext context, VoidCallback callback) {
    Router.navigate(context, callback);
  }

  static void neglect(BuildContext context, VoidCallback callback) {
    Router.neglect(context, callback);
  }
}
