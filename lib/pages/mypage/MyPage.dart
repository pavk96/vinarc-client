import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinarc/pages/mypage/components/ProfileAndAddressAppBarLeading.dart';

import '../layout/Footer.dart';
import 'MyPageBody.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double SIDEPADDINGSIZE = MediaQuery.of(context).size.width / 13.8;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF384230),
        leading: ProfileAndAddressAppBarLeading(),
        title: Text("My Profile",
            style: GoogleFonts.roboto(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        elevation: 0,
      ),
      body: FooterView(
          flex: 5,
          children: [
            SingleChildScrollView(child: MyPageBody()),
          ],
          footer: Footer(
            child: FooterContent(),
            backgroundColor: Color(0xFFc3c3c3),
          )),
    );
  }
}
