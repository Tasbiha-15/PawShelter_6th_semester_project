import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';

class Onboarding2Screen extends StatelessWidget {
  const Onboarding2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.LightPink,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Center(
            child: Container(
              height: height * 0.4,
              width: width * 0.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.on2),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          SizedBox(height: height * 0.05),

          // Quote Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Every pet deserves a\nloving home.",
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
                textStyle: const TextStyle(
                  color: AppColors.DarkPink,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ),
          ),

          SizedBox(height: height * 0.1),
        ],
      ),
    );
  }
}