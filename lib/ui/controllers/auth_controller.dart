import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/user_model.dart';

class AuthController {
  static String? accessToken;
  static UserModel? userModel;

  static const String _accessTokenKey = 'access_token';
  static const String _userDataKey = 'user_data';
  //save user information
  static Future<void> saveUserData(String token, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));

    accessToken = token;
    userModel = model;
  }
  // Get user information

  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userDataKey);
    debugPrint('user data=> $userData');
    accessToken = token;
    userModel = UserModel.fromJson(jsonDecode(userData!));
  }
  // Check if user already logged in

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('access_token');
    if (token != null) {
      await getUserData();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
