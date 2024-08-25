import 'package:emanagement_mobile/Presentation/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //const add/remove
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}
