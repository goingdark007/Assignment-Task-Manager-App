import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';

import '../data/models/user_model.dart';
import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

class NetworkProvider extends ChangeNotifier {

  ApiState _loginState = ApiState.initial;
  ApiState _registerState = ApiState.initial;
  ApiState _profileUpdateState = ApiState.initial;
  ApiState _addNewTaskState = ApiState.initial;


  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  ApiState get loginState => _loginState;

  ApiState get registerState => _registerState;

  ApiState get addNewTaskState => _addNewTaskState;

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

  Future<Map<String,dynamic>?> addTask({required String title, required String description}) async {
    _addNewTaskState = ApiState.isLoading;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'title': title,
      'description': description,
      "status" : "New"
    };

    final APIResponse response = await ApiCaller.postRequest(url: Urls.createTaskURl, body: requestBody);


    if(response.isSuccess){

      _addNewTaskState = ApiState.success;
      notifyListeners();

      return response.body;

    } else {
      _addNewTaskState = ApiState.error;
      _errorMessage = response.errorMessage;
      notifyListeners();
      return null;
    }

  }

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _encodedPhoto;
  String? get encodedPhoto => _encodedPhoto;
  XFile? get selectedImage => _selectedImage;


  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
        _selectedImage = image;
        notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String? password,
     }) async {

    _profileUpdateState = ApiState.isLoading;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'mobile':mobile,
    };

    if(password != null && password.isNotEmpty) requestBody['password'] = password;

    if(_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      _encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }


    final APIResponse response = await ApiCaller.postRequest(url: Urls.updateProfile, body: requestBody);

    if(response.isSuccess){
      _profileUpdateState = ApiState.success;
      notifyListeners();
      return response.body;
      // UserModel user = UserModel(
      //     email: _emailController.text,
      //     firstName: _firstNameController.text,
      //     lastName: _lastNameController.text,
      //     mobile: _mobileController.text,
      //     photo: encodedPhoto ?? AuthController.userModel!.photo
      // );
      // await AuthController.updateUserData(user);
      // if(!mounted) return;
      // showSnackBarMessage(context, 'Profile Updated Successfully');
      // Navigator.pushReplacementNamed(context, '/bottom_nav');
    } else {
      _profileUpdateState = ApiState.error;
      _errorMessage = response.errorMessage;
      notifyListeners();
      return null;
      // if(!mounted) return;
      // showSnackBarMessage(context, response.errorMessage ?? 'Profile Update Failed');
    }

  }

}