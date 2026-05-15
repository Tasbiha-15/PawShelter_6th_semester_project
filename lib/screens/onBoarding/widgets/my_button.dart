import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../resources/colors/app_colors.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final double width;
  final bool isHome; // Kept this if you use it elsewhere
  final bool isLoading;

  const MyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 43,
    this.width = 300,
    this.isHome = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Slightly rounder for a friendly pet app look
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            // Use DarkPink for main buttons
            color: isHome ? AppColors.homeButtonColor : AppColors.DarkPink,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.8),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Loading...",
                  style: GoogleFonts.jost(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
                : FittedBox(
              fit: BoxFit.contain,
              child: Text(
                label,
                style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}