import 'package:flutter/material.dart';
import 'package:visionary/screens/landing_page/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visionary',
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
