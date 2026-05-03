import 'package:flutter/material.dart';
import 'package:of9_task_manager/providers/reset_password_provider.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';

import '../../core/enums/api_state.dart';
import '../widgets/screen_background.dart';

class ResetPassword extends StatefulWidget{
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Set Password',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text('Password should be more than 6 letters and combination of numbers',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer<ResetPasswordProvider>(
                      builder: (context, provider, _) {

                        if(provider.resetPasswordState == ApiState.isLoading) {
                          return Center(child: const CircularProgressIndicator());
                        }

                        return FilledButton(
                            onPressed: () async {

                              if(!_formKey.currentState!.validate()) return;

                              final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

                              args['password'] = _passwordController.text.trim();

                              final bool isSuccess = await provider.resetPasswordWithOtp(data: args);

                              if(!context.mounted) return;
                              if(isSuccess){
                                Navigator.pushNamedAndRemoveUntil( context, '/login', (predicateRoute) => false);
                                showSnackBarMessage(context: context, message: 'Password reset successfully, Please login with your new password', backgroundColor: Colors.green);
                              } else {
                                showSnackBarMessage(context: context, message: provider.errorMessage ?? 'Failed to reset password', backgroundColor: Colors.redAccent);
                              }

                              },
                            child:const Icon(Icons.arrow_circle_right_outlined)
                        );
                      }
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