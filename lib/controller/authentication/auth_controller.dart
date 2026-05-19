import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Service Imports
import '../../data/fireBaseAuthService/fireBase_Auth_Serivce.dart';
import '../../data/fireStoreDB/fireStore_DB_Service.dart';

// Screen Imports
import '../../screens/authentication/signIn_Screen.dart';
import '../../screens/home/main_home_screen.dart';
import '../../screens/admin/admin_home_screen.dart'; 

class AuthController extends GetxController {
  // --- Instances ---
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    signInOption: SignInOption.standard,
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Controllers ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); 
  

  // --- State ---
  RxBool isLoading = false.obs;
  var isPasswordHidden = true.obs; 
  var isConfirmPasswordHidden = true.obs;

  // --- Services ---
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // --- CONFIG ---
  final String adminEmail = "glitch@gmail.com";

  // --- HELPER: Email Regex Validation ---
  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  // --- LOGIN FUNCTION (Email/Password) ---
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.white);
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      await _authService.login(email, password);
      isLoading.value = false;
      
      if (email == adminEmail) {
        Get.offAll(() => const AdminHomeScreen());
      } else {
        Get.offAll(() => MainHomeScreen());
      }
      Get.snackbar("Success", "Login Successful", backgroundColor: Colors.white);

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar("Login Failed", e.message ?? "Unknown Error", backgroundColor: Colors.white);
    }
  }

  // --- SIGNUP FUNCTION (Email/Password) ---
  Future<void> signup() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.white);
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address", backgroundColor: Colors.white);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters", backgroundColor: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      UserCredential cred = await _authService.signup(email, password);
      await _firestoreService.saveUser(cred.user!.uid, email, name);
      
      isLoading.value = false;
      Get.snackbar("Success", "Account Created Successfully", backgroundColor: Colors.white);
      Get.offAll(() => MainHomeScreen());

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar("Signup Failed", e.message ?? "Unknown Error", backgroundColor: Colors.white);
    }
  }

  // --- GOOGLE SIGN-IN FUNCTION ---
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 1. Pehle check karein ke ye email Firestore mein hai ya nahi
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: googleUser.email)
          .get();

      // 2. Agar user nahi milta (Matlab register nahi kiya hua)
      if (userQuery.docs.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          "Account Not Found", 
          "This email doesn't have an account. Please sign up first.",
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );
        return; // Yahan se function ruk jayega, login nahi hoga
      }

      // 3. Agar user mil gaya, toh login process continue karein
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      isLoading.value = false;

      if (userCredential.user!.email == adminEmail) {
        Get.offAll(() => const AdminHomeScreen());
      } else {
        Get.offAll(() => MainHomeScreen());
      }

      Get.snackbar("Success", "Welcome Back!", backgroundColor: Colors.white);

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Google Sign-In failed", backgroundColor: Colors.white);
    }
  }
}