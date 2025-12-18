import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordEmailVerify extends StatelessWidget {

  const ForgetPasswordEmailVerify({super.key});

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
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed( context, '/forget_password_otp'),
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
          )
      ),
    );
  }

}