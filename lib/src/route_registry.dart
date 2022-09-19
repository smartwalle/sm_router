import 'package:flutter/material.dart';
import 'package:sm_router/src/route_node.dart';

RouteNode _defaultUnknownNode = RouteNode(builder: (ctx) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Page Not Found"),
    ),
    backgroundColor: Colors.white,
    body: Center(
      child: SelectableText(
        "\"${ctx.routeName}\" not found.",
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
        ),
      ),
    ),
  );
});

RouteNode _defaultErrorNode = RouteNode(builder: (ctx) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Error"),
    ),
    backgroundColor: Colors.redAccent,
    body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SelectableText(
            ctx.error!.error.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: SelectableText(
                  ctx.error!.stack.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
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

  RouteNode _error = _defaultErrorNode;

  RouterPageBuilder pageBuilder = _defaultPageBuilder;

  NavigatorWrapper navigatorWrapper = _defaultNavigatorWrapper;

  KeyBuilder keyBuilder = _defaultKeyBuilder;

  final Map<String, RouteNode> _routes = <String, RouteNode>{};

  RouteNode route(String routeName) {
    return _routes[routeName] ?? _unknown;
  }

  void setUnknownBuilder(RouterWidgetBuilder builder) {
    _unknown = RouteNode(builder: builder);
  }

  void setErrorBuilder(RouterWidgetBuilder builder) {
    _error = RouteNode(builder: builder);
  }

  RouteNode get errorRoute => _error;

  void use(RouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  RouteNode handle(
    String routeName,
    RouterWidgetBuilder builder, {
    KeyBuilder? keyBuilder,
    RouterPageBuilder? pageBuilder,
    NavigatorWrapper? navigatorWrapper,
  }) {
    var route = RouteNode(
      builder: builder,
      keyBuilder: keyBuilder,
      pageBuilder: pageBuilder,
      navigatorWrapper: navigatorWrapper,
    );
    _routes[routeName] = route;
    return route;
  }

  void remove(String routeName) {
    _routes.remove(routeName);
  }
}
