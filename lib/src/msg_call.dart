import 'weaks.dart';

final MsgCall = MessageCall();

final class MessageCall {
  final WeakMultiMap<Object, Function> _map = WeakMultiMap<Object, Function>();
  late final dynamic fire = _MsgCallFire<void>(callback: (List<dynamic> argList, Map<String, dynamic> argMap) {
    fireMessage(argList.first, list: argList.sublist(1), map: argMap);
  });
  late final dynamic fireSync = _MsgCallFire<void>(callback: (List<dynamic> argList, Map<String, dynamic> argMap) {
    fireMessageSync(argList.first, list: argList.sublist(1), map: argMap);
  });

  MessageCall();

  void add(Object msg, Function callback) {
    _map.add(msg, callback);
  }

  void remove(Function callback, {Object? msg}) {
    _map.removeValue(callback, key: msg);
  }

  Future<void> fireMessage(Object msg, {List<dynamic>? list, Map<String, dynamic>? map}) async {
    fireMessageSync(msg, list: list, map: map);
  }

  void fireMessageSync(Object msg, {List<dynamic>? list, Map<String, dynamic>? map}) {
    List<Function> ls = _map.copyValues(msg);
    Map<Symbol, dynamic>? nmap = map?.map((k, v) => MapEntry(Symbol(k), v));
    for (Function f in ls) {
      Function.apply(f, list, nmap);
    }
  }
}

class _MsgCallFire<R> {
  final R Function(List<dynamic> argList, Map<String, dynamic> argMap) callback;

  _MsgCallFire({required this.callback});

  //Symbol("x") => x
  String _symbolText(Symbol sym) {
    String s = sym.toString();
    return s.substring(8, s.length - 2);
  }

  @override
  R noSuchMethod(Invocation invocation) {
    List<dynamic> argList = invocation.positionalArguments.toList();
    Map<String, dynamic> argMap = invocation.namedArguments.map((sym, v) {
      return MapEntry(_symbolText(sym), v);
    });
    return invoke(argList, argMap);
  }

  R invoke(List<dynamic> argList, Map<String, dynamic> argMap) {
    return callback(argList, argMap);
  }
}
