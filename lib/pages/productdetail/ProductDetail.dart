import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vinarc/main.dart';
import 'package:vinarc/post/ProductDetailImageGet.dart';
import 'package:vinarc/post/ProductGet.dart';

import 'package:http/http.dart' as http;
import 'package:vinarc/post/ProductMaterialAndColorGet.dart';
import '../layout/Footer.dart';

class ProductDetail extends StatefulWidget {
  final String arg;
  const ProductDetail({Key? key, required this.arg}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  CarouselController controller = CarouselController();
  CarouselController relatedProductController = CarouselController();

  String isSelected = '';
  int productCount = 0;
  int _current = 0;
  List<bool> pressedButton = [false, true, true];
  int pressedButtonIndex = 0;
  bool detailImageToggle = true;
  bool isScrollDown = false;

  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isScrollDown
          ? AppBar(
              centerTitle: true,
              backgroundColor: Color(0xFF384230),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _detailButton(
                      '상세설명',
                      BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              topLeft: Radius.circular(60)),
                          color: pressedButton[0]
                              ? Color(0xFF384230)
                              : Color(0xFF1C2714)),
                      0),
                  _detailButton(
                      '구매후기',
                      BoxDecoration(
                          color: pressedButton[1]
                              ? Color(0xFF384230)
                              : Color(0xFF1C2714)),
                      1),
                  _detailButton(
                      'Q&A',
                      BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(60),
                              topRight: Radius.circular(60)),
                          color: pressedButton[2]
                              ? Color(0xFF384230)
                              : Color(0xFF1C2714)),
                      2),
                ],
              ),
            )
          : AppBar(
              leading: IconButton(
                  onPressed: () {
                    Modular.to.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF3A4432),
                  )),
              backgroundColor: Color(0x00ffffff),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF3A4432),
                  ),
                  onPressed: () {
                    Modular.to.pushNamed('/cart');
                  },
                ),
                IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Color(0xFF3A4432),
                    ),
                    onPressed: () async {
                      FlutterSecureStorage storage = FlutterSecureStorage();
                      final token = await storage.read(key: "token");
                      if (token == null) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(title: Text("로그인 하고 오세요"));
                            });
                        Modular.to.pushNamed('/login');
                      } else {
                        Modular.to.pushNamed('/mypage');
                      }
                    }),
                Padding(padding: EdgeInsets.only(right: 15))
              ],
            ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
          future: _getProductDetail(widget.arg),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xff384230)),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            }
            ProductGet product = snapshot.data['product'];
            List<ProductMaterialAndColor> materialAndColor =
                snapshot.data['materialAndColor'];
            List<ProductGet> relatedProduct = snapshot.data['relatedProduct'];
            List<ProductDetailImage> detailImage = snapshot.data['detailImage'];
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                RenderBox box =
                    key.currentContext!.findRenderObject() as RenderBox;
                Offset position = box.localToGlobal(Offset.zero);
                double y = position.dy;
                if (y < 0) {
                  //not static but container's offset top
                  //Y는 Globalkey로부터 생성된 Offset이고 이걸 기준으로 0점을 만들고 그 아래로 내려가면 네브바가 안보이게 된다.
                  //이때부터 고정시켜주면 된다.
                  setState(() {
                    isScrollDown = true;
                  });
                  return true;
                } else {
                  setState(() {
                    isScrollDown = false;
                  });
                  return false;
                }
              },
              child: FooterView(
                flex: 9,
                children: [
                  Row(children: [
                    Expanded(
                        child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        CarouselSlider(
                          items: _detailImage(detailImage),
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
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _detailImage(snapshot.data['detailImage'])
                                .asMap()
                                .entries
                                .map((entry) {
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
                                              color: Colors.white
                                                  .withOpacity(0.4)),
                                        )
                                      : Container(
                                          width: 10.0,
                                          height: 10.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xFF6B6B6B)),
                                              color: Colors.black
                                                  .withOpacity(0.0)),
                                        ));
                            }).toList(),
                          ),
                        ),
                      ],
                    )),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName,
                                  style: TextStyle(
                                      color: Color(0xFF3a4432),
                                      fontFamily: 'NotoSansCJKkr',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700)),
                              Row(
                                children: _rate(),
                              ),
                              Text(product.productPrice + '원',
                                  style: TextStyle(
                                      color: Color(0xFF3a4432),
                                      fontFamily: 'NotoSansCJKkr',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700))
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.all(22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('색상',
                                        style: TextStyle(
                                            color: Color(0xFF3a4432),
                                            fontFamily: 'NotoSansCJKkr',
                                            fontSize: 18)),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(isSelected,
                                            style: TextStyle(
                                                color: Color(0xFF3a4432),
                                                fontSize: 14,
                                                fontFamily: 'NotoSansCJKkr')))
                                  ]),
                              Row(children: _materialAndColor(materialAndColor))
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        //-버튼 물건 수량
                                        setState(() {
                                          productCount = productCount - 1;
                                        });
                                      },
                                      icon: Icon(Icons.remove)),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(
                                      productCount.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF384230),
                                        fontSize: 24,
                                        fontFamily: "NotoSansCJKkr",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        //+버튼 물건 수량
                                        setState(() {
                                          productCount = productCount + 1;
                                        });
                                      },
                                      icon: Icon(Icons.add))
                                ],
                              ),
                              SizedBox(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("총 상품금액"),
                                    Text(
                                        (int.parse(product.productPrice) *
                                                    productCount)
                                                .toString() +
                                            '원',
                                        style: GoogleFonts.roboto(
                                            color: Color(0xFF3A4432),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                  ],
                                ),
                              )
                            ]),
                      ),
                      Container(
                          width: double.infinity,
                          child: Divider(
                              color: Color(0xFFD6D6D6), thickness: 1.0)),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 342,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: Color(0xFF384230),
                                ),
                                child: Text("BUY NOW",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 2,
                                        color: Colors.white,
                                        fontFamily: 'NotoSansCJKkr',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.shopping_cart,
                                size: 26,
                                color: Color(0xFF384230),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: CarouselSlider(
                            items: _relatedProduct(relatedProduct),
                            options: CarouselOptions(
                              viewportFraction: 0.3,
                              enableInfiniteScroll: false,
                              initialPage: 1,
                              disableCenter: false,
                            ),
                            carouselController: relatedProductController,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFAFAFA),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 45),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF384230),
                                          border: Border.all(
                                              width: 0,
                                              color: Color(0xFF384230))),
                                      width: double.infinity,
                                      height: 150,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            key: key,
                                            padding: const EdgeInsets.only(
                                                top: 44, bottom: 30.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.735,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 10,
                                                    )
                                                  ]),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  _detailButton(
                                                      '상세설명',
                                                      BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          60),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          60)),
                                                          color: pressedButton[
                                                                  0]
                                                              ? Color(
                                                                  0xFF384230)
                                                              : Color(
                                                                  0xFF1C2714)),
                                                      0),
                                                  _detailButton(
                                                      '구매후기',
                                                      BoxDecoration(
                                                          color: pressedButton[
                                                                  1]
                                                              ? Color(
                                                                  0xFF384230)
                                                              : Color(
                                                                  0xFF1C2714)),
                                                      1),
                                                  _detailButton(
                                                      'Q&A',
                                                      BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          60),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          60)),
                                                          color: pressedButton[
                                                                  2]
                                                              ? Color(
                                                                  0xFF384230)
                                                              : Color(
                                                                  0xFF1C2714)),
                                                      2),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF384230),
                                              border: Border.all(
                                                  width: 0,
                                                  color: Color(0xFF384230))),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(60),
                                                  topRight:
                                                      Radius.circular(60)),
                                              child:
                                                  _content(pressedButtonIndex)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    boxShadow: detailImageToggle
                                        ? [
                                            BoxShadow(color: Colors.black),
                                            BoxShadow(
                                                offset: Offset(0, 7),
                                                spreadRadius: 70,
                                                color: Colors.white,
                                                blurRadius: 50.0)
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 160,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF384230),
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          border: Border.all(
                                              color: Color(0xFF384230),
                                              width: 0)),
                                      child: GestureDetector(
                                          child: Center(
                                              child: Text("더보기",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily: "NotoSansCJKkr",
                                                  ))),
                                          onTap: () {
                                            setState(() {
                                              detailImageToggle =
                                                  !detailImageToggle;
                                            });
                                          }),
                                    ),
                                  ),
                                ),
                                Text("상품정보"),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Color(0xFF384230),
                                              style: BorderStyle.solid,
                                              width: 1))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text("상품번호"),
                                            Text("C358905521")
                                          ],
                                        ),
                                        Row(
                                          children: [Text("소재"), Text("아크릴")],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("제조사"),
                                            Text("vinarc")
                                          ],
                                        )
                                      ]),
                                  margin: EdgeInsets.all(22),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
                footer: Footer(
                  padding: EdgeInsets.zero,
                  child: FooterContent(),
                  backgroundColor: Color(0xFFc3c3c3),
                ),
              ),
            );
          }),
    );
  }

  List<Widget> _detailImage(List<ProductDetailImage> detailImageInfoList) {
    List<Widget> detailImageList = [];
    for (var element in detailImageInfoList) {
      detailImageList.add(Image.network(
        'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
            element.productImageUrl,
        height: 680,
        fit: BoxFit.cover,
      ));
    }

    return detailImageList;
  }

  List<Widget> _relatedProduct(List<ProductGet> relatedProduct) {
    List<Widget> relatedProductList = [];
    for (var element in relatedProduct) {
      relatedProductList.add(SizedBox(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
                    element.productThumnailUrl,
                height: 130,
                fit: BoxFit.fill,
              ),
              Text(element.productName),
              Row(
                children: _rate(),
              ),
              Text(element.productPrice + '원')
            ],
          ),
        ),
      ));
    }
    return relatedProductList;
  }

  Future<dynamic> _getProductDetail(productNumber) async {
    final detailImage = await _getProductDetailImages(productNumber);
    final materialAndColor = await _getProductMaterialAndColor(productNumber);
    final product = await _getProduct(productNumber);
    final relatedProduct = await _getRelatedProduct(productNumber);
    return {
      'detailImage': detailImage,
      'materialAndColor': materialAndColor,
      'product': product,
      'relatedProduct': relatedProduct
    };
  }

  Future<List<ProductDetailImage>> _getProductDetailImages(
      String productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/detail/image?productNumber=' +
            productNumber));
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

  Future<List<ProductMaterialAndColor>> _getProductMaterialAndColor(
      String productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/material/and/color?productNumber=' +
            productNumber));
    List<ProductMaterialAndColor> productMaaterailAndColorList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productMaaterailAndColorList
            .add(ProductMaterialAndColor.fromJson(item));
      }
      return productMaaterailAndColorList;
    } else {
      throw Exception("색과 원재료를 등록해 주세요 ");
    }
  }

  Future<ProductGet> _getProduct(productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product?productNumber=' + productNumber));
    if (response.statusCode == 200) {
      ProductGet product = ProductGet.fromJson(json.decode(response.body));
      return product;
    } else {
      throw Exception("상품을 등록해주세요");
    }
  }

  Future<List<ProductGet>> _getRelatedProduct(productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/related?productNumber=' +
            productNumber));
    List<ProductGet> relatedProductList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        relatedProductList.add(ProductGet.fromJson(item));
      }
      return relatedProductList;
    } else {
      throw Exception("상품을 등록해주세요");
    }
  }

  List<Widget> _rate() {
    return [
      Icon(
        Icons.star,
        size: 16,
      ),
      Icon(
        Icons.star,
        size: 16,
      ),
      Icon(
        Icons.star,
        size: 16,
      ),
      Icon(
        Icons.star,
        size: 16,
      ),
      Icon(
        Icons.star,
        size: 16,
      ),
      Text('25', style: GoogleFonts.roboto(fontSize: 16))
    ];
  }

  List<Widget> _materialAndColor(
      List<ProductMaterialAndColor> materialAndColor) {
    List<Widget> materialAndColorWidgetList = [];
    for (var item in materialAndColor) {
      materialAndColorWidgetList.add(Container(
        width: 54,
        height: 54,
        margin: EdgeInsets.only(top: 16, right: 10),
        child: GestureDetector(
          onTap: (() {
            setState(() {
              isSelected = item.colorName;
            });
          }),
          child: Image.network(
            'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/sofa.png',
            fit: BoxFit.cover,
          ),
        ),
        decoration: BoxDecoration(
            border: isSelected == item.colorName
                ? Border.all(
                    width: 2.0,
                    color: Color(0xFF3A4432),
                    style: BorderStyle.solid)
                : Border.all(style: BorderStyle.none)),
      ));
    }
    return materialAndColorWidgetList;
  }

  Widget _detailButton(String title, BoxDecoration decoration, int index) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.7 * 0.35,
      decoration: decoration,
      child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)))),
          ),
          onPressed: (() {
            setState(() {
              for (var i = 0; i < pressedButton.length; i++) {
                if (i == index) {
                  pressedButton[index] = false;
                  pressedButtonIndex = i;
                } else {
                  pressedButton[i] = true;
                }
              }
            });
          }),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'NotoSansCJKkr',
            ),
          )),
    );
  }

  Widget _content(pressedButtonIndex) {
    List<Widget> content = [
      Image.network(
        'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/detailimage.png',
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
      Container(
          color: Colors.white,
          width: double.infinity,
          height: 500,
          padding: EdgeInsets.only(top: 22),
          child: Padding(
              padding: EdgeInsets.all(22),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Image.network(
                              'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/sofa.png',
                              width: 132,
                              fit: BoxFit.fill)),
                      SizedBox(
                        width: 230,
                        height: 120,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("1t****"),
                                    Text("2022.02.16")
                                  ],
                                ),
                                Row(
                                  children: [..._rate()],
                                ),
                                Text("아이보리/아크릴"),
                              ],
                            ),
                            Text(
                                "Products quality is best. They give the same product as they promise.")
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ))),
      Container(
          color: Colors.white,
          width: double.infinity,
          height: 500,
          padding: EdgeInsets.only(top: 22),
          child: Padding(
              padding: EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: 384,
                    height: 171,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 82,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFFAFAFA)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, color: Color(0x15000000))
                              ],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/q.png'),
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("1t********"),
                                  Text("재질은 어떻게 선택할 수 있나요?")
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 82,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFFAFAFA)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5, color: Color(0x15000000))
                              ],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/a.png'),
                              Padding(padding: EdgeInsets.only(right: 20)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Vinarc"),
                                  Text("어떻게든 선택할 수 있습니다.")
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    ];
    return content[pressedButtonIndex];
  }

  void _startScrolled() {
    //여기서는 true false만 나눠주기
  }
}
