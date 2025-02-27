import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_speech_app/screens/home_screen.dart';
import 'package:my_speech_app/screens/home_screen_getx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Speech to Text',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // home: HomeScreenGetx(),
    );
  }
}
