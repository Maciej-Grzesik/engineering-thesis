import 'package:flutter/material.dart';
import 'package:mobile_app/pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello :3',
      theme: ThemeData(
        
      ),
      home: const WelcomePage(title: 'Home',),
    );
  }
}