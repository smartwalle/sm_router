import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sm_router/sm_router.dart';

abstract class Context {
  Context(Uri uri, LocalKey? key, Object? arguments) {
    _uri = uri;
    _requestName = _uri.toString();
    _queryParam = QueryParam(_uri.queryParametersAll);
    _key = key;
    _arguments = arguments;
  }

  late LocalKey? _key;

  LocalKey? get key => _key;

  late Uri _uri;

  // 路由名称
  String get routeName => _uri.path;

  // 路由查询参数
  String get query => _uri.query;

  // 请求名称，路由名称加路由查询参数组成
  late String _requestName;

  String get requestName => _requestName;

  // 路由查询参数
  late QueryParam _queryParam;

  QueryParam get queryParam => _queryParam;

  // 路由参数，建议只在在非 web 应用中使用
  late Object? _arguments;

  Object? get arguments => _arguments;

  // 自定义数据
  final Map<String, Object> _data = <String, Object>{};

  Map<String, Object?> get data => _data;

  Object? get(String key) {
    return _data[key];
  }

  set(String key, Object value) {
    _data[key] = value;
  }

  remove(String key) {
    _data.remove(key);
  }
}

class RouteContext extends Context {
  RouteContext(super.uri, super.key, super.arguments, this.node) : result = Completer();

  RouteNode node;

  final Completer result;
}
