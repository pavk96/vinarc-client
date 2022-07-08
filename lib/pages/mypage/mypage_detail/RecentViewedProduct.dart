import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vinarc/pages/mypage/layout/ExtraLayout.dart';

class RecentViewedProduct extends StatelessWidget {
  const RecentViewedProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtraLayout(
        text: "최근 본 상품",
        child: ListView(
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
                        Image.asset('assets/img/productlist/chair.png',
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: MediaQuery.of(context).size.width / 1.76,
                            fit: BoxFit.cover),
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
                        Image.asset('assets/img/productlist/chair.png',
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: MediaQuery.of(context).size.width / 1.76,
                            fit: BoxFit.cover),
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
        ));
  }
}
