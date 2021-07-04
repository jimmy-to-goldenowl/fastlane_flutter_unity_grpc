import 'dart:isolate';

import 'package:loveblocks/protos/server.dart';

Future createFlutterUnityServerIsolate() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(
    runFlutterUnityServerIsolateServer,
    receivePort.sendPort,
  );
  receivePort.listen((val) {
    // ignore: avoid_print
    print('From main Isolate');
  });
}

Future runFlutterUnityServerIsolateServer(SendPort val) async {
  await Server().main([]);
  val.send('Finish runServer');
}
