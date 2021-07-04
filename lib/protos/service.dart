import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';
import 'package:loveblocks/environments/src/env.dart';
import 'package:loveblocks_proto/loveblocks_proto.dart';

class FlutterClientService {
  String platform = 'flutter';
  static FlutterUnityClient? client;
  final Logger log = Logger();

  FlutterClientService() {
    final channel = ClientChannel(ENV.grpcHost,
        port: ENV.grpcPort, options: ChannelOptions(credentials: ChannelCredentials.insecure()));
    client = FlutterUnityClient(channel, options: CallOptions(timeout: Duration(seconds: 30)));
    log.i('Connect to Isolate GRPC Server');
  }

  Future sendMessage(String body) async {
    final message = Message(id: platform, content: body);
    client?.sendMessage(message);
  }

  Stream<Message> recieveMessage() async* {
    final connect = Connect(id: platform, active: true);
    final ResponseStream<Message>? stream = client?.createStream(connect);
    if (stream != null) {
      await for (final e in stream) {
        yield e;
      }
    }
  }
}
