import 'package:flutter/material.dart';
import 'package:sm_router/src/route.dart';

/// KIRouteRegistry
class KIRouteRegistry {
  KIRouteRegistry();

  final List<KIRouterInterceptor> _interceptors = <KIRouterInterceptor>[];

  List<KIRouterInterceptor> get interceptors => _interceptors;

  final List<NavigatorObserver> _observers = <NavigatorObserver>[];

  List<NavigatorObserver> get observers => _observers;

  KIRoute _unknown = KIRoute(builder: (ctx) {
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

  KIRoute _error = KIRoute(builder: (ctx) {
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

  KIRouterWidgetWrapper widgetWrapper = (ctx, widget) {
    return widget;
  };

  KIRouterPageBuilder pageBuilder = (ctx, child) {
    return MaterialPage(
      key: ctx.key,
      child: child,
      name: ctx.requestName,
      arguments: ctx.arguments,
    );
  };

  KINavigatorWrapper navigatorWrapper = (ctx, navigator) {
    return navigator;
  };

  KIPageKeyBuilder keyBuilder = (ctx) {
    return UniqueKey();
  };

  final Map<String, KIRoute> _routes = <String, KIRoute>{};

  KIRoute route(String routeName) {
    return _routes[routeName] ?? _unknown;
  }

  KIRoute get errorRoute => _error;

  void use(KIRouterInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  void addObserver(NavigatorObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  void removeObserver(NavigatorObserver observer) {
    if (_observers.contains(observer)) {
      _observers.remove(observer);
    }
  }

  KIRoute handle(
    String routeName,
    KIRouterWidgetBuilder builder, {
    String? title,
    KIRouterWidgetWrapper? widgetWrapper,
    KIPageKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    var route = KIRoute(
      builder: builder,
      title: title,
      widgetWrapper: widgetWrapper,
      keyBuilder: keyBuilder,
      pageBuilder: pageBuilder,
      navigatorWrapper: navigatorWrapper,
    );
    _routes[routeName] = route;
    return route;
  }

  KIRoute handleUnknownRoute(
    KIRouterWidgetBuilder builder, {
    String? title,
    KIRouterWidgetWrapper? widgetWrapper,
    KIPageKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    _unknown = KIRoute(
      builder: builder,
      title: title,
      widgetWrapper: widgetWrapper,
      keyBuilder: keyBuilder,
      pageBuilder: pageBuilder,
      navigatorWrapper: navigatorWrapper,
    );
    return _unknown;
  }

  KIRoute handleError(
    KIRouterWidgetBuilder builder, {
    String? title,
    KIRouterWidgetWrapper? widgetWrapper,
    KIPageKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    _error = KIRoute(
      builder: builder,
      title: title,
      widgetWrapper: widgetWrapper,
      keyBuilder: keyBuilder,
      pageBuilder: pageBuilder,
      navigatorWrapper: navigatorWrapper,
    );
    return _error;
  }

  void remove(String routeName) {
    _routes.remove(routeName);
  }
}
