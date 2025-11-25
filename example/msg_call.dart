import 'package:entao_message/src/msg_call.dart';

void main() async {
  MsgCall.add("on_update", () => print("on update 1 "));
  MsgCall.add("on_update", () => print("on update 2 "));

  MsgCall.fire("on_update");
  // on update 1
  // on update 2

  MsgCall.add("on_value_int", onValueInt);

  MsgCall.fire("on_value_int", 8, 2, message: "this is a message");
  // onValueInt, 8, 2, this is a message
  MsgCall.fireSync("on_value_int", 8, 2);
  // onValueInt, 8, 2, null

  await Future.delayed(Duration(seconds: 2));
}

void onValueInt(int n, int m, {String? message}) {
  print("onValueInt, $n, $m, $message ");
}
