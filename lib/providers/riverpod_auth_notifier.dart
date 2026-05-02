import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:of9_task_manager/data/models/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/enums/api_state.dart';
import '../data/models/user_model.dart';

class AuthNotifier extends StateNotifier<AuthState>{
  AuthNotifier() : super(const AuthState());

  final String _accessTokenKey = 'token';
  final String _userModelKey = 'user';

  String get accessToken => state.accessToken ?? '';
  UserModel? get userModel => state.userModel;


  Future<void> saveUserData(UserModel model, String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    /// Every time state is reassigned or changed UI listening to it will trigger a rebuild.
    state = AuthState(accessToken: token, userModel: model);
  }

  Future<void> getUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userModelKey);
    if(token != null) {
      state = AuthState(accessToken: token, userModel: UserModel.fromJson(jsonDecode(userData!)));
    }
  }

  Future<void> updateUserData(UserModel model) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    state = state.copyWith(userModel: model);

  }

  /// Don't return a value from notifier at same time changing state in riverpod it might cause problems
  Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_userModelKey);
    if(token != null && userData != null) {
      state = AuthState(accessToken: token, userModel: UserModel.fromJson(jsonDecode(userData)));
    }

    return token != null;
  }

  Future<void> clearUserData () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_userModelKey);
    // or use .clear() to remove all keys
    state = const AuthState();
  }

  void setLoading () {
    state = state.copyWith(authState: ApiState.isLoading);
  }

  void setSuccess () {
   state = state.copyWith(authState: ApiState.success);
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
