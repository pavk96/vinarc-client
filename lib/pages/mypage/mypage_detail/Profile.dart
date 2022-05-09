import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:vinarc/pages/mypage/components/ProfileEdit.dart';
import 'package:vinarc/pages/mypage/layout/ProfileAndAddressLayout.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileAndAddressLayout(
      text: "Profile Edit",
      bodyWidget: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 13.8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileEdit(div: "이름", value: "Umesh appu"),
                      ProfileEdit(div: "생년월일", value: "1993.04.05"),
                      ProfileEdit(div: "휴대폰", value: "010-5235-1321"),
                      ProfileEdit(div: "이메일 주소", value: "example@google.com"),
                    ]),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 11)),
              ElevatedButton(
                onPressed: () {},
                child: Text("로그아웃"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                    minimumSize: MaterialStateProperty.all(
                        Size((MediaQuery.of(context).size.width - 50), 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF384230))),
              )
            ]),
      ),
    );
  }
}
