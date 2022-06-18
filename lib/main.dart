import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:vinarc/Theme/theme.dart';
import 'package:vinarc/Helper.dart';
import 'package:vinarc/pages/landing/LandingPage.dart';
import 'package:vinarc/pages/login/LoginLayout.dart';
import 'package:vinarc/pages/mypage/mypage_detail/AddressListPage.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Cart.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RecentViewedProduct.dart';
import 'package:vinarc/pages/mypage/mypage_detail/RefundAndExchange.dart';
import 'package:vinarc/pages/mypage/mypage_detail/TrackingOrderAndShipment.dart';
import 'package:vinarc/pages/productdetail/ProductDetail.dart';
import 'package:vinarc/pages/productlist/ProductList.dart';
import 'package:vinarc/pages/signup/Signup.dart';
import 'package:vinarc/pages/mypage/MyPage.dart';
import 'package:vinarc/pages/mypage/MyPageBody.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Coupon.dart';
import 'package:vinarc/pages/mypage/mypage_detail/Profile.dart';
import 'package:vinarc/post/CategoryGet.dart';
import 'package:vinarc/post/ProductDetailImage.dart';
import 'package:vinarc/post/ProductGet.dart';
import 'package:vinarc/util/DynamicLink.dart';
import 'package:http/http.dart' as http;

void main() {
  setPathUrlStrategy();
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => LandingPage()),
        ChildRoute('/productlist',
            child: (context, args) =>
                ProductList(arg: args.queryParams['category-id']!)),
      ];
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class Product extends ChangeNotifier {
  List<ProductGet> allProduct = [];
  List<CategoryGet> allCategory = [];
  getAllProduct() async {
    final response =
        await http.get(Uri.parse('https://flyingstone.me/myapi/product'));
    List<ProductGet> productList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productList.add(ProductGet.fromJson(item));
      }
      allProduct = productList;
      notifyListeners();
    } else {
      throw Exception("아직 Product가 등록되지 않았습니다.");
    }
  }

  Future<List<CategoryGet>> getAllCategory() async {
    final response = await http
        .get(Uri.parse('https://flyingstone.me/myapi/product/category'));
    List<CategoryGet> categoryList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        categoryList.add(CategoryGet.fromJson(item));
      }
      return categoryList;
    } else {
      throw Exception("아직 Category가 등록되지 않았습니다.");
    }
  }

  Future<ProductGet> getOneProduct(int productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product?productNumber=' +
            productNumber.toString()));
    if (response.statusCode == 200) {
      ProductGet productItem = ProductGet.fromJson(json.decode(response.body));
      return productItem;
    } else {
      throw Exception("해당 Product는 없습니다.");
    }
  }

  Future<List<ProductDetailImage>> getProductDetailImages(
      int productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product?productNumber=' +
            productNumber.toString()));
    List<ProductDetailImage> productDetailImageList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productDetailImageList.add(ProductDetailImage.fromJson(item));
      }
      return productDetailImageList;
    } else {
      throw Exception("이미지를 등록해 주세요.");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => Product(),
        child: MaterialApp.router(
          title: 'Vinarc',
          theme: theme,
          debugShowCheckedModeBanner: false,
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
        )
        // MaterialApp(
        //   initialRoute: '/',
        //   title: 'Vinarc',
        //   theme: theme,
        //   debugShowCheckedModeBanner: false,
        //   home: LandingPage(),
        //   navigatorObservers: [routeObserver],
        //   routes: {
        //     '/login': (context) => LoginLayout(),
        //     '/signup': (context) => Signup(),
        //     '/mypage': (context) => MyPage(),
        //     '/profile': (context) => Profile(),
        //     '/cart': (context) => Cart(),
        //     '/coupon': (context) => Coupon(),
        //     '/tracking': (context) => TrackingOrderAndShipment(),
        //     '/address': (context) => AddressListPage(),
        //     '/refund': (context) => RefundAndExchange(),
        //     '/recentproduct': (context) => RecentViewedProduct(),
        //     '/productlist': (context) => ProductList(),
        //     '/productdetail': (context) => ProductDetail(),
        //   },
        // ),
        );
  }
}
