import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vinarc/pages/landing/HamburgerMenu.dart';

import '../layout/Footer.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
    return Scaffold(
        backgroundColor: Color(0xFFD6D6D6),
        appBar: AppBar(
          backgroundColor: Color(0x00ffffff),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "VinArc",
            style: GoogleFonts.taviraj(fontSize: 25),
          ),
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
        drawer: HamburgerMenu(),
        body: FooterView(
            flex: 5,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        CarouselSlider(
                          carouselController: controller,
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
                                onTap: () =>
                                    controller.animateToPage(entry.key),
                                child: _current != entry.key
                                    ? Container(
                                        width: 6.0,
                                        height: 6.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.4)),
                                      )
                                    : Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                      ));
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: SizedBox(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.abc),
                          Icon(Icons.abc),
                          Icon(Icons.abc),
                          Icon(Icons.abc),
                          Icon(Icons.abc),
                        ],
                      ),
                    ),
                  ))
                ],
              ),

              //detail
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 33, left: 22),
                      child: Text("Title\nStory",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25, left: 22, right: 22),
                      child: Text(
                          "We believe that financial advice plays a critical role in helping Australians live the life they want to live. At Vinarc, we strive to create superior outcomes for our clients.\n\nWe want you to know that when you choose to work with a Vinarc Adviser, you are not only choosing one of the best in Australia but also one who will always put you first."),
                    )
                  ],
                ),
              ),

              //category
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 33, left: 22),
                        child: Text(
                          "제품 카테고리",
                          style: TextStyle(
                              fontFamily: 'NotoSansCJSkr',
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      height: 383,
                      padding: EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    child: Column(children: [
                                      Icon(
                                        Icons.abc,
                                        size: 90,
                                      ),
                                      Text("협탁")
                                    ]),
                                    onTap: () {
                                      String arg = 'category';
                                      Navigator.pushNamed(
                                          context, '/productlist',
                                          arguments: arg);
                                    }),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                                Column(children: [
                                  Icon(
                                    Icons.abc,
                                    size: 90,
                                  ),
                                  Text("협탁")
                                ]),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //poppular product
              Padding(
                  padding: const EdgeInsets.only(top: 33, left: 22),
                  child: Text(
                    "인기 제품",
                    style: TextStyle(
                        fontFamily: 'NotoSansCJSkr',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.blue),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.yellow),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                    ],
                  )),
              //Review
              SizedBox(
                child: Container(),
              )
            ],
            footer: Footer(
              child: FooterContent(),
              backgroundColor: Color(0xFFc3c3c3),
            )));
  }
}
