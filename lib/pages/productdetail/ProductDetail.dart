import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/Footer.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  CarouselController controller = CarouselController();

  List<Widget> tagImageList = [
    Container(
      decoration: BoxDecoration(color: Colors.red),
    ),
    Container(
      decoration: BoxDecoration(color: Colors.blue),
    ),
    Container(
      decoration: BoxDecoration(color: Colors.red),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    String? arg =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'category';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Color(0x00ffffff),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                FlutterSecureStorage storage = FlutterSecureStorage();
                final token = await storage.read(key: "token");
                if (token == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(title: Text("로그인 하고 오세요"));
                      });
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/mypage');
                }
              }),
          Padding(padding: EdgeInsets.only(right: 15))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FooterView(
        flex: 5,
        children: [
          Row(children: [
            Expanded(
                flex: 6,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    CarouselSlider(
                      items: tagImageList,
                      options: CarouselOptions(
                        height: 638,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: tagImageList.asMap().entries.map((entry) {
                        return GestureDetector(
                            onTap: () => controller.animateToPage(entry.key),
                            child: _current != entry.key
                                ? Container(
                                    width: 6.0,
                                    height: 6.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.4)),
                                  )
                                : Container(
                                    width: 10.0,
                                    height: 10.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.9)),
                                  ));
                      }).toList(),
                    )
                  ],
                )),
          ]),
        ],
        footer: Footer(
          child: FooterContent(),
          backgroundColor: Color(0xFFc3c3c3),
        ),
      ),
    );
  }
}
