class RouteName {
  RouteName(this.name);

  RouteName.decode(String value) {
    var uri = Uri.parse(value);
    name = uri.path;
    _params.addAll(uri.queryParametersAll);
  }

  RouteName.from(this.name, Map<String, List<String>> params) {
    _params.addAll(params);
  }

  late String name;

  final Map<String, List<String>> _params = <String, List<String>>{};

  RouteName set(String key, String value) {
    var values = _params[key];
    if (values == null) {
      values = <String>[];
      _params[key] = values;
    }
    values.add(value);
    return this;
  }

  del(String key) {
    _params.remove(key);
  }

  String encode() {
    var uri = Uri(path: name, queryParameters: _params);
    return uri.toString();
  }

  @override
  String toString() {
    return encode();
  }
}
