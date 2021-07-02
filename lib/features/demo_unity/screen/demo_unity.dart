import 'package:flutter/material.dart';
import 'package:loveblocks/features/demo_unity/screen/unity_client_widget.dart';

class DemoUnityScreen extends StatelessWidget {
  const DemoUnityScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Protos'),
      ),
      body: UnityClientWidget(),
    );
  }
}
