import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vinarc/main.dart';
import 'package:vinarc/post/CategoryGet.dart';

import '../../post/ProductGet.dart';

class ProductList extends StatefulWidget {
  final String arg;
  const ProductList({Key? key, required this.arg}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var heartIcon = Icon(Icons.favorite_border_outlined);
  @override
  Widget build(BuildContext context) {
    //추천이 많은 순서가 추천순
    //인기가 어떻게 많아야 인기순?

    return FutureBuilder(
        future: _getCategoryDetail(widget.arg),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Modular.to.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  backgroundColor: Color(0x00ffffff),
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    '',
                    style: GoogleFonts.taviraj(fontSize: 25),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Modular.to.pushNamed('/cart');
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
                            Modular.to.pushNamed('/login');
                          } else {
                            Modular.to.pushNamed('/mypage');
                          }
                        }),
                    Padding(padding: EdgeInsets.only(right: 15))
                  ],
                ),
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xff384230)),
                ));
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Modular.to.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  backgroundColor: Color(0x00ffffff),
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    '',
                    style: GoogleFonts.taviraj(fontSize: 25),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Modular.to.pushNamed('/cart');
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
                            Modular.to.pushNamed('/login');
                          } else {
                            Modular.to.pushNamed('/mypage');
                          }
                        }),
                    Padding(padding: EdgeInsets.only(right: 15))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                ));
          } else {
            List<ProductGet> productData = snapshot.data['productInCategory'];
            CategoryGet category = snapshot.data['category'];
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Modular.to.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  backgroundColor: Color(0x00ffffff),
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    category.categoryName,
                    style: GoogleFonts.taviraj(fontSize: 25),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Modular.to.pushNamed('/cart');
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
                            Modular.to.pushNamed('/login');
                          } else {
                            Modular.to.pushNamed('/mypage');
                          }
                        }),
                    Padding(padding: EdgeInsets.only(right: 15))
                  ],
                ),
                body: ListView.builder(
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _listItem(productData, index * 2),
                        _listItem(productData, index * 2 + 1)
                      ],
                    );
                  },
                  itemCount: (productData.length / 2).ceil() == 0
                      ? 0
                      : (productData.length / 2).ceil().toInt(),
                ));
          }
        });
  }

  Widget _listItem(List<ProductGet> productData, index) {
    if (productData.length < index + 1) {
      return Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width / 2.3,
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width / 2.3,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Modular.to.pushNamed('/productdetail?product-number=' +
                      productData[index].productNumber.toString());
                },
                child: Image.network(
                    'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
                        productData[index].productThumnailUrl,
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.width / 1.76,
                    fit: BoxFit.cover),
              ),
              Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0x25ffffff),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {},
                      icon: heartIcon,
                      color: Colors.white,
                    ),
                  ),
                  top: 20,
                  right: 4)
            ],
          ),
          Text(
            productData[index].productName,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansCJKkr'),
          ),
          Text(
            productData[index].productSize,
            style: TextStyle(
                fontSize: 13,
                fontFamily: 'NotoSansCJKkr',
                fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              productData[index].productPrice.toString() + '원',
              style:
                  GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      );
    }
  }

  Future<dynamic> _getCategoryDetail(categoryId) async {
    final productInCategory = await _getAllProductInCategory(categoryId);
    final category = await _getCategory(categoryId);
    return {
      'productInCategory': productInCategory,
      'category': category,
    };
  }

  Future<List<ProductGet>> _getAllProductInCategory(categoryId) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/in/category?category-id=' +
            categoryId));

    List<ProductGet> productInCategoryList = [];

    if (response.statusCode == 200) {
      for (var i = 0; i < json.decode(response.body).length; i++) {
        productInCategoryList
            .add(ProductGet.fromJson(json.decode(response.body)[i]));
      }
      return productInCategoryList;
    } else {
      throw Exception("아직 상품이 준비되지 않았습니다.");
    }
  }

  Future<CategoryGet> _getCategory(categoryId) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/category/one?category-id=' +
            categoryId));
    if (response.statusCode == 200) {
      return CategoryGet.fromJson(json.decode(response.body));
    } else {
      throw Exception("categoryId에 해당하는 카테고리가 없습니다.");
    }
  }
}
