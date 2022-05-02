import 'package:flutter/material.dart';
import 'package:vinarc/pages/mypage/components/MyPageNavBtn.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RecentViewedProduct.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RefundAndExchange.dart';
import 'package:vinarc/pages/mypage/mypage_detail/TrackingOrderAndShipment.dart';
import 'package:vinarc/pages/mypage/mypage_detail/coupon.dart';

import 'mypage_detail/AddressListPage.dart';
import 'mypage_detail/Profile.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double TOPCOMPONENTHEIGHT = MediaQuery.of(context).size.height / 1.7;
    double TOPCOMPONENTINNERCONTENTHEIGHT = TOPCOMPONENTHEIGHT / 1.4;
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
                                  top: TOPCOMPONENTINNERCONTENTHEIGHT / 7)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile()));
                            },
                            child: Container(
                                width: TOPCOMPONENTINNERCONTENTHEIGHT / 3,
                                height: TOPCOMPONENTINNERCONTENTHEIGHT / 3,
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
                                child: Image(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('/img/mypage/profile_img.png'),
                                )),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: TOPCOMPONENTINNERCONTENTHEIGHT / 17),
                            child: Text("Umesh appu",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        TOPCOMPONENTINNERCONTENTHEIGHT / 16.5)),
                          ),
                          Container(
                            child: Text("example@google.com",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFb4b4b4),
                                    fontSize:
                                        TOPCOMPONENTINNERCONTENTHEIGHT / 18.5)),
                          ),
                        ],
                      )),
                ],
              )),
          Positioned(
            bottom: TOPCOMPONENTHEIGHT / 6,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Coupon()));
              },
              child: Container(
                  width: 124,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
}
