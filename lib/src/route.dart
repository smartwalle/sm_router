import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/router_context.dart';

typedef KIRouterWidgetBuilder = Widget Function(KIRouterContext ctx);
typedef KIRouterInterceptor = KIRedirect? Function(KIRouterContext ctx);
typedef KIRouterPageBuilder = Page<dynamic> Function(KIRouterContext ctx, Widget child);
typedef KINavigatorWrapper = Widget Function(KIRouterContext ctx, Navigator navigator);
typedef KIPageKeyBuilder = LocalKey? Function(KIRouterContext ctx);

class KIRoute {
  KIRoute({
    required KIRouterWidgetBuilder builder,
    KIPageKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    _builder = builder;
    _keyBuilder = keyBuilder;
    _pageBuilder = pageBuilder;
    _navigatorWrapper = navigatorWrapper;
  }

  // Widget 生成器
  late final KIRouterWidgetBuilder _builder;

  KIRouterWidgetBuilder get builder => _builder;

  // 拦截器
  final List<KIRouterInterceptor> _interceptors = <KIRouterInterceptor>[];

  List<KIRouterInterceptor> get interceptors => _interceptors;

  KIRoute use(KIRouterInterceptor interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  // Page 生成器
  KIRouterPageBuilder? _pageBuilder;

  KIRouterPageBuilder? get pageBuilder => _pageBuilder;

  KIRoute setPageBuilder(KIRouterPageBuilder builder) {
    _pageBuilder = builder;
    return this;
  }

  // Navigator Wrapper
  KINavigatorWrapper? _navigatorWrapper;

  KINavigatorWrapper? get navigatorWrapper => _navigatorWrapper;

  KIRoute setNavigatorWrapper(KINavigatorWrapper wrapper) {
    _navigatorWrapper = wrapper;
    return this;
  }

  // key 生成器
  KIPageKeyBuilder? _keyBuilder;

  KIPageKeyBuilder? get keyBuilder => _keyBuilder;

  KIRoute setKeyBuilder(KIPageKeyBuilder builder) {
    _keyBuilder = builder;
    return this;
  }
}

class KIRedirect extends RouteSettings {
  const KIRedirect(
    String name, {
    Object? arguments,
  }) : super(name: name, arguments: arguments);
}
