import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resources/colors/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final double height;
  final double width;

  const AuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.height = 55,
    this.width = double.infinity, // Full width by default
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.DarkPink, // Your Theme Color
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SpinKitThreeBounce(
              color: Colors.white,
              size: 20,
            )
                : Text(
              text,
              style: GoogleFonts.jost(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

