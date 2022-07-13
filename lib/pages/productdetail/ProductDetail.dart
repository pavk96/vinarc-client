import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vinarc/main.dart';
import 'package:vinarc/post/ProductDetailGet.dart';
import 'package:vinarc/post/ProductDetailImageGet.dart';
import 'package:vinarc/post/ProductGet.dart';

import 'package:http/http.dart' as http;
import 'package:vinarc/post/ProductMaterialAndColorGet.dart';
import 'package:vinarc/post/ProductQnaGet.dart';
import 'package:vinarc/post/ProductReviewGet.dart';
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
              automaticallyImplyLeading: false,
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
          future: _getProductInfo(widget.arg),
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
            ProductDetailGet productDetail = snapshot.data['productDetail'];
            List<ProductReviewGet> productReview =
                snapshot.data['productReview'];
            List<ProductQnaGet> productQna = snapshot.data['productQna'];
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
                if (y < 10) {
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
                              Text(
                                  product.productPrice.substring(
                                          0, product.productPrice.length - 3) +
                                      ',' +
                                      product.productPrice.substring(
                                          product.productPrice.length - 3) +
                                      '원',
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
                              Expanded(
                                flex: 1,
                                child: Row(
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
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("총 상품금액"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                    ),
                                    Text(
                                        _setPriceString(
                                            (int.parse(product.productPrice) *
                                                    productCount)
                                                .toString()),
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
                              onTap: () {
                                //TODO 로그인 확인, Bootpay연결
                              },
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
                              onPressed: () {
                                //TODO 장바구니에 넣고 장바구니에 넣었습니다.알림
                              },
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
                                              child: _content(
                                                  pressedButtonIndex,
                                                  productReview,
                                                  productQna,
                                                  productDetail)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
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
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 3),
                                                blurRadius: 5)
                                          ],
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
                                Container(
                                  padding: EdgeInsets.only(top: 12, left: 22),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "상품정보",
                                        style: TextStyle(
                                            fontFamily: 'NotoSansCJKkr',
                                            fontSize: 14,
                                            color: Color(0xFF384230)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                    color: Color(0xFF384230),
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _detailRow(
                                            '상품번호',
                                            productDetail.productNumber
                                                .toString()),
                                        _detailRow('주재료',
                                            productDetail.productMainMaterial),
                                        _detailRow('소재',
                                            productDetail.productComponents),
                                        _detailRow(
                                            '제조국',
                                            productDetail
                                                .productCountryOfManufactor),
                                        _detailRow('제조사',
                                            productDetail.productManufactor),
                                        _detailRow('제조자',
                                            productDetail.productResponsible),
                                        _detailRow(
                                            '제조자 연락처',
                                            productDetail
                                                .productResponsiblePhone),
                                        _detailRow(
                                            '예상 배송기간',
                                            productDetail
                                                .estimatedDeliveryDate),
                                        _detailRow('제품 보증기간',
                                            productDetail.productAssurance)
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
              Text(_setPriceString(element.productPrice))
            ],
          ),
        ),
      ));
    }
    return relatedProductList;
  }

  Future<dynamic> _getProductInfo(productNumber) async {
    final detailImage = await _getProductDetailImages(productNumber);

    final materialAndColor = await _getProductMaterialAndColor(productNumber);
    final product = await _getProduct(productNumber);
    final relatedProduct = await _getRelatedProduct(productNumber);
    final productDetail = await _getProductDetail(productNumber);
    final productReview = await _getProductReview(productNumber);
    final productQna = await _getProductQna(productNumber);
    return {
      'detailImage': detailImage,
      'materialAndColor': materialAndColor,
      'product': product,
      'productDetail': productDetail,
      'relatedProduct': relatedProduct,
      'productReview': productReview,
      'productQna': productQna
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

  Future<ProductDetailGet> _getProductDetail(productNumber) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/detail?productNumber=' +
            productNumber));
    if (response.statusCode == 200) {
      ProductDetailGet productDetail =
          ProductDetailGet.fromJson(json.decode(response.body));
      return productDetail;
    } else {
      throw Exception("상품 필수요건이 등록되지 않았습니다.");
    }
  }

  Future<List<ProductReviewGet>> _getProductReview(productNumber) async {
    //사용자 정보가 확실히 있지만 보낼 때는 상품번호만 보내기 때문에 크게 상관없다
    final response = await http.get(Uri.parse(
        "https://flyingstone.me/myapi/product/review?productNumber=" +
            productNumber));
    List<ProductReviewGet> productReviewList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productReviewList.add(ProductReviewGet.fromJson(item));
      }
      return productReviewList;
    } else {
      throw Exception("리뷰가 없습니다.");
    }
  }

  Future<List<ProductQnaGet>> _getProductQna(productNumber) async {
    //사용자 정보가 확실히 있지만 보낼 때는 상품번호만 보내기 때문에 크게 상관없다
    final response = await http.get(Uri.parse(
        "https://flyingstone.me/myapi/product/qna?productNumber=" +
            productNumber));
    List<ProductQnaGet> productQnaList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productQnaList.add(ProductQnaGet.fromJson(item));
      }
      return productQnaList;
    } else {
      throw Exception("리뷰가 없습니다.");
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
            Scrollable.ensureVisible(key.currentContext!,
                duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
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

  Widget _content(pressedButtonIndex, List<ProductReviewGet> productReview,
      List<ProductQnaGet> productQna, ProductDetailGet productDetail) {
    List<Widget> content = [
      Image.network(
        'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
            productDetail.productDetailImageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
      Container(
          color: Colors.white,
          width: double.infinity,
          height: 500,
          padding: EdgeInsets.only(top: 22),
          child: ListView.builder(
            itemCount: productReview.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                  'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
                                      productReview[index].reviewImageUrl,
                                  width: 132,
                                  fit: BoxFit.fill)),
                          SizedBox(
                            width: 230,
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(productReview[index]
                                        .userId
                                        .replaceRange(2, null, '***')),
                                    Text(productReview[index].reviewDate)
                                  ],
                                ),
                                Row(
                                  children: [..._rate()],
                                ),
                                Text(
                                    "아이보리/아크릴 "), //TODO 나중에 Ordered Product에서 무슨 색이랑 그런 거 적어야함

                                Text(productReview[index].reviewContents)
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ));
            },
          )),
      Container(
          color: Colors.white,
          width: double.infinity,
          height: 500,
          padding: EdgeInsets.only(top: 22),
          child: ListView.builder(
              itemCount: productQna.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
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
                                padding: EdgeInsets.only(left: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFFAFAFA)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Color(0x15000000))
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.network(
                                        'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/q.png'),
                                    Padding(
                                        padding: EdgeInsets.only(right: 20)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(productQna[index]
                                            .userId
                                            .replaceRange(2, null, '***')),
                                        Text(productQna[index].qnaContents)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 50),
                                height: 82,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFFAFAFA)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Color(0x15000000))
                                    ],
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.network(
                                        'https://vinarc.s3.ap-northeast-2.amazonaws.com/new/a.png'),
                                    Padding(
                                        padding: EdgeInsets.only(right: 20)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Vinarc"),
                                        Text(productQna[index].qnaAnswer)
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ));
              })),
    ];
    return content[pressedButtonIndex];
  }

  Widget _detailRow(String rowName, String content) {
    return Padding(
      padding: const EdgeInsets.only(right: 22.0, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(rowName,
              style: TextStyle(
                  fontFamily: 'NotoSansCJKkr',
                  fontSize: 11,
                  color: Color(0xFF384230))),
          Text(content,
              style: TextStyle(
                  fontFamily: 'NotoSansCJKkr',
                  fontSize: 11,
                  color: Color(0xFF676F61)))
        ],
      ),
    );
  }

  String _setPriceString(String productPrice) {
    if (productPrice.length < 3) {
      return productPrice + ' 원';
    }
    return productPrice.substring(0, productPrice.length - 3) +
        ',' +
        productPrice.substring(productPrice.length - 3) +
        '원';
  }
}
