import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glitched/resources/assets/image_assets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/splash/splash__controller.dart';
import '../../resources/colors/app_colors.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController=Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [


          Center(
            child: Image(image: AssetImage(ImageAssets.logo))
          ),


        ],
      ),

    );
  }
}
