import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static Future<bool?> show(String? message) {
    return Fluttertoast.showToast(msg: message ?? '');
  }
}
