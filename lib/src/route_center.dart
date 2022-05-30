import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_router/src/context.dart';
import 'package:sm_router/src/route_node.dart';
import 'package:sm_router/src/route_registry.dart';
import 'package:sm_router/src/router_delegate.dart';

/// RouteCenter
class RouteCenter extends RouteInformationParser<PageContext> {
  RouteCenter();

  static final RouteCenter instance = RouteCenter();

  final _delegate = Delegate();

  RouterDelegate<PageContext> get routerDelegate => _delegate;

  RouteInformationParser<PageContext> get routeInformationParser => this;

  final _registry = Registry();

  final _random = Random(DateTime.now().millisecondsSinceEpoch);

  void setUnknown(RouterWidgetBuilder widgetBuilder) {
    _registry.unknown = widgetBuilder;
  }

  void setPageBuilder(RouterPageBuilder pageBuilder) {
    _registry.pageBuilder = pageBuilder;
  }

  void use(RouterInterceptor interceptor) {
    _registry.use(interceptor);
  }

  /// 注册路由.
  RouteNode handle(String name, RouterWidgetBuilder widgetBuilder, [RouterPageBuilder? pageBuilder]) {
    return _registry.handle(name, widgetBuilder, pageBuilder);
  }

  /// 移除路由.
  void remove(String name) {
    _registry.remove(name);
  }

  Future<T?> push<T extends Object?>(String routeName, {Object? arguments}) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.push(ctx);
  }

  Future<T?> replace<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    var ctx = _buildContext(routeName, arguments: arguments);
    return _delegate.replace(ctx, result: result, arguments: arguments);
  }

  Future<bool> pop<T extends Object?>([T? result]) {
    return _delegate.pop(result);
  }

  PageContext _buildContext(String routeName, {LocalKey? key, Object? arguments}) {
    key ??= ValueKey("$routeName-${_random.nextDouble()}");
    var ctx = PageContext(routeName, key, arguments);

    var node = _registry.node(ctx.routeName);

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
    child ??= node.widgetBuilder(ctx);

    var pageBuilder = node.pageBuilder ?? _registry.pageBuilder;
    ctx.page = pageBuilder(ctx, child);

    return ctx;
  }

  /// 实现 RouteInformationParser
  @override
  Future<PageContext> parseRouteInformation(RouteInformation routeInformation) {
    String routeName = routeInformation.location ?? "/";
    var ctx = _buildContext(routeName, arguments: routeInformation.state);
    return SynchronousFuture(ctx);
  }

  @override
  RouteInformation restoreRouteInformation(PageContext configuration) {
    return RouteInformation(location: configuration.requestName, state: configuration.arguments);
  }
}
