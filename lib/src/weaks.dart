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
  final Map<K, WeakList<V>> map = {};

  bool get isEmpty => map.isEmpty;

  bool get isNotEmpty => map.isNotEmpty;

  int get length => map.length;

  Iterable<K> get keys => map.keys;

  Iterable<MapEntry<K, WeakList<V>>> get entries => map.entries;

  WeakList<V>? operator [](K key) {
    return map[key];
  }

  void operator []=(K key, V value) {
    add(key, value);
  }

  WeakList<V>? get(K key) {
    return map[key];
  }

  void add(K key, V value) {
    WeakList<V>? ls = map[key];
    if (ls == null) {
      map[key] = [WeakReference(value)];
    } else {
      ls.addValue(value);
      ls.clearNullValue();
    }
  }

  List<V> copyValues(K key) {
    WeakList<V>? ls = map[key];
    if (ls == null) return [];
    ls.clearNullValue();
    return ls.map((e) => e.target!).toList();
  }

  bool containsValue(V value, {K? key}) {
    if (key != null) {
      return map[key]?.containsValue(value) ?? false;
    }
    for (var e in map.entries) {
      if (e.value.containsValue(value)) return true;
    }
    return false;
  }

  bool containsKey(K key) {
    return map.containsKey(key);
  }

  WeakList<V>? remove(K key) {
    return map.remove(key);
  }

  void removeValue(V value, {K? key}) {
    if (key != null) {
      map[key]?.removeValue(value);
    } else {
      for (var e in map.entries) {
        e.value.removeValue(value);
      }
    }
  }

  void clear() {
    map.clear();
  }
}

typedef WeakSet<V extends Object> = Set<WeakReference<V>>;

extension WeakSetExt<V extends Object> on WeakSet<V> {
  void addValue(V value) {
    for (var w in this) {
      if (w.target == value) return;
    }
    add(WeakReference(value));
  }

  void removeValue(V value) {
    this.removeWhere((e) => e.target == null || identical(e.target, value));
  }

  List<V> copyValues() {
    return this.where((e) => e.target != null).map((e) => e.target!).toList();
  }
}
