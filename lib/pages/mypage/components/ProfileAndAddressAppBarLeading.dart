import 'package:flutter/material.dart';

class ProfileAndAddressAppBarLeading extends StatelessWidget {
  const ProfileAndAddressAppBarLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double SIDEPADDINGSIZE = MediaQuery.of(context).size.width / 13.8;
    return Padding(
      padding: EdgeInsets.only(left: SIDEPADDINGSIZE),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
