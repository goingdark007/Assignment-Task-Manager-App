import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/data/services/api_caller.dart';

import '../data/utils/urls.dart';

class ResetPasswordProvider  extends ChangeNotifier {

  ApiState _verifyEmailState = ApiState.initial;
  ApiState _resetPasswordState = ApiState.initial;
  ApiState _verifyOtpState = ApiState.initial;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  ApiState get resetPasswordState => _resetPasswordState;
  ApiState get verifyOtpState => _verifyOtpState;
  ApiState get verifyEmailState => _verifyEmailState;

  Future<bool> resetPassword({required String email}) async {

    bool isSuccess = false;

    _verifyEmailState = ApiState.isLoading;
    notifyListeners();

    final APIResponse response = await ApiCaller.getRequest(url: Urls.verifyEmailURL(email));

    if (response.isSuccess) {
      _verifyEmailState = ApiState.success;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _verifyEmailState = ApiState.error;
      isSuccess = false;
      _errorMessage = response.errorMessage ?? 'Failed to send reset password email. Please try again.';
    }

    notifyListeners();

    return isSuccess;
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {

    bool isSuccess = false;

    _verifyOtpState = ApiState.isLoading;
    notifyListeners();

    final APIResponse response = await ApiCaller.getRequest(url: Urls.verifyOtpURL(email, otp));

    if (response.isSuccess) {
      _verifyOtpState = ApiState.success;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _verifyOtpState = ApiState.error;
      isSuccess = false;
      _errorMessage = response.errorMessage ?? 'Failed to verify OTP. Please try again.';
    }

    notifyListeners();

    return isSuccess;
  }

  Future<bool> resetPasswordWithOtp({required Map<String, dynamic> data}) async {

    bool isSuccess = false;

    _resetPasswordState = ApiState.isLoading;
    notifyListeners();

    final APIResponse response = await ApiCaller.postRequest(
      url: Urls.resetPasswordURL,
      body: data
    );

    if (response.isSuccess) {
      _resetPasswordState = ApiState.success;
      _errorMessage = null;
      isSuccess = true;
    } else {
      _resetPasswordState = ApiState.error;
      isSuccess = false;
      _errorMessage = response.errorMessage ?? 'Failed to reset password. Please try again.';
    }

    notifyListeners();

    return isSuccess;
  }

}