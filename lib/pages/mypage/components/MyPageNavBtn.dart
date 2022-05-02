import 'package:flutter/material.dart';

class MyPageNavBtn extends StatelessWidget {
  final String text;
  final Widget destinationPage;
  const MyPageNavBtn(
      {Key? key, required this.text, required this.destinationPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 29,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(padding: EdgeInsets.only(left: 22)),
              Text("\u2022",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFF384230))),
              Padding(padding: EdgeInsets.only(right: 22)),
              Text(text,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF384230))),
              Padding(padding: EdgeInsets.only(right: 22)),
            ],
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => destinationPage));
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFD6D6D6),
                size: 16,
              ))
        ],
      ),
    );
  }
}
