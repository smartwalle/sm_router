import 'package:flutter/widgets.dart';
import 'package:sm_router/sm_router.dart';
import 'package:sm_router/src/router_context.dart';

typedef KIRouterWidgetBuilder = Widget Function(KIRouterContext ctx);
typedef KIRouterWidgetWrapper = Widget Function(KIRouterContext ctx, Widget child);
typedef KIRouterInterceptor = KIRedirect? Function(KIRouterContext ctx);
typedef KIRouterPageBuilder = Page<dynamic> Function(KIRouterContext ctx, Widget child);
typedef KINavigatorWrapper = Widget Function(KIRouterContext ctx, Navigator navigator);
typedef KIPageKeyBuilder = LocalKey? Function(KIRouterContext ctx);

class KIRoute {
  KIRoute({
    required KIRouterWidgetBuilder builder,
    String? title,
    KIRouterWidgetWrapper? widgetWrapper,
    KIPageKeyBuilder? keyBuilder,
    KIRouterPageBuilder? pageBuilder,
    KINavigatorWrapper? navigatorWrapper,
  }) {
    _builder = builder;
    _title = title;
    _widgetWrapper = widgetWrapper;
    _keyBuilder = keyBuilder;
    _pageBuilder = pageBuilder;
    _navigatorWrapper = navigatorWrapper;
  }

  // 浏览器标签 title
  String? _title;

  String? get title => _title;

  // Widget 生成器
  late final KIRouterWidgetBuilder _builder;

  KIRouterWidgetBuilder get builder => _builder;

  // Widget Wrapper
  KIRouterWidgetWrapper? _widgetWrapper;

  KIRouterWidgetWrapper? get widgetWrapper => _widgetWrapper;

  KIRoute setWidgetWrapper(KIRouterWidgetWrapper wrapper) {
    _widgetWrapper = wrapper;
    return this;
  }

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

/// KIRouter.handle("/redirect", (ctx) => const Text("会重定向到路由 /test")).use((ctx) => KIRedirect("/test));
class KIRedirect extends RouteSettings {
  /// 路由重定向
  const KIRedirect(
    String name, {
    Object? arguments,
  }) : super(name: name, arguments: arguments);
}

/// KIRouter.handle("/discard", (ctx) => const Text("不会跳转到路由 /discard")).use((ctx) => KIDiscard());
class KIDiscard extends KIRedirect {
  /// 取消路由跳转
  KIDiscard() : super("discard");
}
