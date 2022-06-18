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
    //?를 붙인 것은 개발용 나중에 String으로 바꿈

    // context.read<Product>().getAllProduct();
    // List<ProductGet> productData = context.read<Product>().allProduct;
    int arg = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as int
        : -1;

    CategoryGet category;
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
        body: FutureBuilder<List<ProductGet>>(
            future: _getAllProductInCategory(widget.arg),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0xff384230)),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              } else {
                List<ProductGet> productData = snapshot.data;
                return ListView.builder(
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
                );
              }
            }));

    // }));
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
                  Navigator.pushNamed(
                    context,
                    '/productdetail',
                  );
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
              productData[index].productPrice.toString(),
              style:
                  GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ]),
      );
    }
  }

  Future<List<ProductGet>> _getAllProductInCategory(categoryId) async {
    final response = await http.get(Uri.parse(
        'https://flyingstone.me/myapi/product/in/category?category-id=' +
            categoryId));
    List<ProductGet> productInCategoryList = [];
    if (response.statusCode == 200) {
      print(json.decode(response.body).length);
      for (var i = 0; i < json.decode(response.body).length; i++) {
        print(i);
        productInCategoryList
            .add(ProductGet.fromJson(json.decode(response.body)[i]));
      }
      return productInCategoryList;
    } else {
      throw Exception("아직 상품이 준비되지 않았습니다.");
    }
  }
}
