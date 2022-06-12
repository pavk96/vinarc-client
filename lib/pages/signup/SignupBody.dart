import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SignUpBody extends StatefulWidget {
  SignUpBody({Key? key}) : super(key: key);

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userCheckPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userBirthController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      textInputAction: TextInputAction.next,
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
              TextButton(
                  onPressed: (() async {
                    final userId = userEmailController.text;
                    final resultJson = await _duplicate(userId);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text(jsonDecode(resultJson)['message']));
                        });
                  }),
                  child: Text("중복확인"))
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
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
                    cursorColor: Color(0xFF486138),
                    obscureText: true,
                    controller: userCheckPasswordController,
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
                    textInputAction: TextInputAction.next,
                    cursorColor: Color(0xFF486138),
                    controller: userNameController,
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
                    textInputAction: TextInputAction.next,
                    cursorColor: Color(0xFF486138),
                    controller: userBirthController,
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
                    textInputAction: TextInputAction.done,
                    cursorColor: Color(0xFF486138),
                    controller: userPhoneController,
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
                onPressed: () async {
                  String email = userEmailController.text;
                  String password = userPasswordController.text;
                  String checkpassword = userCheckPasswordController.text;
                  String name = userNameController.text;
                  String birth = userBirthController.text;
                  String phone = userPhoneController.text;
                  if (password == checkpassword) {
                    final resultJson =
                        await _signup(email, password, name, birth, phone);
                    final result = jsonDecode(resultJson);
                    showDialog(
                        context: context,
                        builder: (context) {
                          print(result);
                          return AlertDialog(
                            title: Text(result['message']),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    if (result['success']) {
                                      Navigator.of(context).pushNamed('/login');
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: Icon(Icons.favorite_rounded))
                            ],
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(title: Text("패스워드를 확인해주세요"));
                        });
                  }
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

Future<String> _duplicate(String userId) async {
  final storage = new FlutterSecureStorage();
  var result = await http.get(
    Uri.parse(
        'https://flyingstone.me/myapi/user/check-duplicate?user_id=' + userId),
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
  );
  return result.body;
}

Future<String> _signup(String email, String password, String name, String birth,
    String phone) async {
  final storage = new FlutterSecureStorage();
  final result = await http.post(
    Uri.parse('https://flyingstone.me/myapi/user/auth/signup'),
    body: json.encode({
      "userId": email,
      "userPassword": password,
      "userEmail": email,
      "userName": name,
      "userBirth": birth,
      "userPhone": phone
    }),
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    },
  );
  final resultBody = jsonDecode(result.body)['success'];
  if (resultBody == true) {
    print(result.body);
    await storage.write(key: "token", value: result.headers['refresh_token']);
    return result.body;
  } else {
    print(result.body);
    return result.body;
  }
}
