
import 'dart:async';

import 'package:get/get.dart';

import '../../services/splash_services.dart';
import '../../screens/authentication/signIn_Screen.dart';
import '../../screens/onBoarding/intro_Screen.dart';


class SplashController extends GetxController
{
  final splashService=SplashServices();



 @override
  void onInit() {
    super.onInit();
    
    // Purani service ko bypass karke direct perfect 3-second ka timer lagaya hai
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => IntroScreen()); // Aapki Onboarding/Intro screen par bhej dega
    });
  }
}