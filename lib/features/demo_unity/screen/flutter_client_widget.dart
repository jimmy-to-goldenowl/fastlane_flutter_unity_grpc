import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:loveblocks/protos/service.dart';
import 'package:loveblocks_proto/loveblocks_proto.dart';

class FlutterClientWidget extends StatefulWidget {
  const FlutterClientWidget({Key? key}) : super(key: key);
  @override
  _FlutterClientWidgetState createState() => _FlutterClientWidgetState();
}

class _FlutterClientWidgetState extends State<FlutterClientWidget> {
  final flutterClient = FlutterClientService();
  Logger log = Logger();
  final Set<Message> messages = <Message>{};

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              child: _buildMessages(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  final date = DateTime.now();
                  flutterClient
                      .sendMessage('Chat at ${date.minute}:${date.second}');
                },
                child: Text('Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<Message> _buildMessages() {
    return StreamBuilder<Message>(
      stream: flutterClient.recieveMessage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data != null) {
          messages.add(snapshot.data!);
        }

        return ListView(
          children: messages
              .map((msg) =>
                  ListTile(title: Text(msg.id), subtitle: Text(msg.content)))
              .toList(),
        );
      },
    );
  }
}
