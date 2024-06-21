import 'package:bootcamp_app/app/yemek_bootcamp.dart';
import 'package:bootcamp_app/core/di/get_it.dart';
import 'package:bootcamp_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDI();
  runApp(YemekApp());
}
