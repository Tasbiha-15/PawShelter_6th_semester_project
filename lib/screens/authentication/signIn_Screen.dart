import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glitched/screens/authentication/signUp_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/authentication/auth_controller.dart';
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';
import 'Widget/auth_button.dart';


class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.LightPink, // Your Light Pink BG
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
            children: [
              // 1. Logo Centered at Top
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),

              // 2. Bold Text Left Aligned
              Text(
                "Login",
                style: GoogleFonts.jost(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.DarkPink,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Please sign in to continue",
                style: GoogleFonts.jost(
                  fontSize: 16,
                  color: AppColors.MyGray,
                ),
              ),
              SizedBox(height: height * 0.04),

              // 3. Text Fields
              _buildTextField(
                controller: controller.emailController,
                hint: "Email",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              SizedBox(height: height * 0.05),

              // 4. Auth Button
              Obx(() => AuthButton(
                text: "Login",
                isLoading: controller.isLoading.value,
                onTap: () => controller.login(),
              )),

              // 5. Navigate to Signup
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: (){
                      controller.emailController.clear();
                      controller.passwordController.clear();
                      Get.to(() => const SignUpScreen());
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.DarkPink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for neat TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.TfColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          hintStyle: TextStyle(color: AppColors.TfColor),
        ),
      ),
    );
  }
}