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

    // Initialize Controller properly
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
              child: Obx(() {
                return Image.network(
                  controller.imageUrl.value, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.pets, size: 100, color: Colors.white),
                    );
                  },
                );
              }),
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
              width: width,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: height * 0.45),

                          // Name
                          Text(
                            controller.name.value,
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

                          // Location | Age
                          Text(
                            controller.localizedLocation.value + " | " + controller.lifeSpan.value + " years",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Donor Label Text
                          Text(
                            "Posted by: " + controller.finalDonorName.value,
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: AppColors.DarkPink,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Temperament Chips
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: controller.temperament.value.split(',').map((temp) {
                              return Chip(
                                label: Text(temp.trim()),
                                backgroundColor: Colors.white,
                                labelStyle: const TextStyle(color: AppColors.DarkPink, fontSize: 12),
                                side: const BorderSide(color: AppColors.DarkPink),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 15),

                          // Description
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                controller.description.value,
                                textAlign: TextAlign.center,
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

                          const SizedBox(height: 15),

                          // --- P2P CASH ON DELIVERY CARD ---
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.DarkPink.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.local_shipping_rounded, color: AppColors.DarkPink, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Adoption & Delivery Details',
                                      style: GoogleFonts.jost(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.DarkPink,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: AppColors.LightPink),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Adoption Price:', style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 13)),
                                    Text('Free (Rescue)', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Vet Check & Courier (COD):', style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 13)),
                                    Text('Rs. ' + controller.codAmount.value.toStringAsFixed(0), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13)),
                                  ],
                                ),
                              ],
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
                Obx(() => MySaveButton(
                  height: 55,
                  width: 55,
                  isFav: controller.isFavorite.value,
                  ontap: () => controller.toggleFavorite(),
                )),

                const SizedBox(width: 15),

                // REQUEST ADOPTION BUTTON
                Expanded(
                  child: Obx(() => AdoptionRequestButton(
                    text: controller.isLoading.value ? "Sending Request..." : "Proceed to Adoption",
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

class MySaveButton extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback ontap;
  final bool isFav;

  const MySaveButton({
    super.key,
    required this.height,
    required this.width,
    required this.ontap,
    required this.isFav,
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
        child: Center(
          child: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : AppColors.DarkPink,
            size: 28,
          ),
        ),
      ),
    );
  }
}

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
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: isLoading
              ? const SpinKitThreeBounce(color: Colors.white, size: 20.0)
              : Text(
                  text,
                  style: GoogleFonts.jost(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
