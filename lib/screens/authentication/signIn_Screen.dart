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
      backgroundColor: AppColors.LightPink,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.07),

              // 1. Logo Centered at Top
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.DarkPink.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(ImageAssets.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.045),

              // 2. Bold Text Left Aligned
              Text(
                "Login",
                style: GoogleFonts.jost(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppColors.DarkPink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Please sign in to continue",
                style: GoogleFonts.jost(
                  fontSize: 15,
                  color: AppColors.MyGray,
                ),
              ),
              SizedBox(height: height * 0.035),

              // 3. Text Fields
              _buildTextField(
                controller: controller.emailController,
                hint: "Email",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              
              // Password field updated with GetX controller state
              _buildTextField(
                controller: controller.passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: controller.isPasswordHidden, // Dynamic parameter
                onSuffixIconPressed: () {
                  controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
                },
              ),

              SizedBox(height: height * 0.035),

              // 4. Auth Button (Email Login)
              Obx(() => AuthButton(
                    text: "Login",
                    isLoading: controller.isLoading.value,
                    onTap: () => controller.login(),
                  )),

              SizedBox(height: height * 0.025),

              // Divider with OR
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.MyGray.withOpacity(0.35),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "OR",
                      style: GoogleFonts.jost(
                        color: AppColors.MyGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.MyGray.withOpacity(0.35),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.025),

              // Google Sign-In Button
            GestureDetector(
  onTap: () => controller.signInWithGoogle(),
  child: Container(
    height: 55,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 📷 Your Local Google Logo Asset
        Image.asset(
          'assets/images/google_logo.png', // 🔥 Aapki file ka exact naam aur path
          height: 24,
          width: 24,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12), 
        Text(
          "Sign in with Google",
          style: GoogleFonts.jost(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
),

              SizedBox(height: height * 0.04),

              // 5. Navigate to Signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.jost(color: AppColors.MyGray),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.emailController.clear();
                      controller.passwordController.clear();
                      Get.to(() => const SignUpScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.jost(
                        fontWeight: FontWeight.bold,
                        color: AppColors.DarkPink,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  // Optimized custom function supporting GetX visibility tracking cleanly
  // Ab saari functionality left side wale lock icon par hi shift kar di hai
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    RxBool? obscureText, 
    VoidCallback? onSuffixIconPressed, // Yeh click ab hum lock icon par use karenge
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
      child: isPassword && obscureText != null
          ? Obx(() => TextField(
                controller: controller,
                obscureText: obscureText.value,
                decoration: InputDecoration(
                  hintText: hint,
                  // Left side par lock ka icon click ho sakega aur status ke mutabik change hoga
                  prefixIcon: IconButton(
                    icon: Icon(
                      obscureText.value ? Icons.lock_outline : Icons.lock_open,
                      color: AppColors.TfColor,
                    ),
                    onPressed: onSuffixIconPressed, // Lock icon dabane se show/hide hoga
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  hintStyle: TextStyle(color: AppColors.TfColor),
                  suffixIcon: null, // Right side wala eye icon bilkul khatam!
                ),
              ))
          : TextField(
              controller: controller,
              obscureText: false,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon, color: AppColors.TfColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintStyle: TextStyle(color: AppColors.TfColor),
              ),
            ),
    );
  }
}