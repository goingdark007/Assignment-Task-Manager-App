import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:of9_task_manager/data/models/user_model.dart';
import 'package:of9_task_manager/data/services/api_caller.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';
import 'package:of9_task_manager/ui/widgets/tm_app_bar.dart';
import '../../data/utils/urls.dart';
import '../controller/auth_controller.dart';
import '../widgets/photo_picker.dart';

class UpdateProfile extends StatefulWidget {

  const UpdateProfile ({
    super.key,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();

}

class _UpdateProfileState extends State<UpdateProfile>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool isUpdateProfileProgress = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _updateProfile() async {

    setState(() {
      isUpdateProfileProgress = true;
    });

    Map<String, dynamic> requestBody = {
      'email': _emailController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'mobile': _mobileController.text,
    };

    if(_passwordController.text.isNotEmpty) requestBody['password'] = _passwordController.text;

    String? encodedPhoto;

    if(_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }


    final APIResponse response = await ApiCaller.postRequest(url: Urls.updateProfile, body: requestBody);

    setState(() {
      isUpdateProfileProgress = false;
    });

    if(response.isSuccess){
      UserModel user = UserModel(
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          mobile: _mobileController.text,
          photo: encodedPhoto ?? AuthController.userModel!.photo
      );
      await AuthController.updateUserData(user);
      if(!mounted) return;
      showSnackBarMessage(context, 'Profile Updated Successfully');
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    } else {
      if(!mounted) return;
      showSnackBarMessage(context, response.errorMessage ?? 'Profile Update Failed');
    }

  }

  @override
  void initState() {
    super.initState();
    UserModel? user = AuthController.userModel;
    _emailController.text = user?.email ?? '';
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _mobileController.text = user?.mobile ?? '';

  }

  @override
  void dispose(){
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Update Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    PhotoPicker(onTap: _pickImage, selectedPhoto: _selectedImage),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                        validator: (String? value) {

                          final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                      ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your First Name';
                          } else if (value.trim().length < 3) {
                            return 'First Name must be at least 3 characters long';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                      ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Last Name';
                          } else if (value.trim().length < 3) {
                            return 'First Name must be at least 3 characters long';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        hintText: 'Mobile',
                      ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Mobile Number';
                          } else if (value.trim().length != 11) {
                            return 'Mobile Number must be 11 digits long';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                        validator:  (String? value) {
                           if ( value != null && value.isNotEmpty && value.length <= 6) {
                             return 'Password must be at least 7 characters long';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _updateProfile();
                          }
                        },
                        child:const Icon(Icons.arrow_circle_right_outlined)
                    ),
                    const SizedBox(height: 20),

                    RichText(
                      text: const TextSpan(

                        text: 'Have an account?',
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          )
                        ],
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                      ),

                    )

                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

}