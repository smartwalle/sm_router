import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/route_center.dart';

class Routes {
  Routes._internal();

  static RouterDelegate<PageContext> get routerDelegate => RouteCenter.instance.routerDelegate;

  static RouteInformationParser<PageContext> get routeInformationParser => RouteCenter.instance;

  static void setInitialRouteName(String routeName) {
    RouteCenter.instance.setInitialRouteName(routeName);
  }

  static void setUnknownBuilder(RouterWidgetBuilder builder) {
    RouteCenter.instance.setUnknownBuilder(builder);
  }

  static void setPageBuilder(RouterPageBuilder pageBuilder) {
    RouteCenter.instance.setPageBuilder(pageBuilder);
  }

  static void use(RouterInterceptor interceptor) {
    RouteCenter.instance.use(interceptor);
  }

  static RouteNode handle(String routeName, RouterWidgetBuilder builder, [RouterPageBuilder? pageBuilder]) {
    return RouteCenter.instance.handle(routeName, builder, pageBuilder);
  }

  static void remove(String routeName) {
    RouteCenter.instance.remove(routeName);
  }

  static Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    return RouteCenter.instance.push(routeName, arguments: arguments);
  }

  static Future<T?> replace<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return RouteCenter.instance.replace(routeName, result: result, arguments: arguments);
  }

  static bool canPop() {
    return RouteCenter.instance.canPop();
  }

  static Future<bool> maybePop<T extends Object?>([T? result]) {
    return RouteCenter.instance.maybePop(result);
  }

  static Future<bool> pop<T extends Object?>([T? result]) {
    return RouteCenter.instance.pop(result);
  }

  static Future<bool> popToRoot() {
    return RouteCenter.instance.popToRoot();
  }
}
