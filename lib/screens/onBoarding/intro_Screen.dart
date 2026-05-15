import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glitched/screens/authentication/signIn_Screen.dart';
import 'package:glitched/screens/onBoarding/widgets/my_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/onBoarding/OnBoarding_controller.dart';
import '../../resources/colors/app_colors.dart';
import 'onBoardingScreen2.dart';
import 'onBoardingScreen3.dart';
import 'onBoardingScreen_1.dart';



class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  // Injecting the controller we discussed earlier
  final onBoardingModel = Get.put(OnBoardingViewModel());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.LightPink, // Global background color
      body: Stack(
        children: [

          PageView(
            controller: onBoardingModel.controller,
            onPageChanged: (value) {
              // If index is 2 (last page), set isLast to true
              onBoardingModel.makeLast(value == 2);
            },
            children: const [
              Onboarding1Screen(),
              Onboarding2Screen(),
              Onboarding3Screen(),
            ],
          ),

          // 2. The Page Indicator (Dots)
          // Moved slightly lower to sit between image and text/button area
          Container(
            alignment: const Alignment(0, 0.60),
            child: SmoothPageIndicator(
              controller: onBoardingModel.controller,
              count: 3,
              effect: WormEffect(
                dotColor: Colors.white, // Inactive dot
                activeDotColor: AppColors.DarkPink, // Active dot matches button
                dotWidth: 12,
                dotHeight: 12,
                paintStyle: PaintingStyle.fill,
              ),
            ),
          ),

          // 3. The Button
          Container(
            alignment: const Alignment(0, 0.85),
            child: Obx(() {
              return onBoardingModel.isLast.value
                  ? MyButton(
                label: "Get Started",
                height: height * 0.07,
                width: width * 0.8,
                onTap: () {
                  // Navigation to SignInScreen
                  Get.offAll(() => const SigninScreen());
                  Get.delete<OnBoardingViewModel>();
                },
              )
                  : MyButton(
                label: "Next",
                height: height * 0.07,
                width: width * 0.8,
                onTap: () => onBoardingModel.controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}