import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityClientWidget extends StatefulWidget {
  const UnityClientWidget({Key? key}) : super(key: key);

  @override
  _UnityClientWidgetState createState() => _UnityClientWidgetState();
}

class _UnityClientWidgetState extends State<UnityClientWidget> {
  // ignore: unused_field
  late UnityWidgetController _unityWidgetController;
  void onUnityCreated(UnityWidgetController controller) {
    this._unityWidgetController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return UnityWidget(
      onUnityCreated: onUnityCreated,
    );
  }
}
