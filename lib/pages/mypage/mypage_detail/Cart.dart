import 'package:flutter/material.dart';
import 'package:vinarc/pages/mypage/layout/ExtraLayout.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtraLayout(
      text: "장바구니",
      child: Container(),
    );
  }
}
