import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinarc/pages/mypage/components/ProfileAndAddressAppBarLeading.dart';

class ProfileAndAddressLayout extends StatelessWidget {
  final String text;

  final Widget bodyWidget;

  const ProfileAndAddressLayout(
      {Key? key, required this.text, required this.bodyWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double APPBARBORDERRADIUS = MediaQuery.of(context).size.width / 7;
    double APPBARHEIGHT = MediaQuery.of(context).size.height / 11.85;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color(0xFF384230),
          leading: ProfileAndAddressAppBarLeading(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(APPBARBORDERRADIUS),
                bottomRight: Radius.circular(APPBARBORDERRADIUS)),
          ),
          title: Text(text,
              style: GoogleFonts.roboto(
                fontSize: 24,
                color: Colors.white,
              )),
        ),
      ),
      body: FooterView(
        children: [bodyWidget],
        footer: Footer(
          child: SizedBox(
              width: double.infinity,
              height: 182,
              child: Row(
                children: [],
              )),
          backgroundColor: Color(0xFFc3c3c3),
        ),
      ),
    );
  }
}
