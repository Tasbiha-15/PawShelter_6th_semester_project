import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/filter/filter_screen.dart';
import '../../../resources/colors/app_colors.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Filter Options", style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.DarkPink)),
              TextButton(
                onPressed: () => controller.clearFilters(),
                child: Text("Reset", style: GoogleFonts.jost(color: Colors.grey)),
              )
            ],
          ),

          const SizedBox(height: 20),

          // 1. Life Span Slider
          Text("Life Span (Years)", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          Obx(() => Column(
            children: [
              Slider(
                value: controller.filterLifeSpan.value,
                min: 0,
                max: 20, // Max dog/cat age roughly
                divisions: 20,
                activeColor: AppColors.DarkPink,
                inactiveColor: Colors.grey[200],
                label: controller.filterLifeSpan.value == 0 ? "All" : "${controller.filterLifeSpan.value.toInt()} years",
                onChanged: (val) => controller.onFilterChanged(lifeSpan: val),
              ),
              Text(
                controller.filterLifeSpan.value == 0 ? "Any Age" : "Approx. ${controller.filterLifeSpan.value.toInt()} years",
                style: const TextStyle(color: Colors.grey),
              )
            ],
          )),

          const SizedBox(height: 20),

          // 2. Weight Slider
          Text("Weight (Kg)", style: GoogleFonts.jost(fontWeight: FontWeight.bold)),
          Obx(() => Column(
            children: [
              Slider(
                value: controller.filterWeight.value,
                min: 0,
                max: 40,
                divisions: 40,
                activeColor: AppColors.DarkPink,
                inactiveColor: Colors.grey[200],
                label: controller.filterWeight.value == 0 ? "All" : "${controller.filterWeight.value.toInt()} kg",
                onChanged: (val) => controller.onFilterChanged(weight: val),
              ),
              Text(
                controller.filterWeight.value == 0 ? "Any Weight" : "Approx. ${controller.filterWeight.value.toInt()} kg",
                style: const TextStyle(color: Colors.grey),
              )
            ],
          )),

          const SizedBox(height: 30),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.DarkPink,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Apply Filters", style: GoogleFonts.jost(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}