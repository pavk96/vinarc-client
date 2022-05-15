import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vinarc/pages/mypage/components/MyPageNavBtn.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RecentViewedProduct.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RefundAndExchange.dart';
import 'package:vinarc/pages/mypage/mypage_detail/TrackingOrderAndShipment.dart';
import 'package:vinarc/pages/mypage/mypage_detail/coupon.dart';
import 'package:vinarc/post/UserProfilePost.dart';
import 'package:http/http.dart' as http;

import 'mypage_detail/AddressListPage.dart';
import 'mypage_detail/Profile.dart';

class MyPageBody extends StatelessWidget {
  MyPageBody({Key? key}) : super(key: key);
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    double TOPCOMPONENTHEIGHT = MediaQuery.of(context).size.height / 1.7;
    double TOPCOMPONENTINNERCONTENTHEIGHT = TOPCOMPONENTHEIGHT / 1.4;
    return FutureBuilder<UserProfilePost>(
        future: _getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF384230)),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            return Column(
              children: [
                Stack(alignment: Alignment.center, children: [
                  Container(
                      height: TOPCOMPONENTHEIGHT,
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: TOPCOMPONENTINNERCONTENTHEIGHT,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        offset: Offset(0, -3),
                                        spreadRadius: 6,
                                        color: Color.fromARGB(20, 0, 0, 0))
                                  ],
                                  color: Color(0xFF384230),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(134),
                                      bottomRight: Radius.circular(134))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: TOPCOMPONENTINNERCONTENTHEIGHT /
                                              7)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/profile',
                                        // MaterialPageRoute(
                                        //     builder: (context) => Profile())
                                      );
                                    },
                                    child: Container(
                                        width:
                                            TOPCOMPONENTINNERCONTENTHEIGHT / 3,
                                        height:
                                            TOPCOMPONENTINNERCONTENTHEIGHT / 3,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    TOPCOMPONENTINNERCONTENTHEIGHT /
                                                        2)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0x51000000),
                                                  offset: Offset(0, -1),
                                                  spreadRadius: -8,
                                                  blurRadius: 6)
                                            ]),
                                        child: Image.asset(
                                          'assets/img/mypage/profile_img.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: TOPCOMPONENTINNERCONTENTHEIGHT /
                                            17),
                                    child: Text(snapshot.data.userName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                TOPCOMPONENTINNERCONTENTHEIGHT /
                                                    16.5)),
                                  ),
                                  Container(
                                    child: Text(snapshot.data.userEmail,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFFb4b4b4),
                                            fontSize:
                                                TOPCOMPONENTINNERCONTENTHEIGHT /
                                                    18.5)),
                                  ),
                                ],
                              )),
                        ],
                      )),
                  Positioned(
                    bottom: TOPCOMPONENTHEIGHT / 6,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/coupon');
                      },
                      child: Container(
                          width: 124,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(30, 0, 0, 0),
                                    offset: Offset(0, 4),
                                    spreadRadius: 3,
                                    blurRadius: 6)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("쿠폰",
                                  style: TextStyle(
                                      fontFamily: 'NotoSansCJKkr',
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF808879))),
                              Padding(padding: EdgeInsets.all(10)),
                              Text("13",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'NotoSansCJKkr',
                                      color: Color(0xFFC89DA9),
                                      fontWeight: FontWeight.w900))
                            ],
                          )),
                    ),
                  ),
                ]),
                Container(
                    child: Column(
                  children: [
                    MyPageNavBtn(
                      text: "주문/배송 조회",
                      destinationPage: TrackingOrderAndShipment(),
                    ),
                    MyPageNavBtn(
                      text: "배송주소록",
                      destinationPage: AddressListPage(),
                    ),
                    MyPageNavBtn(
                      text: "교환 및 환불",
                      destinationPage: RefundAndExchange(),
                    ),
                    MyPageNavBtn(
                      text: "쿠폰",
                      destinationPage: Coupon(),
                    ),
                    MyPageNavBtn(
                      text: "최근 본 상품",
                      destinationPage: RecentViewedProduct(),
                    ),
                  ],
                ))
              ],
            );
          }
        });
  }

  Future<UserProfilePost> _getUserProfile() async {
    final token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'authorization': token ?? ''
    };
    final response = await http.get(
        Uri.parse('https://flyingstone.me/myapi/user/profile'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return UserProfilePost.fromJson(json.decode(response.body));
    } else {
      throw Exception("asdfasdf");
    }

    // return ;
  }
}
