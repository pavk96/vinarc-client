import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vinarc/Helper.dart';
import 'package:vinarc/pages/landing/HamburgerMenu.dart';
import 'package:vinarc/post/CategoryGet.dart';

import '../../main.dart';
import '../layout/Footer.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with RouteAware {
  @override
  void didPush() {
    print('HomePage: Called didPush');
    super.didPush();
  }

  @override
  void didPop() {
    print('HomePage: Called didPop');
    super.didPop();
  }

  @override
  void didPopNext() {
    print('HomePage: Called didPopNext');
    super.didPopNext();
  }

  @override
  void didPushNext() {
    print('HomePage: Called didPushNext');
    super.didPushNext();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
  }

  CarouselController mainImageController = CarouselController();
  CarouselController reviewController = CarouselController();

  List<Widget> tagImageList = [
    Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Image.asset('assets/img/landingpage/mainimage/mainimage1.png',
          fit: BoxFit.cover),
    ),
    Container(
      decoration: BoxDecoration(color: Colors.blue),
    ),
    Container(
      decoration: BoxDecoration(color: Colors.red),
    ),
  ];

  var heartIcon = Icon(Icons.favorite_outline);
  @override
  Widget build(BuildContext context) {
    int _current = 0;

    return Scaffold(
        backgroundColor: Color(0xFFD6D6D6),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0x00ffffff),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "VinArc",
            style: GoogleFonts.taviraj(fontSize: 25, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            IconButton(
                color: Color(0xFF3a4432),
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
                          carouselController: mainImageController,
                          items: tagImageList,
                          options: CarouselOptions(
                            height: 638,
                            viewportFraction: 1.1,
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
                                onTap: () => mainImageController
                                    .animateToPage(entry.key),
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
                          children: tagImageList.asMap().entries.map(
                            (e) {
                              return IconButton(
                                iconSize: 56,
                                icon: Image.asset(
                                    'assets/img/landingpage/mainicon/mainicon${e.key + 1}.png'),
                                onPressed: () {
                                  setState(() {
                                    mainImageController.animateToPage(e.key);
                                  });
                                },
                              );
                            },
                          ).toList()),
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
              FutureBuilder(
                  future: context.read<Product>().getAllCategory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF384230)),
                      );
                    } else {
                      List<CategoryGet> categoryData = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 33, left: 22),
                              child: Text(
                                "제품 카테고리",
                                style: TextStyle(
                                    fontFamily: 'NotoSansCJKkr',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                            height: 383,
                            padding: EdgeInsets.all(22),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //제일 위에 3개
                                      _categoryComponent(categoryData[0]),
                                      _categoryComponent(categoryData[1]),
                                      _categoryComponent(categoryData[2]),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _categoryComponent(categoryData[3]),
                                      _categoryComponent(categoryData[4]),
                                      _categoryComponent(categoryData[5]),
                                      _categoryComponent(categoryData[6]),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _categoryComponent(categoryData[7]),
                                      _categoryComponent(categoryData[8]),
                                      _categoryComponent(categoryData[9]),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }),
              //poppular product
              Padding(
                  padding: const EdgeInsets.only(top: 33, left: 22, bottom: 27),
                  child: Text(
                    "인기 제품",
                    style: TextStyle(
                        fontFamily: 'NotoSansCJKkr',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  height: 300,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 22),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              GestureDetector(
                                child: Column(children: [
                                  Container(
                                    width: 181,
                                    height: 215,
                                    child: Image.asset(
                                        'assets/img/landingpage/popularlist/popularitem1.png',
                                        fit: BoxFit.cover),
                                  )
                                ]),
                              ),
                              SizedBox(
                                width: 54,
                                height: 14,
                                child: Image.asset(
                                    'assets/img/landingpage/popularlist/band.png'),
                              ),
                              Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0x25ffffff),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          heartIcon = Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red);
                                        });
                                      },
                                      icon: heartIcon,
                                      color: Colors.white,
                                    ),
                                  ),
                                  top: 20,
                                  right: 4),
                            ],
                          ),
                          Text(
                            "Vinarc Chair",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSansCJKkr'),
                          ),
                          Text(
                            "의자, 화이트, 35x45x78cm",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansCJKkr',
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "¥ 135,000",
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              GestureDetector(
                                child: Column(children: [
                                  Container(
                                    width: 181,
                                    height: 215,
                                    child: Image.asset(
                                        'assets/img/landingpage/popularlist/popularitem1.png',
                                        fit: BoxFit.cover),
                                  )
                                ]),
                              ),
                              Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0x25ffffff),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() async {
                                          FlutterSecureStorage storage =
                                              FlutterSecureStorage();
                                          final token =
                                              await storage.read(key: "token");

                                          if (token == null) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title:
                                                          Text("로그인 하고 오세요"));
                                                });
                                            Navigator.pushNamed(
                                                context, '/login');
                                          } else {
                                            heartIcon = Icon(
                                                Icons.favorite_border,
                                                color: Colors.red);
                                          }
                                        });
                                      },
                                      icon: heartIcon,
                                      color: Colors.white,
                                    ),
                                  ),
                                  top: 20,
                                  right: 4),
                              SizedBox(
                                width: 54,
                                height: 14,
                                child: Image.asset(
                                    'assets/img/landingpage/popularlist/band.png'),
                              ),
                            ],
                          ),
                          Text(
                            "Vinarc Chair",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSansCJKkr'),
                          ),
                          Text(
                            "의자, 화이트, 35x45x78cm",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansCJKkr',
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "¥ 135,000",
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
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
              Padding(
                  padding: const EdgeInsets.only(top: 33, left: 22, bottom: 14),
                  child: Text(
                    "Review",
                    style: TextStyle(
                        fontFamily: 'NotoSansCJKkr',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                child: CarouselSlider(
                  items: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 430,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 112, 112, 112),
                              spreadRadius: 3,
                              blurRadius: 3,
                            )
                          ]),
                          child: Image.asset(
                            'assets/img/landingpage/reviewimage/reviewimage1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 430,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 238,
                                height: 50,
                                decoration:
                                    BoxDecoration(color: Color(0x30191919)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                          'assets/img/mypage/profile_img.png'),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 1, spreadRadius: 1)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    Text("Umesh appu",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                width: 238,
                                height: 170,
                                decoration:
                                    BoxDecoration(color: Color(0x30191919)),
                                padding: EdgeInsets.only(
                                    left: 12, top: 24, bottom: 20),
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "The Greatest Cozy Chair",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    _countingStar(),
                                    Text(
                                      "High in quality, Range of Products\nCustomer friendly staff and Value...",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Image.asset(
                          'assets/img/landingpage/reviewimage/reviewimage1.png'),
                    ),
                    Container(
                      child: Image.asset(
                          'assets/img/landingpage/reviewimage/reviewimage1.png'),
                    ),
                    Container(
                      child: Image.asset(
                          'assets/img/landingpage/reviewimage/reviewimage1.png'),
                    ),
                  ],
                  carouselController: reviewController,
                  options: CarouselOptions(
                    initialPage: 1,
                    viewportFraction: 0.5,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    height: 450,
                  ),
                ),
              )
            ],
            footer: Footer(
              child: FooterContent(),
              backgroundColor: Color(0xFFc3c3c3),
            )));
  }

  Widget _categoryComponent(CategoryGet categoryData) {
    return GestureDetector(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            width: 90,
            height: 90,
            child: Image.network(
                'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
                    categoryData.categoryIconUrl),
          ),
          Text(categoryData.categoryName)
        ]),
        onTap: () async {
          int arg = categoryData.categoryId;
          await context.read<Product>().getAllProduct();
          Navigator.pushNamed(context, '/productlist', arguments: arg);
        });
  }
}

Widget _countingStar() {
  int starcount = 5;
  List<Icon> starlist = [];
  for (var i = 0; i < starcount; i++) {
    starlist.add(Icon(
      Icons.star,
      color: Colors.white,
    ));
  }
  return Row(
    children: starlist,
  );
}
