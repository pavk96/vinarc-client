import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vinarc/pages/mypage/layout/ProfileAndAddressLayout.dart';
import 'package:vinarc/post/UserAddressGet.dart';
import 'package:http/http.dart' as http;
import 'package:vinarc/post/UserAddressPost.dart';
import 'package:vinarc/post/UserProfilePost.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({Key? key}) : super(key: key);

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return ProfileAndAddressLayout(
      text: "Address",
      bodyWidget: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    TextEditingController addressNicknameController = TextEditingController();
    TextEditingController addressContextController = TextEditingController();
    TextEditingController addressReceiverNameController =
        TextEditingController();
    TextEditingController addressReceiverPhoneNumberController =
        TextEditingController();
    final bool isRoadAddress = true;
    return FutureBuilder<UserAddressGet>(
      future: _getUserAddress(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data);
        if (snapshot.hasData == false) {
          return Container(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("배송지를 입력해 주세요"),
                        content: Column(
                          children: [
                            TextField(
                              controller: addressNicknameController,
                              decoration: InputDecoration(hintText: "배송지 이름"),
                            ),
                            Checkbox(
                                value: isRoadAddress,
                                onChanged: (isRoadAddress) {
                                  setState(() {
                                    isRoadAddress = !isRoadAddress!;
                                  });
                                }),
                            TextField(
                              controller: addressContextController,
                              decoration: InputDecoration(hintText: "주소"),
                            ),
                            TextField(
                              controller: addressReceiverNameController,
                              decoration: InputDecoration(hintText: "받는 사람 이름"),
                            ),
                            TextField(
                              controller: addressReceiverPhoneNumberController,
                              decoration:
                                  InputDecoration(hintText: "받는 사람 전화번호"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Color(0xFF384230)),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _createUserAddress(
                                    addressNicknameController.text,
                                    addressContextController.text,
                                    addressReceiverNameController.text,
                                    addressReceiverPhoneNumberController.text,
                                    true);
                              },
                              child: Text("Yes",
                                  style: TextStyle(color: Color(0xFF384230))))
                        ],
                      );
                    });
              },
            ),
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
          return Container(
            child: Text(snapshot.data.addressNickname),
          );
        }
      },
    );
  }

  Future<UserAddressGet> _getUserAddress() async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {'authorization': token ?? ''};
    final response = await http.get(
        Uri.parse('https://flyingstone.me/myapi/user/address'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return UserAddressGet.fromJson(json.decode(response.body));
    } else {
      throw Exception("asdfasdf");
    }
  }

  Future<UserAddressPost> _createUserAddress(
      String addressNickname,
      String addressContext,
      String addressReceiverName,
      String addressReceiverPhoneNumber,
      bool addressState) async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token.toString()
    };
    final response = await http.post(
        Uri.parse('https://flyingstone.me/myapi/user/address/create'),
        body: json.encode({
          addressNickname: addressNickname,
          addressContext: addressContext,
          addressReceiverName: addressReceiverName,
          addressReceiverPhoneNumber: addressReceiverPhoneNumber,
          addressState: addressState
        }),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return UserAddressPost.fromJson(json.decode(response.body));
    } else {
      throw Exception("asdfasdf");
    }
  }
}
