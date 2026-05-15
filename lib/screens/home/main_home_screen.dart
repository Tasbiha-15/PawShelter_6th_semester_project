import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controller/home/home_main_controller.dart';
import '../../resources/colors/app_colors.dart';


class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final mainViewModel = Get.put(MainHomeViewModel());

    return Scaffold(
      backgroundColor: AppColors.LightPink, // Main Background

      // Body: switches between the 3 screens
      body: Obx(() {
        return mainViewModel.screens[mainViewModel.viewIndex.value];
      }),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: Colors.white, // Clean white strip for the bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            onTabChange: mainViewModel.setIndex,
            selectedIndex: mainViewModel.viewIndex.value,

            // --- Theme Styling ---
            color: AppColors.MyGray,             // Inactive Icon Color
            activeColor: Colors.white,         // Active Icon/Text Color
            tabBackgroundColor: AppColors.DarkPink, // Active Bubble Color
            padding: const EdgeInsets.all(12), // Padding inside the bubble
            gap: 8,                            // Gap between icon and text

            // --- Tabs ---
            tabs: const [
              GButton(
                icon: Icons.pets, // Changed to 'pets' for a pet app feel
                text: "Home",
              ),
              GButton(
                icon: Icons.category_rounded,
                text: "Categories",
              ),
              GButton(
                icon: Icons.person_rounded,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}