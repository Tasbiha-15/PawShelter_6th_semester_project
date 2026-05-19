import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add for user tracking
import 'package:cloud_firestore/cloud_firestore.dart'; // Add for real-time tracking
import '../../controller/profile/profile_controller.dart';
import '../../data/responses/status.dart';
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';
import '../home/Widgets/vertical_card.dart'; 
import '../../screens/Detail/checkout_screen.dart';
import 'add_pet_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(UserProfileController());

    // Reactive integer to keep tracking of the 3 tabs flawlessly
    final RxInt selectedTab = 0.obs; 

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            child: Container(
              height: height * 0.32, width: width, color: AppColors.LightPink,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.03),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: ClipOval(child: Image.asset(ImageAssets.logo, height: 80, width: 80, fit: BoxFit.cover)),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Text(controller.userName.value, style: GoogleFonts.oswald(textStyle: const TextStyle(color: AppColors.DarkPink, fontSize: 26, fontWeight: FontWeight.bold)))),
                        Obx(() => Text(controller.email.value, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500)))),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 45, right: 20,
                    child: IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Logout",
                            titlePadding: const EdgeInsets.only(top: 20),
                            titleStyle: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.DarkPink),
                            backgroundColor: Colors.white,
                            radius: 20,
                            contentPadding: const EdgeInsets.all(20),
                            middleText: "Are you sure you want to logout?",
                            textConfirm: "Yes", textCancel: "No",
                            confirmTextColor: Colors.white, buttonColor: AppColors.DarkPink,
                            onConfirm: () { Get.back(); controller.signOut(); }
                        );
                      },
                      icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle), child: const Icon(Icons.logout, color: AppColors.DarkPink)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),

          // THREE TAB SWITCHER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 48, 
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
              child: Row(
                children: [
                  _buildTabButton("Favorites", 0, selectedTab, () => controller.isFavoritesTab.value = true),
                  _buildTabButton("Requests", 1, selectedTab, () => controller.isFavoritesTab.value = false),
                  _buildTabButton("My Listings", 2, selectedTab, () {
                    controller.isFavoritesTab.value = false;
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // DYNAMIC BUTTON: Appears only when "My Listings" tab is active!
          Obx(() {
            if (selectedTab.value == 2) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: GestureDetector(
                  onTap: () => Get.to(() => const AddPetScreen()),
                  child: Container(
                    height: 50,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.DarkPink,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: AppColors.DarkPink.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text("Add New Pet for Donation", style: GoogleFonts.jost(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // CORE CONTENT LIST VIEW + REALTIME FIREBASE FOR "MY LISTINGS"
          Expanded(
            child: Obx(() {
              if (controller.status.value == Status.LOADING) {
                return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
              }

              // Agar user ne "My Listings" tab chalaya hai, tou direct Firestore Stream chalao!
              if (selectedTab.value == 2) {
                String currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pet_requests')
                      .where('donorId', isEqualTo: currentUid) // Sirf isi login user ka data filter hoga
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
                    }
                    
                    final docs = snapshot.data?.docs ?? [];
                    
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets_outlined, size: 50, color: Colors.grey[400]),
                            const SizedBox(height: 10),
                            Text("You haven't listed any pets yet!", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final docId = docs[index].id;
                        final item = docs[index].data() as Map<String, dynamic>;
                        
                        String status = (item['status'] ?? 'pending').toString().toLowerCase();
                        String name = item['name'] ?? 'Pet';
                        String image = item['image'] ?? '';
                        String breed = item['breed'] ?? 'Local';

                        // Dynamic Colors & Text setup based on admin response status
                        String displayStatus = "PENDING";
                        if (status == 'approved') displayStatus = "APPROVED";
                        if (status == 'rejected') displayStatus = "REJECTED";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Slidable(
                            key: ValueKey(docId),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    // Live database document delete command from slider
                                    try {
                                      await FirebaseFirestore.instance.collection('pet_requests').doc(docId).delete();
                                    } catch(e) {}
                                  },
                                  backgroundColor: Colors.redAccent, 
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_outline, 
                                  label: 'Cancel',
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ],
                            ),
                            child: VerticalPetCard(
                              imageUrl: image, 
                              name: name, 
                              info: "Age: ${item['age'] ?? 'N/A'} | Breed: $breed",
                              shelterName: "Status: $displayStatus", // Dynamic logic mapping
                              isCat: item['isCat'] ?? true, 
                              onTap: () {
                                // User can tap to view their submitted details in read-only mode if required
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              // --- PURAANI LOGIC FOR FAVORITES & REQUESTS (UNTOUCHED) ---
              List<Map<String, dynamic>> currentList = [];
              if (selectedTab.value == 0) currentList = controller.savedPets;
              if (selectedTab.value == 1) currentList = controller.userRequests;

              if (currentList.isEmpty) {
                IconData emptyIcon = Icons.favorite_border;
                String emptyMsg = "No favorites yet!";
                if (selectedTab.value == 1) { emptyIcon = Icons.history; emptyMsg = "No requests sent yet!"; }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(emptyIcon, size: 50, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(emptyMsg, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  final item = currentList[index];

                  final String deleteId = selectedTab.value == 0 ? (item['petId'] ?? index.toString()) : (item['requestId'] ?? index.toString());
                  final String name = selectedTab.value == 0 ? (item['name'] ?? 'Pet') : (item['petName'] ?? item['name'] ?? 'Pet');
                  final String image = selectedTab.value == 0 ? (item['image'] ?? '') : (item['petImage'] ?? item['image'] ?? '');
                  final String origin = selectedTab.value == 0 ? (item['origin'] ?? 'Local') : (item['petOrigin'] ?? item['breed'] ?? 'Local');
                  
                  String status = (item['status'] ?? 'pending').toString().toLowerCase();
                  String requestId = (item['requestId'] ?? '').toString();
                  bool detailsSubmitted = item['detailsSubmitted'] ?? false;

                  String displayStatus = 'Available';

                  if (selectedTab.value == 0) {
                    displayStatus = "Saved Pet";
                  } else if (selectedTab.value == 1) {
                    if (status == 'accepted') {
                      displayStatus = !detailsSubmitted ? "ACCEPTED (Tap to confirm)" : "ORDER CONFIRMED";
                    } else if (status == 'rejected') {
                      displayStatus = "REJECTED";
                    } else {
                      displayStatus = "PENDING";
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Slidable(
                      key: ValueKey(deleteId),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              controller.deleteItem(deleteId);
                            },
                            backgroundColor: Colors.redAccent, 
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline, 
                            label: selectedTab.value == 0 ? 'Remove' : 'Cancel',
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ],
                      ),
                      child: VerticalPetCard(
                        imageUrl: image, 
                        name: name, 
                        info: origin,
                        shelterName: displayStatus, 
                        isCat: item['isCat'] ?? true, 
                        onTap: () {
                          if (selectedTab.value == 1 && status == 'accepted' && !detailsSubmitted) {
                            Get.to(() => CheckoutScreen(
                              requestId: requestId, 
                              controller: controller,
                              itemData: item,
                            ));
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper Widget
  Widget _buildTabButton(String text, int index, RxInt selectedTab, VoidCallback oldCallback) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedTab.value = index;
          oldCallback();
        },
        child: Obx(() => Container(
          decoration: BoxDecoration(
            color: selectedTab.value == index ? AppColors.DarkPink : Colors.transparent, 
            borderRadius: BorderRadius.circular(25)
          ),
          child: Center(
            child: Text(
              text, 
              style: GoogleFonts.jost(
                fontSize: 13, 
                fontWeight: FontWeight.bold, 
                color: selectedTab.value == index ? Colors.white : Colors.grey
              )
            ),
          ),
        )),
      ),
    );
  }
}