import 'package:flutter/material.dart';

class UserAddressGet {
  final String? addressNickname;
  final bool? addressState;
  final String? addressContext;
  final String? addressReceiverName;
  final String? addressReceiverPhoneNumber;
  final int? userUserNumber;

  UserAddressGet(
      {this.addressContext,
      this.addressNickname,
      this.addressState,
      this.addressReceiverName,
      this.addressReceiverPhoneNumber,
      this.userUserNumber});
  factory UserAddressGet.fromJson(Map<String, dynamic> json) {
    print(UserAddressGet(
        addressContext: json['addressContext'],
        addressNickname: json['addressNickname'],
        addressReceiverName: json['addressReceiverName'],
        addressReceiverPhoneNumber: json['addressReceiverPhoneNumber'],
        userUserNumber: json['userUserNumber']));
    print(json["addressState"]);
    return UserAddressGet(
        addressContext: json['addressContext'],
        addressNickname: json['addressNickname'],
        addressReceiverName: json['addressReceiverName'],
        addressReceiverPhoneNumber: json['addressReceiverPhoneNumber'],
        userUserNumber: json['userUserNumber']);
  }
}
