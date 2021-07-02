import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loveblocks/services/analytics_service.dart';
import 'package:loveblocks/src/bloc/app_bloc_observer.dart';

// Init stub before runapp
Future mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp();
  await AnalyticsService.instance.init();
}

// Connect Flutter to the Firestore Emulator
// We can tell Flutter to use the emulator by modifying the settings after our widgets have been initialized
Future connectFirestoreEmulator() async {
  final String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(host: '$host:8080', sslEnabled: false);
  await FirebaseAuth.instance.useEmulator('http://$host:9099');
  await FirebaseStorage.instance.useEmulator(host: host, port: 9080);
  FirebaseFunctions.instance.useFunctionsEmulator(origin: 'http://$host:5001');
}
