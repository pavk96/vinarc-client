import 'package:bootpay/bootpay.dart';

import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';

import 'SignupBody.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Payload payload = Payload();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _payload.app
    payload.webApplicationId = '627734062701800023f6b102';
    payload.androidApplicationId = '627734062701800023f6b103';
    payload.iosApplicationId = '627734062701800023f6b104';

    payload.pg = 'danal';
    payload.method = 'auth';
    payload.name = '본인인증';
    payload.price = 0; //본인인증의 경우 가격 0
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    payload.params = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    };
    // User user = User();
    // user.username = "박규정";
    // user.email = "rbwjd96@gmail.com";
    // user.area = "대구";
    // user.phone = "010-4184-9159";
    // user.addr = '대구광역시 동구 동부로 28길 38-1';

    // Extra extra = Extra();
    // extra.appScheme = 'vinarc';
    //extra.carrier = "SKT"; //본인인증 시 고정할 통신사명, SKT,KT,LGT 중 1개만 가능
    //extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    // payload.user = user;
    // payload.extra = extra;
  }

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
        body: Container(
          child: Center(
              child: TextButton(
            onPressed: () => Bootpay().request(
              context: context,
              payload: payload,
              onCancel: (String data) {
                print('------- onCancel: $data');
              },
              onError: (String data) {
                print('------- onCancel: $data');
              },
              onClose: () {
                print('------- onClose');
              },
              onReady: (String data) {
                print('------- onReady: $data');
              },
              onConfirm: (String data) {
                print('------- onConfirm: $data');
                return true;
              },
              onDone: (String data) {
                print('------- onDone: $data');
              },
            ),
            child: Text('부트페이 결제테스트'),
          )),
        ));
  }
}
