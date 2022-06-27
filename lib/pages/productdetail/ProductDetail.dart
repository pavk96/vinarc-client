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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            return FooterView(
              flex: 5,
              children: [
                Row(children: [
                  Expanded(
                      flex: 6,
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
                          Row(
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
                          )
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
                            Row(children: [Text('색상 및 재료')]),
                            Row(children: _materialAndColor(materialAndColor))
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(22.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      //-버튼 물건 수량
                                      setState(() {
                                        productCount = productCount - 1;
                                      });
                                    },
                                    icon: Icon(Icons.remove)),
                                Text(
                                  productCount.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF384230),
                                    fontSize: 24,
                                    fontFamily: "NotoSansCJKkr",
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      //+버튼 물건 수량
                                      print(productCount);
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
                        child:
                            Divider(color: Color(0xFFD6D6D6), thickness: 1.0)),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
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
                              disableCenter: true,
                            ),
                            carouselController: relatedProductController,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
              footer: Footer(
                child: FooterContent(),
                backgroundColor: Color(0xFFc3c3c3),
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
        fit: BoxFit.fill,
      ));
    }

    return detailImageList;
  }

  List<Widget> _relatedProduct(List<ProductGet> relatedProduct) {
    List<Widget> relatedProductList = [];
    for (var element in relatedProduct) {
      relatedProductList.add(SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/windows.png',
                fit: BoxFit.contain,
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
        print(item);
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
            'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/windows.png',
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
}
