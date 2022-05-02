import 'package:flutter/material.dart';
import 'package:vinarc/pages/mypage/layout/ProfileAndAddressLayout.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    return ProfileAndAddressLayout(
      text: "Address",
      bodyWidget: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return Container();
  }
}
