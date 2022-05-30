class QueryParam {
  QueryParam(Map<String, List<String>> params) {
    _params = params;
  }

  late final Map<String, List<String>> _params;

  String? get(String key) {
    var values = _params[key];
    if (values != null && values.isNotEmpty) {
      return values[0];
    }
    return null;
  }

  QueryParam set(String key, value) {
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

  List<String>? values(String key) {
    return _params[key];
  }

  Map<String, List<String>> all() {
    return Map<String, List<String>>.unmodifiable(_params);
  }
}
