import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/context.dart';

typedef RouterWidgetBuilder = Widget Function(Context ctx);
typedef RouterInterceptor = Redirect? Function(Context ctx);
typedef RouterPageBuilder = Page<dynamic> Function(Context ctx, Widget child);
typedef NavigatorWrapper = Widget Function(Context ctx, Navigator navigator);
typedef KeyBuilder = LocalKey Function(Context ctx);

class RouteNode {
  RouteNode({
    required RouterWidgetBuilder builder,
    RouterPageBuilder? pageBuilder,
    NavigatorWrapper? navigatorWrapper,
  }) {
    _builder = builder;
    _pageBuilder = pageBuilder;
    _navigatorWrapper = navigatorWrapper;
  }

  // Widget 生成器
  late final RouterWidgetBuilder _builder;

  RouterWidgetBuilder get builder => _builder;

  // 拦截器
  final List<RouterInterceptor> _interceptors = <RouterInterceptor>[];

  List<RouterInterceptor> get interceptors => _interceptors;

  RouteNode use(RouterInterceptor interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  // Page 生成器
  RouterPageBuilder? _pageBuilder;

  RouterPageBuilder? get pageBuilder => _pageBuilder;

  RouteNode setPageBuilder(RouterPageBuilder builder) {
    _pageBuilder = builder;
    return this;
  }

  // Navigator Wrapper
  NavigatorWrapper? _navigatorWrapper;

  NavigatorWrapper? get navigatorWrapper => _navigatorWrapper;

  RouteNode setNavigatorWrapper(NavigatorWrapper wrapper) {
    _navigatorWrapper = wrapper;
    return this;
  }

  // key 生成器
  KeyBuilder? _keyBuilder;

  KeyBuilder? get keyBuilder => _keyBuilder;

  RouteNode setKeyBuilder(KeyBuilder builder) {
    _keyBuilder = builder;
    return this;
  }
}

class Redirect extends RouteSettings {
  const Redirect(
    String name, {
    Object? arguments,
  }) : super(name: name, arguments: arguments);
}
