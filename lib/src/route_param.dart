class KIRouteParam {
  KIRouteParam([Map<String, List<String>>? data]) {
    _data = data ?? <String, List<String>>{};
  }

  late final Map<String, List<String>> _data;

  Map<String, List<String>> all() {
    return _data;
  }

  String? get(String key) {
    var values = _data[key];
    if (values != null && values.isNotEmpty) {
      return values[0];
    }
    return null;
  }

  List<String>? values(String key) {
    return _data[key];
  }

  KIRouteParam add(String key, String value) {
    return addAll(key, [value]);
  }

  KIRouteParam addAll(String key, List<String> values) {
    var nValues = _data[key];
    if (nValues == null) {
      _data[key] = values;
    } else {
      nValues.addAll(values);
    }
    return this;
  }

  KIRouteParam set(String key, String value) {
    return setAll(key, [value]);
  }

  KIRouteParam setAll(String key, List<String> values) {
    _data[key] = values;
    return this;
  }

  remove(String key) {
    _data.remove(key);
  }
}
