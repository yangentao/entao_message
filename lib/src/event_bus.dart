import 'weaks.dart';

typedef BusCallback = void Function(Object event, Object? arg);

class EventBus {
  EventBus._();

  static final MultiMap<Object, BusCallback> _map = MultiMap<Object, BusCallback>();

  static void on(Object event, BusCallback callback) {
    var ls = _map[event];
    if (ls == null) {
      _map[event] = callback;
    } else {
      ls.add(callback);
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
    List<BusCallback>? ls = _map.get(event);
    if (ls != null) {
      for (BusCallback c in ls) {
        c.call(event, arg);
      }
    }
  }
}
