import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:of9_task_manager/core/enums/api_state.dart';
import 'package:of9_task_manager/providers/reset_password_provider.dart';
import 'package:of9_task_manager/ui/utils/pin_theme.dart';
import 'package:of9_task_manager/ui/widgets/custom_snack_bar.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../widgets/screen_background.dart';

class ForgetPasswordVerifyOtp extends StatefulWidget {

  const ForgetPasswordVerifyOtp({super.key});

  @override
  State<ForgetPasswordVerifyOtp> createState() => _ForgetPasswordVerifyOtpState();
}

class _ForgetPasswordVerifyOtpState extends State<ForgetPasswordVerifyOtp> {

  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Pin Verification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(' A 6 digit OTP will be sent to your email address',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),

                  Pinput(
                    controller: _otpController,
                    length: 6,
                    //autofocus: true
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    defaultPinTheme: PinPutTheme.defaultTheme,
                    focusedPinTheme: PinPutTheme.focusedTheme,
                    animationCurve: Curves.easeIn,
                    animationDuration: const Duration(milliseconds: 300),
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    cursor: const Text('_', style: TextStyle(fontSize: 20, color: Colors.black)),
                  ),

                  const SizedBox(height: 20),
                  Consumer<ResetPasswordProvider>(
                    builder: (context, provider, _) {

                      if(provider.verifyOtpState == ApiState.isLoading) return const Center(child: CircularProgressIndicator());

                      return FilledButton(
                          onPressed: () async {
                            final String email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
                            final bool isSuccess = await provider.verifyOtp(email: email, otp: _otpController.text.trim());
                            if(!context.mounted) return;
                            if(isSuccess) {
                              Navigator.pushReplacementNamed(
                                  context, '/reset_password',
                                  arguments: {
                                    'email': email,
                                    'OTP': _otpController.text.trim()
                                  }
                              );
                              showSnackBarMessage(context: context, message: 'OTP verified successfully',  backgroundColor: Colors.green);
                            } else {
                              showSnackBarMessage(context: context, message: provider.errorMessage ?? 'Failed to verify OTP', backgroundColor: Colors.redAccent);
                            }
                            },
                          child:const Icon(Icons.arrow_circle_right_outlined)
                      );
                    }
                  ),
                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(

                      text: 'Have an account?',
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacementNamed(context,'/login'),
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        )
                      ],
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

                    ),

                  ),


                ],
              ),
            ),
          )
      ),

    );
  }
}