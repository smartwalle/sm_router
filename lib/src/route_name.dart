import 'package:sm_router/src/query_param.dart';

class RouteName {
  RouteName(this.name, [this.arguments]) {
    _param = QueryParam();
  }

  RouteName.decode(String value) {
    var uri = Uri.parse(value);
    name = uri.path;
    _param = QueryParam(uri.queryParametersAll);
  }

  RouteName.from(this.name, Map<String, List<String>> param) {
    _param = QueryParam(param);
  }

  late String name;

  Object? arguments;

  late QueryParam _param;

  Map<String, List<String>> all() {
    return _param.all();
  }

  String? get(String key) {
    return _param.get(key);
  }

  List<String>? values(String key) {
    return _param.values(key);
  }

  RouteName add(String key, String value) {
    _param.add(key, value);
    return this;
  }

  RouteName addAll(String key, List<String> values) {
    _param.addAll(key, values);
    return this;
  }

  RouteName set(String key, String value) {
    _param.set(key, value);
    return this;
  }

  RouteName setAll(String key, List<String> values) {
    _param.setAll(key, values);
    return this;
  }

  remove(String key) {
    _param.remove(key);
  }

  String encode() {
    var uri = Uri(path: name, queryParameters: _param.all());
    return uri.toString();
  }

  @override
  String toString() {
    return encode();
  }
}
