import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/category/category_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/pawsAI/paws_ai_screen.dart';

// Import your actual screens here
   // New Screen

class MainHomeViewModel extends GetxController {

  // Current Tab Index
  RxInt viewIndex = 0.obs;

  // The 3 Main Screens
  final List<Widget> screens = [
     HomeScreen(),       // 1. Home Feed
     CategoryScreen(),      // 3. Paws AI
     PawsAiScreen(), // 2. Browse Categories/Breeds
     ProfileScreen()
  ];

  void setIndex(int index) {
    viewIndex.value = index;
  }
}