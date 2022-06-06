import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

class RouteCenter {
  RouteCenter._internal();

  static RouterDelegate<String> get routerDelegate => RouteState.instance.routerDelegate;

  static RouteInformationParser<String> get routeInformationParser => RouteState.instance.routeInformationParser;

  static void setUnknownBuilder(RouterWidgetBuilder builder) {
    RouteState.instance.setUnknownBuilder(builder);
  }

  static void setPageBuilder(RouterPageBuilder pageBuilder) {
    RouteState.instance.setPageBuilder(pageBuilder);
  }

  static void use(RouterInterceptor interceptor) {
    RouteState.instance.use(interceptor);
  }

  static RouteNode handle(String routeName, RouterWidgetBuilder builder, [RouterPageBuilder? pageBuilder]) {
    return RouteState.instance.handle(routeName, builder, pageBuilder);
  }

  static void remove(String routeName) {
    RouteState.instance.remove(routeName);
  }

  static void setRouterNeglect(bool value) {
    RouteState.instance.setRouterNeglect(value);
  }

  static void setNavigatorWrapper(NavigatorWrapper wrapper) {
    RouteState.instance.setNavigatorWrapper(wrapper);
  }

  static Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return RouteState.instance.push(routeName, arguments: arguments);
  }

  static void pushRoutes(List<RouteName> routeNames) {
    return RouteState.instance.pushRoutes(routeNames);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) {
    return RouteState.instance.pushReplacement(routeName, result: result, arguments: arguments);
  }

  static void pushRoutesReplacement<T extends Object?>(List<RouteName> routeNames, {T? result}) {
    return RouteState.instance.pushRoutesReplacement(routeNames, result: result);
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(String routeName, Predicate predicate, {Object? arguments}) {
    return RouteState.instance.pushAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  static void pushRoutesAndRemoveUntil(List<RouteName> routeNames, Predicate predicate) {
    return RouteState.instance.pushRoutesAndRemoveUntil(routeNames, predicate);
  }

  static void pushAndRemoveAll<T extends Object?>(String routeName, {Object? arguments}) {
    return RouteState.instance.pushAndRemoveAll(routeName, arguments: arguments);
  }

  static void pushRoutesAndRemoveAll(List<RouteName> routeNames) {
    return RouteState.instance.pushRoutesAndRemoveAll(routeNames);
  }

  static void show<T extends Object?>(String routeName, {Object? arguments}) {
    return RouteState.instance.show(routeName, arguments: arguments);
  }

  static void showRoutes(List<RouteName> routeNames) {
    return RouteState.instance.showRoutes(routeNames);
  }

  static bool canPop() {
    return RouteState.instance.canPop();
  }

  static Future<bool> maybePop<T extends Object?>([T? result]) {
    return RouteState.instance.maybePop(result);
  }

  static Future<bool> pop<T extends Object?>([T? result]) {
    return RouteState.instance.pop(result);
  }

  static Future<bool> popMatched<T extends Object?>(Predicate predicate, [T? result]) {
    return RouteState.instance.popMatched(predicate, result);
  }

  static void popUntil(Predicate predicate) {
    RouteState.instance.popUntil(predicate);
  }

  static Future<T?> popAndPush<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) async {
    return RouteState.instance.popAndPush(routeName, result: result, arguments: arguments);
  }

  static void popAndPushRoutes<T extends Object?>(List<RouteName> routeNames, [T? result]) {
    return RouteState.instance.popAndPushRoutes(routeNames, result);
  }

  static Future<bool> popToRoot() {
    return RouteState.instance.popToRoot();
  }

// static RouteState of(BuildContext context) {
//   return RouteState.of(context);
// }
}
