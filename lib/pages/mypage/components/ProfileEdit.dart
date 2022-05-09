import 'package:flutter/material.dart';

class ProfileEdit extends StatelessWidget {
  final String div;
  final String value;
  const ProfileEdit({Key? key, required this.div, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController changeController = TextEditingController();
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
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(div + "을(를) 변경하세요"),
                            content: TextField(
                              controller: changeController,
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
                                    _changeProfile(div, changeController.text);
                                  },
                                  child: Text("Yes",
                                      style:
                                          TextStyle(color: Color(0xFF384230))))
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.arrow_forward_ios,
                      size: 12, color: Color(0xFFB4B4B4)))
            ],
          )
        ],
      ),
    );
  }

  void _changeProfile(String div, String newValue) {
    print(div + newValue);

    // var result = await http.get(
    //   Uri.parse('https://flyingstone.me/myapi/user/auth/naver'),
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Access-Control-Allow-Origin": "*",
    //     "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    //   },
    // );
    // print(result.statusCode);
    // if (result.statusCode == 200) {
    //   print(result.body);
    // } else {
    //   throw Exception('실패함ㅅㄱ');
    // }
  }
}
