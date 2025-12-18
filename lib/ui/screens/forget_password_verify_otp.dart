import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:of9_task_manager/ui/utils/pin_theme.dart';
import 'package:pinput/pinput.dart';

import '../widgets/screen_background.dart';

class ForgetPasswordVerifyOtp extends StatelessWidget {

  const ForgetPasswordVerifyOtp({super.key});

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
                  FilledButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/reset_password'),
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

                  ),


                ],
              ),
            ),
          )
      ),

    );
  }

}