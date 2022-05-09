import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';

import 'SignupBody.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

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
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        title: Padding(
          child: Text("회원가입", style: GoogleFonts.roboto(fontSize: 18)),
          padding: EdgeInsets.only(left: SIDEPADDINGSIZELOGINBUTTON),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(child: SignUpBody()),
    );
  }
}
