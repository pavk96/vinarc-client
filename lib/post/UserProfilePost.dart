import 'package:flutter/material.dart';

class UserProfilePost {
  final String? userName;
  final String? userBirth;
  final String? userPhone;
  final String? userEmail;

  UserProfilePost(
      {this.userName, this.userBirth, this.userPhone, this.userEmail});
  factory UserProfilePost.fromJson(Map<String, dynamic> json) {
    return UserProfilePost(
        userName: json['userName'],
        userBirth: json['userBirth'],
        userPhone: json['userPhone'],
        userEmail: json['userEmail']);
  }
}
