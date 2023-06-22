import 'package:flutter/material.dart';
import 'package:frontend/pateint/create_demand.dart';
import 'package:frontend/pateint/list_medical_folder.dart';
import 'package:frontend/upload_image.dart';
import 'globals.dart';
import 'nurse/list_my_history.dart';
import 'user/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getPrefs();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HomeCare',
        theme: ThemeData(
          // scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blueGrey,
          appBarTheme: AppBarTheme(
            color: Colors.black87,
          ),
        ),
        home: Login());
  }
}
