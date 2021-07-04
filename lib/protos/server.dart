import 'dart:async';

import 'package:grpc/grpc.dart' as grpc;
import 'package:loveblocks/environments/src/env.dart';
import 'package:loveblocks_proto/loveblocks_proto.dart';

class FlutterIsolateServer extends FlutterUnityServiceBase {
  Set<Connect> users = {};
  StreamController<Message> controller = StreamController.broadcast();

  void despose() {
    controller.close();
  }

  @override
  Future<Close> sendMessage(grpc.ServiceCall call, Message request) async {
    // ignore: avoid_print
    print('Chat ${request.content}...');
    controller.sink.add(request);
    return Close();
  }

  @override
  Stream<Message> createStream(grpc.ServiceCall call, Connect request) {
    // ignore: avoid_print
    print('Connect ${request.id}...');
    users.add(request);
    return controller.stream;
  }
}

class Server {
  Future<void> main(List<String> args) async {
    final server = grpc.Server([FlutterIsolateServer()]);
    await server.serve(port: ENV.grpcPort);
    // ignore: avoid_print
    print('Server listening on port ${server.port}...');
  }
}
