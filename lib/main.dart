import 'package:flutter/material.dart';
import 'package:vinarc/Theme/theme.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinarc',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const LoginLayout(),
    );
  }
}
