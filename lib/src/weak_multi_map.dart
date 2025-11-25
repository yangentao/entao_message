typedef WeakList<T extends Object> = List<WeakReference<T>>;

extension WeakListExt<T extends Object> on WeakList<T> {
  bool containsValue(T value) {
    for (var e in this) {
      if (identical(e.target, value)) return true;
    }
    return false;
  }

  void addValue(T value) {
    if (containsValue(value)) return;
    this.add(WeakReference(value));
  }

  void removeValue(T value) {
    this.removeWhere((e) => e.target == null || identical(e.target, value));
  }

  void clearNullValue() {
    this.removeWhere((e) => e.target == null);
  }
}

class WeakMultiMap<K extends Object, V extends Object> {
  final Map<K, WeakList<V>> _map = {};

  bool get isEmpty => _map.isEmpty;

  bool get isNotEmpty => _map.isNotEmpty;

  int get length => _map.length;

  Iterable<K> get keys => _map.keys;

  Iterable<MapEntry<K, WeakList<V>>> get entries => _map.entries;

  WeakList<V>? operator [](K key) {
    return _map[key];
  }

  void operator []=(K key, V value) {
    add(key, value);
  }

  WeakList<V>? get(K key) {
    return _map[key];
  }

  void add(K key, V value) {
    WeakList<V>? ls = _map[key];
    if (ls == null) {
      _map[key] = [WeakReference(value)];
    } else {
      ls.addValue(value);
      ls.clearNullValue();
    }
  }

  bool containsValue(V value, {K? key}) {
    if (key != null) {
      return _map[key]?.containsValue(value) ?? false;
    }
    for (var e in _map.entries) {
      if (e.value.containsValue(value)) return true;
    }
    return false;
  }

  bool containsKey(K key) {
    return _map.containsKey(key);
  }

  WeakList<V>? remove(K key) {
    return _map.remove(key);
  }

  void removeValue(V value, {K? key}) {
    if (key != null) {
      _map[key]?.removeValue(value);
    } else {
      for (var e in _map.entries) {
        e.value.removeValue(value);
      }
    }
  }

  void clear() {
    _map.clear();
  }
}
