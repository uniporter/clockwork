import 'dart:io';

main() async {
    final fp = File("lol");
    await fp.readAsString();
}