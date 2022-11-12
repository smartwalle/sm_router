import 'package:flutter/material.dart';
import 'package:sm_router/src/route.dart';

KIRoute _defaultUnknownRoute = KIRoute(builder: (ctx) {
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

KIRoute _defaultErrorRoute = KIRoute(builder: (ctx) {
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

KIRouterPageBuilder _defaultPageBuilder = (ctx, child) {
  return MaterialPage(
    key: ctx.key,
    child: child,
    name: ctx.requestName,
    arguments: ctx.arguments,
  );
};

KINavigatorWrapper _defaultNavigatorWrapper = (ctx, navigator) {
  return navigator;
};

KIRouteKeyBuilder _defaultKeyBuilder = (ctx) {
  return UniqueKey();
};

/// KIRouteRegistry
class KIRouteRegistry {
  KIRouteRegistry();

  final List<KIRouterInterceptor> _interceptors = <KIRouterInterceptor>[];

  List<KIRouterInterceptor> get interceptors => _interceptors;

  final List<NavigatorObserver> _observers = <NavigatorObserver>[];

  List<NavigatorObserver> get observers => _observers;

  KIRoute _unknown = _defaultUnknownRoute;

  KIRoute _error = _defaultErrorRoute;

  KIRouterPageBuilder pageBuilder = _defaultPageBuilder;

  KINavigatorWrapper navigatorWrapper = _defaultNavigatorWrapper;

  KIRouteKeyBuilder keyBuilder = _defaultKeyBuilder;

  final Map<String, KIRoute> _routes = <String, KIRoute>{};

  KIRoute route(String routeName) {
    return _routes[routeName] ?? _unknown;
  }

  void setUnknownBuilder(KIRouterWidgetBuilder builder) {
    _unknown = KIRoute(builder: builder);
  }

  void setErrorBuilder(KIRouterWidgetBuilder builder) {
    _error = KIRoute(builder: builder);
  }

  KIRoute get errorRoute => _error;

  void use(KIRouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void addObserver(NavigatorObserver observer) {
    if (!observers.contains(observer)) {
      observers.add(observer);
    }
  }

  void removeObserver(NavigatorObserver observer) {
    if (observers.contains(observer)) {
      observers.remove(observer);
    }
  }

  KIRoute handle(
    String routeName,
    KIRouterWidgetBuilder builder, {
    KIRouteKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    var route = KIRoute(
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
