import 'package:flutter/material.dart';
import 'package:sm_router/src/route_node.dart';

RouteNode _defaultUnknownNode = RouteNode(builder: (ctx) {
  return Scaffold(
    appBar: AppBar(),
    backgroundColor: Colors.white,
    body: Center(
      child: Text(
        "\"${ctx.routeName}\" not found.",
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 22,
        ),
      ),
    ),
  );
});

RouterPageBuilder _defaultPageBuilder = (ctx, child) {
  return MaterialPage(
    key: ctx.key,
    child: child,
    name: ctx.requestName,
    arguments: ctx.arguments,
  );
};

NavigatorWrapper _defaultNavigatorWrapper = (ctx, navigator) {
  return navigator;
};

KeyBuilder _defaultKeyBuilder = (ctx) {
  return UniqueKey();
};

/// RouteRegistry
class Registry {
  Registry();

  final List<RouterInterceptor> _interceptors = <RouterInterceptor>[];

  List<RouterInterceptor> get interceptors => _interceptors;

  RouteNode _unknown = _defaultUnknownNode;

  RouterPageBuilder pageBuilder = _defaultPageBuilder;

  NavigatorWrapper navigatorWrapper = _defaultNavigatorWrapper;

  KeyBuilder keyBuilder = _defaultKeyBuilder;

  final Map<String, RouteNode> _nodes = <String, RouteNode>{};

  RouteNode getNode(String routeName) {
    return _nodes[routeName] ?? _unknown;
  }

  void setUnknownBuilder(RouterWidgetBuilder builder) {
    _unknown = RouteNode(builder: builder);
  }

  void use(RouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  RouteNode handle(
    String routeName,
    RouterWidgetBuilder builder, {
    RouterPageBuilder? pageBuilder,
    NavigatorWrapper? navigatorWrapper,
  }) {
    var node = RouteNode(builder: builder, pageBuilder: pageBuilder, navigatorWrapper: navigatorWrapper);
    _nodes[routeName] = node;
    return node;
  }

  void remove(String routeName) {
    _nodes.remove(routeName);
  }
}
