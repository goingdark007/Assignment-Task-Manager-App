import 'package:flutter/material.dart';
import 'package:of9_task_manager/data/utils/urls.dart';

import '../../data/services/api_caller.dart';
import '../widgets/screen_background.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool signUpInProgress = false;

  Future<void> signUp() async {
    setState(() {
      signUpInProgress = true;
    });

    Map<String, dynamic> requestBody = {
      'email': _emailController.text,
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'mobile': _mobileController.text,
      'password': _passwordController.text
    };

    final APIResponse response = await ApiCaller.postRequest(url: Urls.registrationURl, body: requestBody);

    setState(() {
      signUpInProgress = false;
    });

    if(response.isSuccess){
      clearController();
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Sign Up Success'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.lightGreen,
          )
      );
    } else {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body['data']),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        )
      );
    }

  }

  void clearController () {
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Join With Us',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (String? value) {

                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length <= 6) {
                            return 'Password must be at least 7 characters long';
                          }
                          return null;
                        }
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: !signUpInProgress,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUp();
                                Navigator.pushNamed( context, '/login');
                              }
                            },
                            child:const Icon(Icons.arrow_circle_right_outlined)
                        ),
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
            ),
          )
      ),
    );
  }
}