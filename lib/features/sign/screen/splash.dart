import 'package:flutter/material.dart';
import 'package:loveblocks/src/widgets/common/indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Indicator(),
      ),
    );
  }
}
