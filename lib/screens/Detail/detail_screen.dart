import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../controller/detail/detail_screen_controller.dart';
import '../../resources/colors/app_colors.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Initialize Controller
    final controller = Get.put(PetDetailController());

    return Scaffold(
      backgroundColor: AppColors.LightPink,
      body: Stack(
        children: [
          // --- 1. HERO IMAGE ---
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            child: SizedBox(
              height: height * 0.6,
              width: width,
              child: Image.network(
                controller.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.pets, size: 100, color: Colors.white),
                  );
                },
              ),
            ),
          ),

          // --- 2. GRADIENT OVERLAY ---
          Container(
            height: height * 0.6,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  AppColors.LightPink.withOpacity(0.8),
                  AppColors.LightPink
                ],
              ),
            ),
          ),

          // --- 3. SCROLLABLE CONTENT ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: width, // Pura width diya taake center align sahi ho
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Horizontal Center
                        children: [
                          SizedBox(height: height * 0.45),

                          // Name - Text Align Center
                          Text(
                            controller.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(
                              textStyle: const TextStyle(
                                color: AppColors.DarkPink,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.white),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Origin | Age - Text Align Center
                          Text(
                            "${controller.originOrGroup} | ${controller.lifeSpan} years",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Temperament Chips
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: controller.temperament.split(',').map((temp) {
                              return Chip(
                                label: Text(temp.trim()),
                                backgroundColor: Colors.white,
                                labelStyle: const TextStyle(color: AppColors.DarkPink),
                                side: const BorderSide(color: AppColors.DarkPink),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          // Description - Wrap in Align for safety
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                controller.description,
                                textAlign: TextAlign.center, // UI ko clean rakhne ke liye center behtar hai
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 4. BOTTOM ACTION BUTTONS ---
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              children: [
                // SAVE BUTTON
                MySaveButton(
                  height: 55,
                  width: 55,
                  controller: controller,
                  ontap: () => controller.toggleFavorite(), // Updated to Toggle
                ),

                const SizedBox(width: 15),

                // REQUEST BUTTON
                Expanded(
                  child: Obx(() => AdoptionRequestButton(
                        text: controller.isLoading.value ? "Sending..." : "Request Adoption",
                        isLoading: controller.isLoading.value,
                        onTap: () {
                          if (!controller.isLoading.value) {
                            controller.requestAdoption();
                          }
                        },
                      )),
                ),
              ],
            ),
          ),

          // --- 5. BACK BUTTON ---
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]),
                child: const Center(
                  child: Icon(Icons.arrow_back, color: AppColors.DarkPink, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Save Button Widget
class MySaveButton extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback ontap;
  final PetDetailController controller;

  const MySaveButton({
    super.key,
    required this.height,
    required this.width,
    required this.ontap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ]),
        child: Obx(() => Center(
              child: Icon(
                controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : AppColors.DarkPink,
                size: 28,
              ),
            )),
      ),
    );
  }
}

// Adoption Request Button Widget
class AdoptionRequestButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const AdoptionRequestButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.DarkPink,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}