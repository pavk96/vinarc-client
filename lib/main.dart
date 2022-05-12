import 'package:flutter/material.dart';
import 'package:vinarc/Theme/theme.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';
import 'package:vinarc/pages/signup/Signup.dart';
import 'package:vinarc/pages/mypage/MyPage.dart';
import 'package:vinarc/pages/mypage/MyPageBody.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Coupon.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'Vinarc',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const Signup(),
      routes: {
        '/mypage': (context) => MyPage(),
        '/profile': (context) => Profile(),
        '/coupon': (context) => Coupon(),
        '/login': (context) => LoginLayout(),
        '/signup': (context) => Signup(),
      },
    );
  }
}
