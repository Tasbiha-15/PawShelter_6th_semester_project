import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glitched/resources/assets/image_assets.dart';
import 'package:glitched/resources/colors/app_colors.dart';
import 'package:glitched/screens/onBoarding/intro_Screen.dart'; // Aapki main.dart wala exact path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Kisi controller par depend kiye bina direct fixed 3-second ka timer
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => IntroScreen()); // Aapki main.dart wali IntroScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.LightPink,
      body: Stack(
        children: [
          // 1. Bottom Curved Shape
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(width, height * 0.12),
              painter: BottomCurvePainter(),
            ),
          ),

          // 2. Main Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Centered Circular White Logo Container
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.DarkPink.withOpacity(0.12),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image(
                      image: const AssetImage(ImageAssets.logo),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // App Title
                Text(
                  "PawShelter",
                  style: GoogleFonts.jost(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff8D11CB),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Footer Subtitle / Branding text
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.jost(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: "Powered by "),
                      TextSpan(
                        text: "Team Glitch",
                        style: GoogleFonts.jost(
                          color: const Color(0xffFF5B37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.08),

                // Circular Progress Indicator / Spinner
                const SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff8D11CB)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.5, -size.height * 0.1, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    Paint paintTop = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Path pathTop = Path();
    pathTop.moveTo(0, size.height);
    pathTop.lineTo(0, size.height * 0.5);
    pathTop.quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width, size.height * 0.5);
    pathTop.lineTo(size.width, size.height);
    pathTop.close();
    canvas.drawPath(pathTop, paintTop);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}