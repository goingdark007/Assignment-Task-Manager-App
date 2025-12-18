import 'package:flutter/material.dart';
import 'package:of9_task_manager/ui/screens/add_new_task.dart';
import 'package:of9_task_manager/ui/screens/bottom_navigation_bar.dart';
import 'package:of9_task_manager/ui/screens/forget_password_email_verify.dart';
import 'package:of9_task_manager/ui/screens/forget_password_verify_otp.dart';
import 'package:of9_task_manager/ui/screens/login_page.dart';
import 'package:of9_task_manager/ui/screens/reset_password.dart';
import 'package:of9_task_manager/ui/screens/sign_up.dart';
import 'package:of9_task_manager/ui/screens/splash_screen.dart';
import 'package:of9_task_manager/ui/screens/update_profile.dart';
//import 'package:of9_task_manager/ui/screens/splash_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey <NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),

        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold
          )
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            fixedSize: Size(220, 40),
            alignment: Alignment.center,
            //padding: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        navigationBarTheme: NavigationBarThemeData(
          height: 90,
          indicatorColor:Colors.lightGreen,
          iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 32)),
          indicatorShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: Colors.white,
          overlayColor: WidgetStateProperty.all(Colors.green),
          shadowColor: Colors.black,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //labelPadding: EdgeInsets.all(4.0),
          labelTextStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          elevation: 10,
        ),

        scaffoldBackgroundColor: Colors.grey.shade200,

      ),
      //home: const SplashScreen(),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/forget_password': (context) => const ForgetPasswordEmailVerify(),
        '/forget_password_otp': (context) => const ForgetPasswordVerifyOtp(),
        '/reset_password': (context) => const ResetPassword(),
        '/sign_up': (context) => const SignUp(),
        '/bottom_nav': (context) => const BottomNav(),
        '/add_new_task': (context) => const AddNewTask(),
        '/update_profile': (context) => const UpdateProfile(),
      },
    );
  }
}