import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/providers/reset_password_provider.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';
import 'package:provider/provider.dart';

class ForgetPasswordEmailVerify extends StatefulWidget {


  const ForgetPasswordEmailVerify({super.key});

  @override
  State<ForgetPasswordEmailVerify> createState() => _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Your Email Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(' A 6 digit OTP will be sent to your email address',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: TextFormField(
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
                  ),
                  const SizedBox(height: 20),
                  Consumer<ResetPasswordProvider>(
                    builder: (context, provider, child) {

                      if(provider.verifyEmailState == ApiState.isLoading) return Center(child: const CircularProgressIndicator());

                      return FilledButton(

                        onPressed: () async {

                          if(!_formKey.currentState!.validate()) return;

                          final bool isSuccess = await provider.resetPassword(email: _emailController.text.trim());
                          if(!context.mounted) return;
                          if(isSuccess){
                            Navigator.pushNamed(context, '/forget_password_otp', arguments: _emailController.text.trim());
                            showSnackBarMessage(
                                context: context,
                                message: 'A 6 digit OTP code sent to your email',
                                backgroundColor: Colors.green
                            );
                          } else {
                            showSnackBarMessage(
                                context: context,
                                message:  provider.errorMessage ?? 'Failed to send OTP. Please try again.',
                                backgroundColor: Colors.redAccent
                            );
                          }

                          },
                        child:const Icon(Icons.arrow_circle_right_outlined)
                      );
                    }
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(

                      text: 'Have an account? ',
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                    ),

                  )

                ],
              ),
            ),
          )
      ),
    );
  }
}