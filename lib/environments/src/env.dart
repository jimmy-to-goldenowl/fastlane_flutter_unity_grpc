import 'build_flavor.dart';

class ENV {
  static const grpcHost = '127.0.0.1'; // 10.0.2.2
  static const grpcPort = 8081;

  static String? get buildFlavor => 'prod';
  static bool get isLocale => buildFlavor == BuildFlavor.locale.name;
}
