import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import your HomeViewModel
import '../../model/cat_model.dart';
import '../../model/dog_model.dart';
import '../home/home_controller.dart';

class CategoryController extends GetxController {

  // Dependency Injection: Get data from HomeViewModel
  final HomeViewModel _homeViewModel = Get.find<HomeViewModel>();

  // --- STATE VARIABLES ---
  RxBool isCatTab = true.obs; // true = Cat, false = Dog
  RxString searchQuery = "".obs;

  // Filter Values (Sliders)
  RxDouble filterLifeSpan = 0.0.obs; // 0 means "All"
  RxDouble filterWeight = 0.0.obs;   // 0 means "All"

  // The Final List shown in UI
  RxList<dynamic> filteredList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with all cats
    applyFilters();
  }

  // --- ACTIONS ---

  void toggleTab(bool isCat) {
    isCatTab.value = isCat;
    // Reset filters when switching species (optional, but usually good UX)
    searchQuery.value = "";
    filterLifeSpan.value = 0.0;
    filterWeight.value = 0.0;
    applyFilters();
  }

  void onSearchChanged(String val) {
    searchQuery.value = val;
    applyFilters();
  }

  void onFilterChanged({double? lifeSpan, double? weight}) {
    if (lifeSpan != null) filterLifeSpan.value = lifeSpan;
    if (weight != null) filterWeight.value = weight;
    applyFilters();
  }

  void clearFilters() {
    filterLifeSpan.value = 0.0;
    filterWeight.value = 0.0;
    applyFilters();
    Get.back(); // Close bottom sheet
  }

  // --- MAIN FILTER LOGIC ---
  void applyFilters() {
    List<dynamic> sourceList = isCatTab.value
        ? _homeViewModel.catList
        : _homeViewModel.dogList;

    var temp = sourceList.where((pet) {

      // 1. SEARCH FILTER (By Breed Name)
      String name = "";
      if (isCatTab.value) {
        name = (pet as CatModel).breeds?.isNotEmpty == true
            ? pet.breeds![0].name ?? "" : "Cat";
      } else {
        name = (pet as DogModel).name ?? "";
      }

      bool matchesSearch = name.toLowerCase().contains(searchQuery.value.toLowerCase());

      // 2. SLIDER FILTERS (Parsing Strings)
      bool matchesLife = true;
      bool matchesWeight = true;

      if (filterLifeSpan.value > 0) {
        String lifeString = isCatTab.value
            ? ((pet as CatModel).breeds?.isNotEmpty == true ? pet.breeds![0].lifeSpan ?? "" : "")
            : (pet as DogModel).lifeSpan ?? "";
        matchesLife = _isValueInRange(lifeString, filterLifeSpan.value);
      }

      if (filterWeight.value > 0) {
        String weightString = isCatTab.value
            ? ((pet as CatModel).breeds?.isNotEmpty == true ? pet.breeds![0].weight?.metric ?? "" : "")
            : (pet as DogModel).weight?.metric ?? ""; // Assuming metric weight
        matchesWeight = _isValueInRange(weightString, filterWeight.value);
      }

      return matchesSearch && matchesLife && matchesWeight;
    }).toList();

    filteredList.assignAll(temp);
  }

  // --- HELPER: Parse "10 - 12 years" to check if Slider Value (e.g. 11) is inside ---
  bool _isValueInRange(String rawString, double sliderValue) {
    if (rawString.isEmpty) return true; // Keep if no data

    try {
      // Remove non-numeric chars except dash (e.g. "12 - 15 years" -> "12-15")
      String clean = rawString.replaceAll(RegExp(r'[^0-9-]'), '');
      List<String> parts = clean.split('-');

      double min = double.parse(parts[0]);
      double max = parts.length > 1 ? double.parse(parts[1]) : min;

      // Logic: If slider is 12, we show pets that live at least 12 years (or whatever logic you prefer)
      // Here: I will check if the slider value is within the range [min, max]
      // OR: You might want "Pets that live longer than X". Let's do "Within Range".
      // Let's allow a relaxed match: If slider is 12, match anything where 12 is inside range.
      return sliderValue >= min && sliderValue <= (max + 5); // +5 buffer
    } catch (e) {
      return true; // If parse fails, don't hide it
    }
  }
}