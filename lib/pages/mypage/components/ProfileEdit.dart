import 'package:flutter/material.dart';

class ProfileEdit extends StatelessWidget {
  final String div;
  final String value;
  const ProfileEdit({Key? key, required this.div, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            div,
            style: TextStyle(
                color: Color(0xFF384230), fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(value),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 12, color: Color(0xFFB4B4B4)))
            ],
          )
        ],
      ),
    );
  }
}
