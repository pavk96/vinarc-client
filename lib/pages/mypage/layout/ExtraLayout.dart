import 'package:flutter/material.dart';
import 'package:vinarc/pages/mypage/components/ExtraAppBarLeading.dart';
import 'package:vinarc/pages/mypage/components/ProfileAndAddressAppBarLeading.dart';

class ExtraLayout extends StatelessWidget {
  final String text;

  const ExtraLayout({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: ExtraAppBarLeading(),
          elevation: 0,
          title: Text(text)),
    );
  }
}
