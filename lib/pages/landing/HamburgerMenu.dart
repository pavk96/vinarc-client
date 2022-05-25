import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  List<Widget> _hamburgerMenuList(context) {
    List<Widget> list = [
      Container(
        alignment: Alignment.centerRight,
        height: 103,
        child: IconButton(
          color: Colors.white,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
    ];
    List<Map<String, String>> content = [
      {'title': '마이페이지', 'route': '/mypage'},
      {'title': '카테고리', 'route': '/'},
      {'title': '주문/배송조회', 'route': '/'},
      {'title': '배송주소록', 'route': '/address'},
      {'title': '교환 및 환불', 'route': '/refund'},
      {'title': '쿠폰', 'route': '/coupon'},
      {'title': '최근 본 상품', 'route': '/recentproduct'},
    ];
    for (var item in content) {
      list.add(Container(
        padding: EdgeInsets.only(left: 22, right: 22),
        child: ListTile(
          leading: Text(
            "\u2022 ",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          title: Text(item['title']!,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSansCJKkr',
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pushNamed(context, item['route']!);
          },
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Drawer(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight:
                      Radius.circular(MediaQuery.of(context).size.width / 3))),
          backgroundColor: Color(0xFF3A4432),
          child: ListView(
            padding: EdgeInsets.zero,
            children: _hamburgerMenuList(context),
          )),
    );
  }
}
