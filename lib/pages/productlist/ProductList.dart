import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../post/ProductGet.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var heartIcon = Icon(Icons.favorite_border_outlined);
  @override
  Widget build(BuildContext context) {
    //?를 붙인 것은 개발용 나중에 String으로 바꿈
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
          title: Text(
            arg,
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
            future: _getProduct(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0xFF384230)),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
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
            })
        // FutureBuilder(
        //     builder: (context, snapshot) => ListView(
        //           children: [],
        //         )),
        );
  }

  Future<List<ProductGet>> _getProduct() async {
    final response =
        await http.get(Uri.parse('https://flyingstone.me/myapi/product'));
    List<ProductGet> productList = [];
    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        productList.add(ProductGet.fromJson(item));
      }
      print(productList);
      return productList;
    } else {
      throw Exception("asdfasdf");
    }
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
                  Navigator.pushNamed(context, '/productdetail',
                      arguments: productData[index].productNumber);
                },
                child: Image.network(
                    'https://vinarc.s3.ap-northeast-2.amazonaws.com' +
                        productData[index].productThumnailUrl!,
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
            productData[index].productName!,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansCJKkr'),
          ),
          Text(
            productData[index].productSize!,
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
}
