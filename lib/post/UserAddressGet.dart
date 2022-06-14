import 'package:flutter/material.dart';

class UserAddressGet {
  final int addressId;
  final String addressNickname;
  final bool addressState;
  final String addressContext;
  final String addressReceiverName;
  final String addressReceiverPhoneNumber;
  final int userUserNumber;

  UserAddressGet(
      {required this.addressId,
      required this.addressContext,
      required this.addressNickname,
      required this.addressState,
      required this.addressReceiverName,
      required this.addressReceiverPhoneNumber,
      required this.userUserNumber});
  factory UserAddressGet.fromJson(Map<String, dynamic> json) {
    return UserAddressGet(
        addressId: json['address_id'],
        addressContext: json['address_context'],
        addressNickname: json['address_nickname'],
        addressState: json['address_state'],
        addressReceiverName: json['address_receiver_name'],
        addressReceiverPhoneNumber: json['address_receiver_phone_number'],
        userUserNumber: json['user_number']);
  }
}
