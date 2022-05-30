import 'package:sm_router/src/route.dart';

class RouteNode {
  RouteNode({required RouterWidgetBuilder widgetBuilder, RouterPageBuilder? pageBuilder}) {
    _widgetBuilder = widgetBuilder;
    _pageBuilder = pageBuilder;
  }

  // Widget 生成器
  late final RouterWidgetBuilder _widgetBuilder;

  RouterWidgetBuilder get widgetBuilder => _widgetBuilder;

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
}
