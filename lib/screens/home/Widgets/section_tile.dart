import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resources/colors/app_colors.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;

  const SectionTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        title,
        style: GoogleFonts.jost(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.AppColor,
        ),
      ),
    );
  }
}