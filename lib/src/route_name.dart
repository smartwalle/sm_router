import 'package:sm_router/src/route_param.dart';

class KIRouteName {
  KIRouteName(this.name, [this.arguments]) {
    _param = KIRouteParam();
  }

  KIRouteName.decode(String value) {
    var uri = Uri.parse(value);
    name = uri.path;
    _param = KIRouteParam(uri.queryParametersAll);
  }

  KIRouteName.from(this.name, Map<String, List<String>> param) {
    _param = KIRouteParam(param);
  }

  late String name;

  Object? arguments;

  late KIRouteParam _param;

  Map<String, List<String>> all() {
    return _param.all();
  }

  String? get(String key) {
    return _param.get(key);
  }

  List<String>? values(String key) {
    return _param.values(key);
  }

  KIRouteName add(String key, String value) {
    _param.add(key, value);
    return this;
  }

  KIRouteName addAll(String key, List<String> values) {
    _param.addAll(key, values);
    return this;
  }

  KIRouteName set(String key, String value) {
    _param.set(key, value);
    return this;
  }

  KIRouteName setAll(String key, List<String> values) {
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
