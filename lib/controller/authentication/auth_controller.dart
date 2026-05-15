import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Service Imports
import '../../data/fireBaseAuthService/fireBase_Auth_Serivce.dart';
import '../../data/fireStoreDB/fireStore_DB_Service.dart';

// Screen Imports
import '../../screens/authentication/signIn_Screen.dart';
import '../../screens/home/main_home_screen.dart';
import '../../screens/admin/admin_home_screen.dart'; // Make sure you created this file

class AuthController extends GetxController {

  // --- Controllers ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // Only for Signup

  // --- State ---
  RxBool isLoading = false.obs;

  // --- Services ---
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // --- CONFIG ---
  final String adminEmail = "glitch@gmail.com";

  // --- HELPER: Email Regex Validation ---
  bool _isValidEmail(String email) {
    // Simple regex for email validation
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  // --- LOGIN FUNCTION ---
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 1. Validate Empty Fields
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.white);
      return;
    }

    // 2. Validate Email Format
    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // 3. Attempt Login
      await _authService.login(email, password);

      isLoading.value = false;
      Get.snackbar("Success", "Login Successful", backgroundColor: Colors.white);

      // 4. ROUTING LOGIC (Admin vs User)
      if (email == adminEmail) {
        // Go to Admin Dashboard
        Get.offAll(() => const AdminHomeScreen());
      } else {
        // Go to Regular User Home
        Get.offAll(() => MainHomeScreen());
      }

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Failed", e.message ?? "Unknown Error", backgroundColor: Colors.white);
    }
  }

  // --- SIGNUP FUNCTION ---
  Future<void> signup() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 1. Validate Empty Fields
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.white);
      return;
    }

    // 2. Validate Email Format
    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.white);
      return;
    }

    // 3. Validate Password Length
    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", backgroundColor: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      // 4. Create Auth User
      UserCredential cred = await _authService.signup(email, password);

      // 5. Save Data to Firestore
      await _firestoreService.saveUser(
        cred.user!.uid,
        email,
        name,
      );

      isLoading.value = false;
      Get.snackbar("Success", "Account Created Successfully", backgroundColor: Colors.white);

      // 6. Navigate to Home (New users are regular users)
      Get.offAll(() => MainHomeScreen());

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar("Signup Failed", e.message ?? "Unknown Error", backgroundColor: Colors.white);
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    await _authService.signOut();
    // Clear controllers if needed
    emailController.clear();
    passwordController.clear();
    nameController.clear();

    Get.offAll(() => const SigninScreen());
  }
}