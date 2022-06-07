import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    //?를 붙인 것은 개발용 나중에 String으로 바꿈
    String? arg =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'category';
    var heartIcon = Icon(Icons.favorite_border_outlined);
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
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/productdetail',
                                    arguments: arg);
                              },
                              child: Image.asset(
                                  'assets/img/productlist/oneproduct.png',
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  height:
                                      MediaQuery.of(context).size.width / 1.76,
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
                      ]),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset('assets/img/productlist/oneproduct.png',
                                width: MediaQuery.of(context).size.width / 2.3,
                                height:
                                    MediaQuery.of(context).size.width / 1.76,
                                fit: BoxFit.cover),
                            Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0x25ffffff),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        heartIcon = Icon(Icons.favorite_border,
                                            color: Colors.red);
                                      });
                                    },
                                    icon: heartIcon,
                                    color: Colors.white,
                                  ),
                                ),
                                top: 20,
                                right: 4)
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
                      ]),
                ),
              ],
            )
          ],
        )
        // FutureBuilder(
        //     builder: (context, snapshot) => ListView(
        //           children: [],
        //         )),
        );
  }
}
