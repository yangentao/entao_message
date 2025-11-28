import 'weaks.dart';

final MsgCall = MessageCall();

final class MessageCall {
  final MultiMap<Object, Function> _map = MultiMap<Object, Function>();
  late final dynamic fire = _MsgCallFire<Future<List<dynamic>>>(callback: (List<dynamic> argList, Map<String, dynamic> argMap) {
    return fireMessage(argList.first, list: argList.sublist(1), map: argMap);
  });
  late final dynamic fireSync = _MsgCallFire<List<dynamic>>(callback: (List<dynamic> argList, Map<String, dynamic> argMap) {
    return fireMessageSync(argList.first, list: argList.sublist(1), map: argMap);
  });

  MessageCall();

  void dump() {
    for (var e in _map.entries) {
      print("${e.key},  ${e.value.map((a) => a)}");
    }
  }

  void clear() {
    _map.clear();
  }

  void add(Object msg, Function callback) {
    _map.add(msg, callback);
  }

  void remove(Function callback, {Object? msg}) {
    _map.removeValue(callback, key: msg);
  }

  Future<List<dynamic>> fireMessage(Object msg, {List<dynamic>? list, Map<String, dynamic>? map}) async {
    return fireMessageSync(msg, list: list, map: map);
  }

  List<dynamic> fireMessageSync(Object msg, {List<dynamic>? list, Map<String, dynamic>? map}) {
    List<Function>? ls = _map.get(msg);
    if (ls == null || ls.isEmpty) return [];
    Map<Symbol, dynamic>? nmap = map?.map((k, v) => MapEntry(Symbol(k), v));
    List<dynamic> retList = [];
    for (Function f in ls) {
      dynamic r = Function.apply(f, list, nmap);
      retList.add(r);
    }
    return retList;
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
