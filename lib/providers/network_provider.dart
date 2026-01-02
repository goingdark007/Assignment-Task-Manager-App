
import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';

import '../data/models/user_model.dart';
import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

class NetworkProvider extends ChangeNotifier {

  ApiState _loginState = ApiState.initial;
  ApiState _registerState = ApiState.initial;
  ApiState _profileUpdateState = ApiState.initial;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  ApiState get loginState => _loginState;

  ApiState get registerState => _registerState;

  ApiState get profileUpdateState => _profileUpdateState;

  Future<Map<String, dynamic>?> login(
      {required String email, required String password}) async {

    _loginState = ApiState.isLoading;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password
    };

    final APIResponse response = await ApiCaller.postRequest(
        url: Urls.loginURl, body: requestBody);

    if (response.isSuccess) {
      _loginState = ApiState.success;
      notifyListeners();
      return {
        'user': UserModel.fromJson(response.body['data']),
        'token': response.body['token']
      };
    } else {
      _loginState = ApiState.error;
      _errorMessage = response.errorMessage;
      notifyListeners();
      return null;

   }
  }

  Future <Map<String, dynamic>?> register
      ({required String email,
        required String password,
        required String firstName,
        required String lastName,
        required String mobile}) async {

      _registerState = ApiState.isLoading;
      notifyListeners();

      Map<String, dynamic> requestBody = {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'mobile': mobile,
        'password': password
      };

      final APIResponse response = await ApiCaller.postRequest(url: Urls.registrationURl, body: requestBody);

      if (response.isSuccess) {
        _registerState = ApiState.success;
        notifyListeners();
        return response.body;
      } else {
        _registerState = ApiState.error;
        _errorMessage = response.errorMessage;
        notifyListeners();
        return null;
      }



  }

}