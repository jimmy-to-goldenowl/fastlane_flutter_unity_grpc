import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityScreen extends StatefulWidget {
  const UnityScreen({Key? key}) : super(key: key);

  @override
  _UnityScreenState createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  // ignore: unused_field
  late UnityWidgetController _unityWidgetController;

  void onUnityCreated(UnityWidgetController controller) {
    this._unityWidgetController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: UnityWidget(onUnityCreated: onUnityCreated),
    );
  }
}
