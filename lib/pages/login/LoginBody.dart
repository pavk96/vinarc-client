import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool? isAutoLogin = false;
  bool? isSaveId = false;
  @override
  Widget build(BuildContext context) {
    double SIDEPADDINGSIZE = MediaQuery.of(context).size.width / 13.8;
    double TOPPADDINGSIZE = MediaQuery.of(context).size.height / 16;
    return Container(
        padding: EdgeInsets.only(
            left: SIDEPADDINGSIZE, right: SIDEPADDINGSIZE, top: TOPPADDINGSIZE),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("나만의\n빈티지 공간을\n꾸며보세요",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  height: 1.3)),
          Padding(
            padding: EdgeInsets.only(top: TOPPADDINGSIZE),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                height: 64,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "이메일을 입력해주세요",
                      hintStyle: TextStyle(color: Color(0xFF999999)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(21)),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14, bottom: 23),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                height: 64,
                child: TextField(
                    decoration: InputDecoration(
                        hintText: "비밀번호를 입력해주세요",
                        hintStyle: TextStyle(color: Color(0xFF999999)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(21)))),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Color(0xFFDBDBDB),
                    ),
                    child: Checkbox(
                      value: isAutoLogin,
                      activeColor: Color(0xFF486138),
                      checkColor: Colors.white,
                      shape: CircleBorder(),
                      onChanged: (bool? newValue) {
                        setState(() {
                          print(newValue);
                          print(isAutoLogin);
                          isAutoLogin = newValue!;
                        });
                      },
                    ),
                  ),
                  Text("자동 로그인"),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Color(0xFFDBDBDB),
                    ),
                    child: Checkbox(
                      value: isSaveId,
                      activeColor: Color(0xFF486138),
                      checkColor: Colors.white,
                      shape: CircleBorder(),
                      onChanged: (bool? newValue) {
                        setState(() {
                          isSaveId = newValue!;
                        });
                      },
                    ),
                  ),
                  Text("아이디 저장"),
                ],
              ),
            ),
          ),
          TextButton(
              onPressed: () {},
              child: Text("로그인"),
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color(0xFF486138),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero)))
        ]));
  }
}
