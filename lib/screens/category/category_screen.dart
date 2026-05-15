import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glitched/screens/category/widgets/bottom_widget.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../controller/filter/filter_screen.dart';
import '../../resources/colors/app_colors.dart';
import '../Detail/detail_screen.dart';
import '../home/Widgets/vertical_card.dart'; // Reuse your card!


class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            // --- 1. HEADER (Toggle) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Obx(() => Row(
                  children: [
                    _buildToggleButton("Cats", true, controller),
                    _buildToggleButton("Dogs", false, controller),
                  ],
                )),
              ),
            ),

            // --- 2. SEARCH & FILTER BAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: TextField(
                        onChanged: controller.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Search breed...",
                          hintStyle: GoogleFonts.jost(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: AppColors.DarkPink),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Filter Button
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        const FilterBottomSheet(),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.DarkPink,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. FILTERED LIST ---
            Expanded(
              child: Obx(() {
                if (controller.filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("No pets found", style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final pet = controller.filteredList[index];

                    // Normalize Data
                    String name = "";
                    String image = "";
                    String origin = "";

                    if (controller.isCatTab.value) {
                      name = (pet.breeds != null && pet.breeds!.isNotEmpty) ? pet.breeds![0].name! : "Cat";
                      image = pet.url ?? "";
                      origin = (pet.breeds != null && pet.breeds!.isNotEmpty) ? pet.breeds![0].origin! : "Unknown";
                    } else {
                      name = pet.name ?? "Dog";
                      image = pet.imageUrl;
                      origin = pet.breedGroup ?? "Good Boy";
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: VerticalPetCard(
                        imageUrl: image,
                        name: name,
                        info: origin,
                        shelterName: "Available for Adoption",
                        isCat: controller.isCatTab.value,
                        onTap: () {
                          // Navigate to Detail Screen
                          Get.to(() => const PetDetailScreen(), arguments: [pet, controller.isCatTab.value]);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isCat, CategoryController controller) {
    bool isSelected = controller.isCatTab.value == isCat;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.toggleTab(isCat),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.DarkPink : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}