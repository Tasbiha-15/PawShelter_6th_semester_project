import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glitched/screens/authentication/signIn_Screen.dart'; // Verify import path

import '../../data/fireStoreDB/fireStore_DB_Service.dart';
import '../../data/responses/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 Yeh lazmi add karo
import 'package:flutter/material.dart'; // Center aur CircularProgressIndicator ke liye
import '../../../resources/colors/app_colors.dart'; // Apni colors file ka sahi relative path check kar lena

class UserProfileController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Info
  RxString userName = "Loading...".obs;
  RxString email = "".obs;

  // Tabs Logic (True = Favorites, False = Requests)
  RxBool isFavoritesTab = true.obs;

  // Data Lists
  RxList<Map<String, dynamic>> savedPets = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> userRequests = <Map<String, dynamic>>[].obs;

  // Status
  Rx<Status> status = Status.LOADING.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    bindStreams();
  }

  // 1. Load Basic Info
  Future<void> loadUserProfile() async {
    email.value = _firestoreService.currentUserEmail;
    String name = await _firestoreService.getUserName();
    userName.value = name;
  }

  // 2. Listen to Database Changes (Both Streams)
  void bindStreams() {
    status.value = Status.LOADING;

    // Bind Favorites
    _firestoreService.getFavoritePetsStream().listen((pets) {
      savedPets.assignAll(pets); // Force update
      status.value = Status.Completed;
    });

    // Bind Requests (FIXED: Added assignAll)
    _firestoreService.getUserRequestsStream().listen((requests) {
      userRequests.assignAll(requests); // Force update

      // If we are currently viewing requests, force a refresh
      if (!isFavoritesTab.value) {
        userRequests.refresh();
      }
    });
  }

  // 3. Delete Action (FIXED: Instant Update)
  Future<void> deleteItem(String id) async {
    if (isFavoritesTab.value) {
      // --- INSTANT UPDATE FOR FAVORITES ---
      savedPets.removeWhere((item) => item['petId'] == id);
      savedPets.refresh();

      await _firestoreService.deleteFavoritePet(id);
    } else {
      // --- INSTANT UPDATE FOR REQUESTS ---
      // 1. Remove from screen immediately
      userRequests.removeWhere((item) => item['requestId'] == id);
      userRequests.refresh();

      // 2. Delete from DB
      await _firestoreService.deleteRequest(id);
    }
  }

  // 4. Logout Action
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => const SigninScreen());
  }

  Future<void> sendContactDetails({
    required String requestId,
    required String phone,
    required String address,
    required double totalAmount,
  }) async {
    try {
      // ⏳ Loader show karne ke liye (const ko Center ke andar move kiya hai)
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors
                .DarkPink, // Agar AppColors import na ho raha ho toh isko Colors.pink kar sakti ho
          ),
        ),
        barrierDismissible: false,
      );

      // 📝 Firestore mein specific request document ko update karna
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({
        'phone': phone,
        'deliveryAddress': address,
        'totalBill': totalAmount,
        'detailsSubmitted':
            true, // 🔥 Profile screen automatically update ho jayegi
        'orderConfirmedAt': FieldValue.serverTimestamp(),
      });

      Get.back(); // Loader dialog ko close karne ke liye
    } catch (e) {
      Get.back(); // Error ki surat mein bhi loader band ho
      Get.snackbar(
        "Error",
        "Failed to update details: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }
}
