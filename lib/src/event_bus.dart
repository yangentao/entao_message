import 'weak_multi_map.dart';

typedef BusCallback = void Function(Object event, Object? arg);

class EventBus {
  EventBus._();

  static final WeakMultiMap<Object, BusCallback> _map = WeakMultiMap<Object, BusCallback>();

  static void on(Object event, BusCallback callback) {
    var ls = _map[event];
    if (ls == null) {
      _map[event] = callback;
    } else {
      ls.addValue(callback);
    }
  }

  static void off({Object? event, BusCallback? callback}) {
    if (event == null) {
      if (callback == null) {
        return;
      } else {
        _map.removeValue(callback);
      }
    } else {
      if (callback == null) {
        _map.remove(event);
      } else {
        _map[event]?.removeValue(callback);
      }
    }
  }

  static void emit(Object event, [Object? arg]) {
    WeakList<BusCallback>? oldList = _map[event];
    if (oldList == null) return;
    oldList.clearNullValue();
    WeakList<BusCallback> ls = WeakList<BusCallback>.from(oldList);
    for (WeakReference<BusCallback> c in ls) {
      c.target?.call(event, arg);
    }
  }
}
