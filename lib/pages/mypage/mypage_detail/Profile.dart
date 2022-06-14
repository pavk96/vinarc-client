import 'dart:convert';

import 'package:bootpay/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:http/http.dart' as http;
import 'package:vinarc/pages/mypage/components/ProfileEdit.dart';
import 'package:vinarc/pages/mypage/layout/ProfileAndAddressLayout.dart';
import 'package:vinarc/post/UserProfilePost.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return ProfileAndAddressLayout(
      text: "Profile Edit",
      bodyWidget: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return FutureBuilder<UserProfilePost>(
        future: _getUserProfile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF384230)),
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
            UserProfilePost userData = snapshot.data;
            return SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 13.8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfileEdit(div: "이름", value: userData.userName),
                              ProfileEdit(
                                  div: "생년월일", value: userData.userBirth),
                              ProfileEdit(
                                  div: "휴대폰", value: userData.userPhone),
                              ProfileEdit(
                                  div: "이메일 주소", value: userData.userEmail),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 11)),
                      ElevatedButton(
                        onPressed: () {
                          final storage = FlutterSecureStorage();
                          storage.delete(key: "token");
                          Navigator.of(context).pushNamed('/');
                        },
                        child: Text("로그아웃"),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            minimumSize: MaterialStateProperty.all(Size(
                                (MediaQuery.of(context).size.width - 50), 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF384230))),
                      )
                    ]),
              ),
            );
          }
        });
  }

  Future<UserProfilePost> _getUserProfile() async {
    String? token = await storage.read(key: "token");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token.toString()
    };
    final response = await http.get(
        Uri.parse('http://flyingstone.me/myapi/user/profile'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return UserProfilePost.fromJson(json.decode(response.body));
    } else {
      throw Exception("asdfasdf");
    }
  }
}
