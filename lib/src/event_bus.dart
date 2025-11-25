import 'weaks.dart';

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
    if (callback != null) {
      _map.removeValue(callback, key: event);
    } else if (event != null) {
      _map.remove(event);
    }
  }

  static void emit(Object event, [Object? arg]) {
    List<BusCallback> ls = _map.copyValues(event);
    for (BusCallback c in ls) {
      c.call(event, arg);
    }
  }
}
