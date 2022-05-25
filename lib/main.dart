import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vinarc/Theme/theme.dart';
import 'package:vinarc/pages/landing/LandingPage.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';
import 'package:vinarc/pages/mypage/mypage_detail/AddressListPage.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Cart.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RecentViewedProduct.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RefundAndExchange.dart';
import 'package:vinarc/pages/mypage/mypage_detail/TrackingOrderAndShipment.dart';
import 'package:vinarc/pages/productlist/ProductList.dart';
import 'package:vinarc/pages/signup/Signup.dart';
import 'package:vinarc/pages/mypage/MyPage.dart';
import 'package:vinarc/pages/mypage/MyPageBody.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Coupon.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Profile.dart';
import 'package:vinarc/util/DynamicLink.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'Vinarc',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      routes: {
        '/login': (context) => LoginLayout(),
        '/signup': (context) => Signup(),
        '/mypage': (context) => MyPage(),
        '/profile': (context) => Profile(),
        '/cart': (context) => Cart(),
        '/coupon': (context) => Coupon(),
        '/tracking': (context) => TrackingOrderAndShipment(),
        '/address': (context) => AddressListPage(),
        '/refund': (context) => RefundAndExchange(),
        '/recentproduct': (context) => RecentViewedProduct(),
        '/productlist': (context) => ProductList(),
      },
    );
  }
}
