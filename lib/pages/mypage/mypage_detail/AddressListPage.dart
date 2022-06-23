import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kpostal/kpostal.dart';
import 'package:vinarc/pages/mypage/layout/ProfileAndAddressLayout.dart';
import 'package:vinarc/post/UserAddressGet.dart';
import 'package:http/http.dart' as http;
import 'package:vinarc/util/DynamicLink.dart';

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
      bodyWidget: SizedBox(
          height: MediaQuery.of(context).size.height, child: bodyWidget()),
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
    return FutureBuilder<List<UserAddressGet>>(
      future: _getUserAddress(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return Column(
            children: [
              SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 50.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "배송지 정보",
                      style: TextStyle(
                          color: Color(0xFF384230),
                          fontFamily: 'NotoSansCJKkr',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 16,
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KpostalView()));
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            // return AlertDialog(
                            //   title: Text("배송지를 입력해 주세요"),
                            //   content: Column(
                            //     children: [
                            //       TextField(
                            //         controller: addressNicknameController,
                            //         decoration:
                            //             InputDecoration(hintText: "배송지 이름"),
                            //       ),
                            //       Checkbox(
                            //           value: isRoadAddress,
                            //           onChanged: (isRoadAddress) {
                            //             setState(() {
                            //               isRoadAddress = !isRoadAddress!;
                            //             });
                            //           }),
                            //       TextField(
                            //         controller: addressContextController,
                            //         decoration:
                            //             InputDecoration(hintText: "주소"),
                            //       ),
                            //       TextField(
                            //         controller:
                            //             addressReceiverNameController,
                            //         decoration: InputDecoration(
                            //             hintText: "받는 사람 이름"),
                            //       ),
                            //       TextField(
                            //         controller:
                            //             addressReceiverPhoneNumberController,
                            //         decoration: InputDecoration(
                            //             hintText: "받는 사람 전화번호"),
                            //       ),
                            //     ],
                            //   ),
                            //   actions: [
                            //     TextButton(
                            //         onPressed: () {
                            //                        Modular.to.pop(context);
                            //         },
                            //         child: Text(
                            //           "Cancel",
                            //           style: TextStyle(
                            //               color: Color(0xFF384230)),
                            //         )),
                            //     TextButton(
                            //         onPressed: () {
                            //                        Modular.to.pop(context);

                            //           String body = json.encode({
                            //             "addressNickname":
                            //                 addressNicknameController.text,
                            //             "addressContext":
                            //                 addressContextController.text,
                            //             "addressReceiverName":
                            //                 addressReceiverNameController
                            //                     .text,
                            //             "addressReceiverPhoneNumber":
                            //                 addressReceiverPhoneNumberController
                            //                     .text,
                            //             "addressState": isRoadAddress
                            //           });
                            //           _createUserAddress(body);
                            //         },
                            //         child: Text("Yes",
                            //             style: TextStyle(
                            //                 color: Color(0xFF384230))))
                            //   ],
                            // );
                            //       });
                            // },
                          }),
                    ),
                  ],
                ),
              ),
            ],
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
          return Column(
            children: [
              SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 50.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "배송지 정보",
                      style: TextStyle(
                          color: Color(0xFF384230),
                          fontFamily: 'NotoSansCJKkr',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        iconSize: 16,
                        onPressed: () async {
                          Kpostal result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => KpostalView(
                                        callback: (Kpostal result) {
                                          print(result);
                                          setState(() {
                                            result.kakaoLongitude.toString();
                                          });
                                        },
                                      )));
                          print(result);

                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: Text("배송지를 입력해 주세요"),
                          //         content: Column(
                          //           children: [
                          //             TextField(
                          //               controller: addressNicknameController,
                          //               decoration:
                          //                   InputDecoration(hintText: "배송지 이름"),
                          //             ),
                          //             Checkbox(
                          //                 value: isRoadAddress,
                          //                 onChanged: (isRoadAddress) {
                          //                   setState(() {
                          //                     isRoadAddress = !isRoadAddress!;
                          //                   });
                          //                 }),
                          //             TextField(
                          //               controller: addressContextController,
                          //               decoration:
                          //                   InputDecoration(hintText: "주소"),
                          //             ),
                          //             TextField(
                          //               controller:
                          //                   addressReceiverNameController,
                          //               decoration: InputDecoration(
                          //                   hintText: "받는 사람 이름"),
                          //             ),
                          //             TextField(
                          //               controller:
                          //                   addressReceiverPhoneNumberController,
                          //               decoration: InputDecoration(
                          //                   hintText: "받는 사람 전화번호"),
                          //             ),
                          //           ],
                          //         ),
                          //         actions: [
                          //           TextButton(
                          //               onPressed: () {
                          //                              Modular.to.pop(context);
                          //               },
                          //               child: Text(
                          //                 "Cancel",
                          //                 style: TextStyle(
                          //                     color: Color(0xFF384230)),
                          //               )),
                          //           TextButton(
                          //               onPressed: () {
                          //                              Modular.to.pop(context);

                          //                 String body = json.encode({
                          //                   "addressNickname":
                          //                       addressNicknameController.text,
                          //                   "addressContext":
                          //                       addressContextController.text,
                          //                   "addressReceiverName":
                          //                       addressReceiverNameController
                          //                           .text,
                          //                   "addressReceiverPhoneNumber":
                          //                       addressReceiverPhoneNumberController
                          //                           .text,
                          //                   "addressState": isRoadAddress
                          //                 });
                          //                 _createUserAddress(body);
                          //               },
                          //               child: Text("Yes",
                          //                   style: TextStyle(
                          //                       color: Color(0xFF384230))))
                          //         ],
                          //       );
                          //     });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    UserAddressGet userAddress = snapshot.data[index];
                    return Container(
                      margin: EdgeInsets.only(top: 22.0),
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          right: 22.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userAddress.addressNickname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB4B4B4),
                                      fontSize: 14,
                                      fontFamily: 'NotoSansCJKkr'),
                                ),
                                Text(userAddress.addressContext,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB4B4B4),
                                        fontSize: 14,
                                        fontFamily: 'NotoSansCJKkr')),
                                Text(userAddress.addressReceiverPhoneNumber,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB4B4B4),
                                        fontSize: 14,
                                        fontFamily: 'NotoSansCJKkr'))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    color: Color(0xFFB4B4B4),
                                    iconSize: 16,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("배송지를 입력해 주세요"),
                                              content: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        addressNicknameController,
                                                    decoration: InputDecoration(
                                                        hintText: "배송지 이름"),
                                                  ),
                                                  Checkbox(
                                                      value: isRoadAddress,
                                                      onChanged:
                                                          (isRoadAddress) {
                                                        setState(() {
                                                          isRoadAddress =
                                                              !isRoadAddress!;
                                                        });
                                                      }),
                                                  TextField(
                                                    controller:
                                                        addressContextController,
                                                    decoration: InputDecoration(
                                                        hintText: "주소"),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        addressReceiverNameController,
                                                    decoration: InputDecoration(
                                                        hintText: "받는 사람 이름"),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        addressReceiverPhoneNumberController,
                                                    decoration: InputDecoration(
                                                        hintText: "받는 사람 전화번호"),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop(context);
                                                    },
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF384230)),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop(context);
                                                      _updateUserAddress(
                                                          userAddress.addressId,
                                                          addressNicknameController
                                                              .text,
                                                          addressContextController
                                                              .text,
                                                          addressReceiverNameController
                                                              .text,
                                                          addressReceiverPhoneNumberController
                                                              .text,
                                                          true);
                                                    },
                                                    child: Text("Yes",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF384230))))
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    color: Color(0xFFB4B4B4),
                                    iconSize: 16,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("진짜 삭제 하시려구요?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop(context);
                                                    },
                                                    child: Text("NO",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF384230)))),
                                                TextButton(
                                                    onPressed: () {
                                                      Modular.to.pop(context);
                                                      _deleteUserAddress(
                                                          userAddress
                                                              .addressId);
                                                    },
                                                    child: Text("Yes",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF384230))))
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  itemCount: snapshot.data.length,
                ),
              )
            ],
          );
        }
      },
    );
  }

  Future<List<UserAddressGet>> _getUserAddress() async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {'authorization': token ?? ''};

    List<UserAddressGet> addressList = [];
    final response = await http.get(
        Uri.parse('https://flyingstone.me/myapi/user/address'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      for (var item in json.decode(response.body)) {
        addressList.add(UserAddressGet.fromJson(item));
      }
      return addressList;
    } else {
      throw Exception("asdfasdf");
    }
  }

  void _createUserAddress(String body) async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token.toString()
    };

    final response = await http.post(
        Uri.parse('https://flyingstone.me/myapi/user/address/create'),
        body: body,
        headers: requestHeaders);
    if (response.statusCode == 201) {
      setState(() {});
    } else {
      throw Exception("asdfasdf");
    }
  }

  void _updateUserAddress(
      int addressId,
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
    String body = json.encode({
      "addressId": addressId,
      "addressNickname": addressNickname,
      "addressContext": addressContext,
      "addressReceiverName": addressReceiverName,
      "addressReceiverPhoneNumber": addressReceiverPhoneNumber,
      "addressState": addressState
    });
    final response = await http.post(
        Uri.parse('https://flyingstone.me/myapi/user/address/update'),
        body: body,
        headers: requestHeaders);
    if (response.statusCode == 201) {
      setState(() {});
    } else {
      throw Exception("asdfasdf");
    }
  }

  void _deleteUserAddress(int address_id) async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token.toString()
    };
    final response = await http.get(
        Uri.parse(
            'https://flyingstone.me/myapi/user/address/delete?address_id=${address_id}'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      throw Exception("asdfasdf");
    }
  }
}
