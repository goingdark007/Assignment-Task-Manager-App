import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:of9_task_manager/ui/widgets/screen_background.dart';

import '../controller/auth_controller.dart';
import '../utils/asset_paths.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void>_moveToNextScreen() async{
    await Future.delayed(const Duration(seconds: 3));
    final bool isLoggedIn = await AuthController.isUserLoggedIn();
    if(isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/bottom_nav');
      } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');}
  }

  @override
  void initState () {
    super.initState();
    _moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ScreenBackground(
          child: Center(
            child: SvgPicture.asset(
                AssetPaths.logoSVG,
                height: 500,
                width: 500,
            ),
          )
      )

    );
  }

}