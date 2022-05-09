import 'package:flutter/material.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userEmailController = TextEditingController();
    TextEditingController userPasswordController = TextEditingController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double SIDEPADDINGSIZE = width / 13.8;
    double TOPPADDINGSIZE = height / 22;
    double TEXTFIELDTOPSIZE = height / 11.5;
    double LOGINBUTTONHEIGHT = height / 13.8;
    double MAINFONTSIZE = width * 0.038;
    double H3FONTSIZE = width * 0.041;
    double H1FONTSIZE = width * 0.08;
    return Container(
        width: width,
        padding: EdgeInsets.only(
            left: SIDEPADDINGSIZE, right: SIDEPADDINGSIZE, top: TOPPADDINGSIZE),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("저희 브랜드의\n동료가\n되시렵니까?",
              style: TextStyle(
                  fontSize: H1FONTSIZE,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  height: 1.3)),
          Padding(
            padding: EdgeInsets.only(top: TOPPADDINGSIZE),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                    width: width / 2,
                    child: TextField(
                      controller: userEmailController,
                      cursorColor: Color(0xFF486138),
                      decoration: InputDecoration(
                          hintText: "아이디를 입력해주세요",
                          hintStyle: TextStyle(
                              color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                          border: InputBorder.none,
                          isCollapsed: false,
                          contentPadding: EdgeInsets.all(24)),
                    )),
              ),
              TextButton(onPressed: (() {}), child: Text("중복확인"))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "비밀번호를 입력해주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "비밀번호를 확인해주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "이름을 입력해 주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "생년월일을 입력해주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "이메일을 입력해주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                child: TextField(
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userPasswordController,
                    decoration: InputDecoration(
                        hintText: "연락처를 입력해주세요",
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: MAINFONTSIZE),
                        border: InputBorder.none,
                        isCollapsed: false,
                        contentPadding: EdgeInsets.all(24)))),
          ),
          Container(
            margin:
                EdgeInsets.only(top: TOPPADDINGSIZE, bottom: TOPPADDINGSIZE),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color(0x40486138),
                  blurRadius: 30,
                  offset: Offset(0, 18))
            ]),
            height: LOGINBUTTONHEIGHT,
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  String email = userEmailController.text;
                  String password = userPasswordController.text;
                  print("로그인버튼이 눌려졌습니다." + email + password);
                },
                child: Text("회원가입", style: TextStyle(fontSize: H3FONTSIZE)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xFF486138),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero))),
          ),
        ]));
  }
}
