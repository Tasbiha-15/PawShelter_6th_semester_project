import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/admin/admin_controller.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/assets/image_assets.dart'; // Ensure you import your assets

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          // --- 1. STYLISH HEADER (Matches Profile Screen) ---
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)
            ),
            child: Container(
              height: height * 0.35,
              width: width,
              color: AppColors.LightPink,
              child: Stack(
                children: [
                  // A. Center Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.05),

                        // Admin Logo
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              ImageAssets.logo,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Title
                        Text(
                          "Admin Dashboard",
                          style: GoogleFonts.oswald(
                            textStyle: const TextStyle(
                              color: AppColors.DarkPink,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Subtitle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Manage Adoption by",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Text(
                              " Team Glitch",
                              style: GoogleFonts.oswald(
                                textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // B. Logout Button (Top Right)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        // Confirm Dialog before logout
                        Get.defaultDialog(
                            title: "Logout",
                            titlePadding: const EdgeInsets.only(top: 20),
                            titleStyle: GoogleFonts.oswald(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.DarkPink,
                            ),
                            backgroundColor: Colors.white,
                            radius: 20,
                            contentPadding: const EdgeInsets.all(20),
                            middleText: "Are you sure you want to logout?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            confirmTextColor: Colors.white,
                            buttonColor: AppColors.DarkPink,
                            onConfirm: () {
                              Get.back(); // Close dialog
                              controller.logout(); // Call logout
                            }
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout, color: AppColors.DarkPink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 2. TITLE SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pending Requests",
                style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                    color: AppColors.AppColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // --- 3. BODY (List of Requests) ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
              }

              if (controller.pendingRequests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("No pending requests", style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                itemCount: controller.pendingRequests.length,
                itemBuilder: (context, index) {
                  final req = controller.pendingRequests[index];

                  return _buildRequestCard(
                    context,
                    req,
                    onApprove: () => controller.approveRequest(req['requestId']),
                    onReject: () => controller.rejectRequest(req['requestId']),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- HELPER: Request Card Widget ---
  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> req, {required VoidCallback onApprove, required VoidCallback onReject}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Pet Image & Info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  req['petImage'] ?? "",
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, _) => Container(
                    height: 60, width: 60, color: Colors.grey[200], child: const Icon(Icons.pets, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      req['petName'] ?? "Unknown Pet",
                      style: GoogleFonts.jost(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.AppColor),
                    ),
                    Text(
                      "User: ${req['userEmail'] ?? 'Unknown'}",
                      style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Status: Pending",
                      style: GoogleFonts.montserrat(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // 2. Action Buttons
          Row(
            children: [
              // Reject Button
              Expanded(
                child: GestureDetector(
                  onTap: onReject,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Reject", style: GoogleFonts.jost(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Approve Button
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 5, offset: const Offset(0,2))
                        ]
                    ),
                    child: Center(
                      child: Text("Approve", style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}