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

/// RouteRegistry
class Registry {
  Registry();

  final List<RouterInterceptor> _interceptors = <RouterInterceptor>[];

  List<RouterInterceptor> get interceptors => _interceptors;

  RouteNode _unknown = _defaultUnknownNode;

  RouterPageBuilder pageBuilder = _defaultPageBuilder;

  final Map<String, RouteNode> _nodes = <String, RouteNode>{};

  RouteNode getNode(String name) {
    return _nodes[name] ?? _unknown;
  }

  void setUnknownBuilder(RouterWidgetBuilder builder) {
    _unknown = RouteNode(builder: builder);
  }

  void use(RouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  RouteNode handle(String name, RouterWidgetBuilder builder, [RouterPageBuilder? pageBuilder]) {
    var node = RouteNode(builder: builder, pageBuilder: pageBuilder);
    _nodes[name] = node;
    return node;
  }

  void remove(String name) {
    _nodes.remove(name);
  }
}
