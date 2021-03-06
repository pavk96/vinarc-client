import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtraAppBarLeading extends StatelessWidget {
  const ExtraAppBarLeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
        size: 30,
      ),
      onPressed: () {
        Modular.to.pop();
      },
    );
  }
}
