import 'package:entao_message/src/msg_call.dart';

void main() async {
  MsgCall.add("hello", (int n) => print("lambda1, $n "));
  MsgCall.add("hello", (int n) => print("lambda2, $n "));
  MsgCall.add("hello", hello3);
  MsgCall.add("hi", hello3);
  MsgCall.remove(hello3, msg: "hello");

  MsgCall.fire("hello", list: [9]);
  MsgCall.fire("hi", list: [8]);

  await Future.delayed(Duration(seconds: 2));
  // lambda1, 9
  // lambda2, 9
  // func3, 8
}

void hello3(int n) {
  print("func3, $n");
}
