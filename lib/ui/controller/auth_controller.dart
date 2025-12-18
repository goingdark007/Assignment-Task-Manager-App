import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class AuthController {

  static final String _accessTokenKey = 'token';
  static final String _userModelKey = 'user';

  static String? accessToken;
  static UserModel? userModel;

   static Future<void> saveUserData(UserModel model, String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    accessToken = token;
    userModel= model;
  }

  static Future<void> getUserData() async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     String? token = sharedPreferences.getString(_accessTokenKey);
     if(token != null) {
       String? userData = sharedPreferences.getString(_userModelKey);
       userModel = UserModel.fromJson(jsonDecode(userData!));
       accessToken = token;
     }
  }

  static Future<bool> isUserLoggedIn() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     String? token = sharedPreferences.getString(_accessTokenKey);
     if(token != null) accessToken = token;

     return token != null;
  }

  static Future<void> clearUserData () async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences.remove(_accessTokenKey);
     await sharedPreferences.remove(_userModelKey);
     // or use .clear() to remove all keys
     accessToken = null;
     userModel = null;
  }


}
