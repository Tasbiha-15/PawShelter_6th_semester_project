import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';

class Onboarding1Screen extends StatelessWidget {
  const Onboarding1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.LightPink, // Pink Background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Center(
            child: Container(
              height: height * 0.4, // Large image
              width: width * 0.8,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.on1),
                  fit: BoxFit.contain, // Contain ensures the whole pet is visible
                ),
              ),
            ),
          ),

          SizedBox(height: height * 0.05),

          // Quote Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Find a companion that\nfits your life.",
              textAlign: TextAlign.center,
              style: GoogleFonts.jost(
                textStyle: const TextStyle(
                  color: AppColors.DarkPink, // Using your Dark Pink for text
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ),
          ),

          // Spacer to push content up slightly from the button
          SizedBox(height: height * 0.1),
        ],
      ),
    );
  }
}