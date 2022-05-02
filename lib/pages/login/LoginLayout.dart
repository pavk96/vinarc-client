import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LoginBody.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double SIDEPADDINGSIZE = MediaQuery.of(context).size.width / 13.8;
    double SIDEPADDINGSIZELOGINBUTTON = MediaQuery.of(context).size.width / 20;
    double TITLESIDEPADDINGSIZE = 43;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: EdgeInsets.only(left: SIDEPADDINGSIZE),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {},
            )),
        title: Padding(
          child: Text("로그인", style: GoogleFonts.roboto(fontSize: 18)),
          padding: EdgeInsets.only(left: SIDEPADDINGSIZELOGINBUTTON),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(child: LoginBody()),
    );
  }
}
