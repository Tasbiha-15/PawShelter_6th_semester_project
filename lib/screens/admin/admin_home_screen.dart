import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Real-time updates ke liye

import '../../controller/admin/admin_controller.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/assets/image_assets.dart';
import 'admin_pet_detail_Screen.dart '; // Detail screen for pet verification
import '../../pet_image_helper.dart'; // Apne folder structure k mutabiq path check kar lena

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Reactive integer for flawless 2-tab switching
    final RxInt selectedTab = 0.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- 1. STYLISH HEADER (Matches Profile Screen) ---
          ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
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
                              Get.back();
                              controller.logout();
                            });
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.logout, color: AppColors.DarkPink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // --- NEW IMPROVEMENT: TWO TAB SWITCHER (Premium Minimalist Look) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildTabButton("Adoption Requests", 0, selectedTab),
                  _buildTabButton("Donor Listings", 1, selectedTab),
                ],
              ),
            ),
          ),

          // --- 2. DYNAMIC TITLE SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => Text(
                    selectedTab.value == 0
                        ? "Pending Adoptions"
                        : "Pending Donor Approvals",
                    style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                        color: AppColors.AppColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ),

          // --- 3. BODY (List Views depending on Active Tab Index) ---
          Expanded(
            child: Obx(() {
              // --- TAB 0: ADOPTION REQUESTS LOGIC (UNTOUCHED) ---
              if (selectedTab.value == 0) {
                if (controller.isLoading.value) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.DarkPink));
                }

                if (controller.pendingRequests.isEmpty) {
                  return _buildEmptyState(
                      Icons.inbox_outlined, "No pending adoption requests");
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  itemCount: controller.pendingRequests.length,
                  itemBuilder: (context, index) {
                    final req = controller.pendingRequests[index];
                    return _buildRequestCard(
                      context,
                      req,
                      subtitleText: "User: ${req['userEmail'] ?? 'Unknown'}",
                      onApprove: () =>
                          controller.approveRequest(req['requestId']),
                      onReject: () =>
                          controller.rejectRequest(req['requestId']),
                    );
                  },
                );
              }

              // --- TAB 1: NEW LIVE DONOR LISTINGS FROM FIRESTORE ---
              else {
                return // --- TAB 1: LIVE DONOR LISTINGS FROM FIRESTORE ---
                    StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pet_requests')
                      .orderBy(
                          'status') // Isse pending wale pehle aayenge, approved baad mein
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.DarkPink));
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return _buildEmptyState(
                          Icons.pets_outlined, "No pets added yet");
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final docId = docs[index].id;
                        final petData =
                            docs[index].data() as Map<String, dynamic>;
                        String currentStatus = petData['status'] ?? 'pending';

                        // Dynamic Status Color
                        Color statusColor = Colors.orange;
                        if (currentStatus == 'approved')
                          statusColor = Colors.green;
                        if (currentStatus == 'rejected')
                          statusColor = Colors.red;

                        return GestureDetector(
                          onTap: () {
                            // Click karne par Admin ko Detail Screen par bhejenge jahan saari info hogi
                            Get.to(() => AdminPetDetailScreen(
                                docId: docId, petData: petData));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Row(
                              children: [
                                // FIX: Image Link ki jagah actual image show hogi yahan
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: buildPetImage(petData['image'] ?? '',
                                      size: 70),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        petData['name'] ?? 'Unknown Pet',
                                        style: GoogleFonts.jost(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.AppColor),
                                      ),
                                      Text(
                                        "Breed: ${petData['breed'] ?? 'Local'} | City: ${petData['city'] ?? 'N/A'}",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 5),
                                      // Status Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: statusColor),
                                        ),
                                        child: Text(
                                          currentStatus.toUpperCase(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 10,
                                              color: statusColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  // --- HELPER: Tab Buttons ---
  Widget _buildTabButton(String text, int index, RxInt selectedTab) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedTab.value = index,
        child: Obx(() => Container(
              decoration: BoxDecoration(
                color: selectedTab.value == index
                    ? AppColors.DarkPink
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.jost(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: selectedTab.value == index
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  // --- HELPER: Empty State View ---
  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(message, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  // --- HELPER: Request Card Widget ---
  Widget _buildRequestCard(
    BuildContext context,
    Map<String, dynamic> req, {
    required String subtitleText,
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
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
                    height: 60,
                    width: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets, color: Colors.grey),
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
                      style: GoogleFonts.jost(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.AppColor),
                    ),
                    Text(
                      subtitleText,
                      style: GoogleFonts.montserrat(
                          fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Status: Pending",
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600),
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
                      child: Text("Reject",
                          style: GoogleFonts.jost(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600)),
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
                        BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Center(
                      child: Text("Approve",
                          style: GoogleFonts.jost(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
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
