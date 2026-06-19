import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';
import '../data/services/token_source.dart';

class AuthProvider extends ChangeNotifier implements TokenSource {

  final String _accessTokenKey = 'token';
  final String _userModelKey = 'user';

  String? _accessToken;
  UserModel? _userModel;
  String? _errorMessage;

  ApiState _authState = ApiState.initial;

  @override
  String? get accessToken => _accessToken;

  UserModel? get userModel => _userModel;
  ApiState get authState => _authState;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _accessToken != null;



  Future<void> saveUserData(UserModel model, String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    _accessToken = token;
    _userModel= model;
    notifyListeners();
  }

  Future<void> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userModelKey);
    if(token != null) {
      _accessToken = token;
      _userModel = UserModel.fromJson(jsonDecode(userData!));
      notifyListeners();
    }
  }

  Future<void> updateUserData(UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    _userModel = model;
    notifyListeners();
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userModelKey);
    if(token != null && userData != null) {
      _accessToken = token;
      _userModel = UserModel.fromJson(jsonDecode(userData));
      notifyListeners();
    }

    return token != null;
  }

  Future<void> clearUserData () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_userModelKey);
    // or use .clear() to remove all keys
    _accessToken = null;
    _userModel = null;
    _authState = ApiState.initial;
    notifyListeners();
  }

  void setLoading () {
    _authState = ApiState.isLoading;
    notifyListeners();
  }

  void setSuccess () {
    _authState = ApiState.success;
    notifyListeners();
  }

  void setErrorMessage (String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void resetState () {
    _authState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }


}