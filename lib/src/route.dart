import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/route_center.dart';

class Routes {
  Routes._internal();

  static RouterDelegate<PageContext> get routerDelegate => RouteCenter.instance.routerDelegate;

  static RouteInformationParser<PageContext> get routeInformationParser => RouteCenter.instance;

  /// 注册未知路由提示页面.
  static void setUnknownHandler(RouterWidgetBuilder widgetBuilder) {
    RouteCenter.instance.setUnknown(widgetBuilder);
  }

  /// 注册 Page 生成器.
  static void setPageBuilder(RouterPageBuilder pageBuilder) {
    RouteCenter.instance.setPageBuilder(pageBuilder);
  }

  /// 注册全局拦截器
  static void use(RouterInterceptor interceptor) {
    RouteCenter.instance.use(interceptor);
  }

  /// 注册路由.
  static RouteNode handle(String name, RouterWidgetBuilder widgetBuilder, [RouterPageBuilder? pageBuilder]) {
    return RouteCenter.instance.handle(name, widgetBuilder, pageBuilder);
  }

  /// 移除路由
  static void remove(String name) {
    RouteCenter.instance.remove(name);
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

  static Future<bool> pop<T extends Object?>([T? result]) {
    return RouteCenter.instance.pop(result);
  }
}
