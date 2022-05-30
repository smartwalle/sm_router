import 'package:flutter/widgets.dart';
import 'package:sm_router/src/context.dart';

typedef RouterWidgetBuilder = Widget Function(Context ctx);
typedef RouterInterceptor = Widget? Function(RouteContext ctx);
typedef RouterPageBuilder = Page<dynamic> Function(Context ctx, Widget child);

class RouteNode {
  RouteNode({required RouterWidgetBuilder builder, RouterPageBuilder? pageBuilder}) {
    _builder = builder;
    _pageBuilder = pageBuilder;
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
}
