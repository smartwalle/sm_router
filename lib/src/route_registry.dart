import 'package:flutter/material.dart';
import 'package:sm_router/src/route_node.dart';

RouteNode _defaultUnknownNode = RouteNode(widgetBuilder: (ctx) {
  return Scaffold(
    appBar: AppBar(),
    backgroundColor: Colors.white,
    body: Center(
      child: Text(
        "\"${ctx.routeName}\" Not Found.",
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

  RouteNode _unknownNode = _defaultUnknownNode;

  RouterPageBuilder pageBuilder = _defaultPageBuilder;

  final Map<String, RouteNode> _nodes = <String, RouteNode>{};

  RouteNode node(String name) {
    return _nodes[name] ?? _unknownNode;
  }

  set unknown(RouterWidgetBuilder widgetBuilder) {
    _unknownNode = RouteNode(widgetBuilder: widgetBuilder);
  }

  void use(RouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  RouteNode handle(String name, RouterWidgetBuilder handler, [RouterPageBuilder? pageBuilder]) {
    var node = RouteNode(widgetBuilder: handler, pageBuilder: pageBuilder);
    _nodes[name] = node;
    return node;
  }

  void remove(String name) {
    _nodes.remove(name);
  }
}
