import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:loveblocks/app.dart';
import 'package:loveblocks/environments/src/locator.dart';

Future main() async {
  await mainInit();
  runZonedGuarded<Future<void>>(() async {
    runApp(App());
  }, FirebaseCrashlytics.instance.recordError);
}
