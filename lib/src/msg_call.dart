import 'weak_multi_map.dart';

final MsgCall = MessageCall._();

final class MessageCall {
  final WeakMultiMap<Object, Function> _map = WeakMultiMap<Object, Function>();

  MessageCall._();

  void add(Object msg, Function callback) {
    _map.add(msg, callback);
  }

  void remove(Function callback, {Object? msg}) {
    if (msg != null) {
      _map.get(msg)?.removeValue(callback);
    } else {
      for (var e in _map.entries) {
        e.value.removeValue(callback);
      }
    }
  }

  void fire(Object msg, {List<dynamic>? list, Map<String, dynamic>? map, bool sync = false}) {
    WeakList<Function> ls = _map.get(msg)?.toList() ?? [];
    if(ls.isEmpty) return ;
    Map<Symbol, dynamic>? nmap = map?.map((k, v) => MapEntry(Symbol(k), v));
    for (WeakReference<Function> f in ls) {
      Function? fu = f.target;
      if (fu == null) continue;
      if (sync) {
        Function.apply(fu, list, nmap);
      } else {
        _asyncCall(() {
          Function.apply(fu, list, nmap);
        });
      }
    }
  }
}

Future<void> _asyncCall(void Function() callback) async {
  callback();
}
