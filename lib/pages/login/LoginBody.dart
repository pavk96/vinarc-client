import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool? isAutoLogin = false;
  bool? isSaveId = false;

  String n_name = '';

  String n_gender = "";

  String n_birth = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController userIdController = TextEditingController();
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
        padding: EdgeInsets.only(
            left: SIDEPADDINGSIZE, right: SIDEPADDINGSIZE, top: TOPPADDINGSIZE),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("나만의\n빈티지 공간을\n꾸며보세요",
              style: TextStyle(
                  fontSize: H1FONTSIZE,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  height: 1.3)),
          Padding(
            padding: EdgeInsets.only(top: TOPPADDINGSIZE),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                height: TEXTFIELDTOPSIZE,
                child: TextField(
                  controller: userIdController,
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
          Padding(
            padding: EdgeInsets.only(top: 14, bottom: 23),
            child: Container(
                decoration: BoxDecoration(color: Color(0xFFF1F1F5)),
                width: double.infinity,
                height: TEXTFIELDTOPSIZE,
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
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                  Text("자동 로그인", style: TextStyle(fontSize: MAINFONTSIZE)),
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
                  Text("아이디 저장", style: TextStyle(fontSize: MAINFONTSIZE)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: TOPPADDINGSIZE),
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
                  String userId = userIdController.text;
                  String userPassword = userPasswordController.text;
                  getData(userId, userPassword);
                  print("로그인버튼이 눌려졌습니다." + userId + userPassword);
                },
                child: Text("로그인", style: TextStyle(fontSize: H3FONTSIZE)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xFF486138),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 2.42,
                      height: 44,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xFFDBDBDB), width: 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('/img/login/naver.png'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: Text('네이버'),
                            onPressed: () {
                              // _login_naver();
                              _login_naver();
                            },
                          ),
                        ],
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFDBDBDB), width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('/img/login/facebook.png')),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: Text('페이스북'),
                            onPressed: () {},
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: TOPPADDINGSIZE),
              child: RichText(
                  text: TextSpan(
                      text: "계정을 잊으셨나요? ",
                      style: TextStyle(color: Color(0xFF999999)),
                      children: [
                    TextSpan(
                        text: "ID찾기",
                        style: TextStyle(
                            color: Colors.blue, fontSize: MAINFONTSIZE)),
                    TextSpan(text: " 또는 "),
                    TextSpan(
                        text: "비밀번호 찾기",
                        style: TextStyle(
                            color: Colors.blue, fontSize: MAINFONTSIZE)),
                  ]))),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: TOPPADDINGSIZE),
              child: RichText(
                  text: TextSpan(
                      text: "아직 회원이 아니신가요? ",
                      style: TextStyle(color: Color(0xFF999999)),
                      children: [
                    WidgetSpan(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                        // goBootpayRequest(context);
                      },
                      child: Text("회원가입",
                          style: TextStyle(
                              color: Colors.black, fontSize: MAINFONTSIZE)),
                    ))
                  ])))
        ]));
  }

  getData(String userId, String userPassword) async {
    http.Response result = await http.post(
      Uri.parse('https://flyingstone.me/myapi/user/auth/login'),
      body: json.encode({"userId": userId, "userPassword": userPassword}),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
    );

    if (result.statusCode == 201) {
      print(result.headers['refresh_token']);
    } else {
      print(result.body);
      throw Exception('실패함ㅅㄱ');
    }
  }

  void _login_naver() async {
    launchUrlString('https://flyingstone.me/myapi/user/auth/naver');
  }

  // void _logout_naver() {
  //   FlutterNaverLogin.logOut();
  //   setState(() {
  //     n_name = "Logout되었습니다.";
  //     n_gender = "Logout되었습니다.";
  //     n_birth = "Logout되었습니다.";
  //   });
  // }

}
