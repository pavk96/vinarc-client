import 'package:flutter/material.dart';
import 'package:footer/footer.dart';

class FooterContent extends StatelessWidget {
  const FooterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ICONSIZE = MediaQuery.of(context).size.height / 31.5;
    double FONTSIZE = MediaQuery.of(context).size.height / 46.1;
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 19.45,
            top: MediaQuery.of(context).size.height / 31.5),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    iconSize: ICONSIZE,
                    icon: Image.asset('assets/img/footer/instagram.png')),
                IconButton(
                    onPressed: () {},
                    iconSize: ICONSIZE,
                    icon: Image.asset('assets/img/footer/share.png')),
                IconButton(
                    onPressed: () {},
                    iconSize: ICONSIZE,
                    icon: Image.asset('assets/img/footer/like.png'))
              ],
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 31.5)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@copyright vinarc\nAddress : 대구광역시 ~~~\nPhone : 010-1234-1234",
                  style: TextStyle(
                      color: Color(0xFF707070),
                      fontFamily: 'AppleSDSandolGothicNeo',
                      fontSize: FONTSIZE,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ));
  }
}
