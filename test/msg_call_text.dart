import 'package:entao_message/entao_message.dart';
import 'package:test/test.dart';

void main() {
  test('Simple', () {
    MessageCall mc = MessageCall();
    mc.add("online", () => print("online 1"));
    mc.add("online", () => print("online 2"));
    mc.fire("online");
    // online 1
    // online 2
  });

  test('return value', () async {
    MessageCall mc = MessageCall();
    mc.add("online", () => 1);
    mc.add("online", () => 2);

    List<dynamic> r1 = mc.fireSync("online");
    print(r1);
    // [1, 2]
    List<dynamic> r2 = await mc.fire("online");
    print(r2);
    // [1, 2]
  });

  test('with arguments', () async {
    MessageCall mc = MessageCall();
    mc.add("online", (String name, {String? message}) => print("$name is online: $message"));
    mc.add("online", (String name, {String? message}) => print("Again. $name is online: $message"));

    await mc.fire("online", "Tom", message: "Hello Jerry.");
    // Tom is online: Hello every one.
    // Again. Tom is online: Hello Jerry.
  });
}
