
import 'dart:async';


import 'package:get/get.dart';
import 'package:glitched/screens/home/main_home_screen.dart';
import 'package:glitched/screens/onBoarding/intro_Screen.dart';

import '../screens/onBoarding/onBoardingScreen_1.dart';
import '../user_prefernce/user_preference.dart';


class SplashServices {
  final userPref = UserPreference();

  void isLogin() async {
    final isFirst = await userPref.isFirstLogin();

    if (isFirst==true)
    {
      await userPref.setFirstLoginDone();

      Timer(const Duration(seconds: 3),
              ()=>Get.offAll(()=>IntroScreen())
      );


    } else
    {
      Timer(const Duration(seconds: 3),
              ()=>Get.offAll(()=>MainHomeScreen())
      );

    }
  }
}
