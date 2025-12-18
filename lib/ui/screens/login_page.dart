import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';

import '../../data/models/user_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool signInProgress = false;

  Future<void> signIn() async {
    setState(() {
      signInProgress = true;
    });
    Map<String, dynamic> requestBody = {
      'email': _emailController.text,
      'password': _passwordController.text
    };

    final APIResponse response = await ApiCaller.postRequest(url: Urls.loginURl, body: requestBody);

    setState(() {
      signInProgress = false;
    });

    if(response.isSuccess){
      final UserModel model = UserModel.fromJson(response.body['data']);
      final String accessToken = response.body['token'];
      await AuthController.saveUserData(model, accessToken);
      clearController();
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Log in Success'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.lightGreen,
          ),
      );
      Navigator.pushReplacementNamed(context, '/bottom_nav');

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
    _passwordController.clear();
  }

  void _forgetPassword() {

    if (!mounted) return;
    Navigator.pushNamed(context, '/forget_password');

  }

  void _onTapSignUp () {

    Navigator.pushNamed(context, '/sign_up');

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 200),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Get Started With',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _emailController,

                      decoration: const InputDecoration(
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

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password'
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
                      visible: !signInProgress,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined, size: 30)
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextButton( onPressed: _forgetPassword, child: const Text('Forget Password?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen, fontSize: 16))),
                    RichText(
                      text: TextSpan(

                        text: 'Don\'t have an account?',
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
                            style: const TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),
                          )
                        ],
                        style: const TextStyle(fontSize: 18,color: Colors.black, fontWeight: FontWeight.bold),

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