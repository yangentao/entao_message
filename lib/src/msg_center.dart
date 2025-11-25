import 'package:entao_message/src/weaks.dart';

abstract mixin class OnMessage {
  void onMsg(Msg msg) {}
}

final MessageCenter MsgCenter = MessageCenter();

class MessageCenter {
  MessageCenter();

  final WeakSet<OnMessage> _allSet = WeakSet<OnMessage>();

  void add(OnMessage callback) {
    _allSet.addValue(callback);
  }

  void remove(OnMessage callback) {
    _allSet.removeValue(callback);
  }

  void fireSync(Msg msg) {
    List<OnMessage> ls = _allSet.copyValues();
    for (OnMessage c in ls) {
      c.onMsg(msg);
    }
  }

  Future<void> fire(Msg msg) async {
    fireSync(msg);
  }
}

class Msg {
  final String msg;

  final int? intValue;
  final double? doubleValue;
  final String? stringValue;
  final Object? objectValue;

  Msg(this.msg, {this.intValue, this.doubleValue, this.stringValue, this.objectValue});

  @override
  String toString() {
    return "Msg{msg=$msg, intValue=$intValue, doubleValue=$doubleValue, stringValue=$stringValue, objectValue=$objectValue}";
  }
}

extension StringMsgExt on String {
  void fireSync({int? intValue, double? doubleValue, String? stringValue, Object? objectValue}) {
    var msg = Msg(this, intValue: intValue, doubleValue: doubleValue, stringValue: stringValue, objectValue: objectValue);
    MsgCenter.fireSync(msg);
  }

  void fire({int? intValue, double? doubleValue, String? stringValue, Object? objectValue}) {
    var msg = Msg(this, intValue: intValue, doubleValue: doubleValue, stringValue: stringValue, objectValue: objectValue);
    MsgCenter.fire(msg);
  }
}
