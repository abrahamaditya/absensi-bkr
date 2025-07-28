import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:absensi_bkr/helper/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:absensi_bkr/menu/login_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: await DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi BKR Modernland',
      home: const LoginMenu(),
      theme: themeData,
    );
  }
}
