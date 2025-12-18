import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';

class ResetPassword extends StatefulWidget{
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: () => Navigator.pushReplacementNamed( context, '/bottom_nav'),
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