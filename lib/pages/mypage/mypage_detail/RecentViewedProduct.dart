import 'package:flutter/material.dart';
import 'package:vinarc/pages/mypage/layout/ExtraLayout.dart';

class RecentViewedProduct extends StatelessWidget {
  const RecentViewedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtraLayout(
      text: "최근 본 상품",
    );
  }
}
