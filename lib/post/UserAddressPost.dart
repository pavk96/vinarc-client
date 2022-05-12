import 'package:flutter/material.dart';

class UserAddressPost {
  final String? addressNickname;
  final int? addressState;
  final String? addressContext;
  final String? addressReceiverName;
  final String? addressReceiverPhoneNumber;
  final int? userUserNumber;

  UserAddressPost(
      {this.addressContext,
      this.addressNickname,
      this.addressState,
      this.addressReceiverName,
      this.addressReceiverPhoneNumber,
      this.userUserNumber});
  factory UserAddressPost.fromJson(Map<String, dynamic> json) {
    return UserAddressPost(
        addressContext: json['addressContext'],
        addressNickname: json['addressNickname'],
        addressState: json['addressState'],
        addressReceiverName: json['addressReceiverName'],
        addressReceiverPhoneNumber: json['addressReceiverPhoneNumber'],
        userUserNumber: json['userUserNumber']);
  }
}
