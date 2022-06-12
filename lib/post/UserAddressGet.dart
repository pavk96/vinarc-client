import 'package:flutter/material.dart';

class UserAddressGet {
  final int? addressId;
  final String? addressNickname;
  final bool? addressState;
  final String? addressContext;
  final String? addressReceiverName;
  final String? addressReceiverPhoneNumber;
  final int? userUserNumber;

  UserAddressGet(
      {this.addressId,
      this.addressContext,
      this.addressNickname,
      this.addressState,
      this.addressReceiverName,
      this.addressReceiverPhoneNumber,
      this.userUserNumber});
  factory UserAddressGet.fromJson(Map<String, dynamic> json) {
    return UserAddressGet(
        addressId: json['address_id'],
        addressContext: json['address_context'],
        addressNickname: json['address_nickname'],
        addressReceiverName: json['address_receiver_name'],
        addressReceiverPhoneNumber: json['address_receiver_phone_number'],
        userUserNumber: json['user_number']);
  }
}
