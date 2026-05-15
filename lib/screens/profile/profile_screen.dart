import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/profile/profile_controller.dart';
import '../../data/responses/status.dart';
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';
import '../home/Widgets/vertical_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(UserProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER (Same as before)
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            child: Container(
              height: height * 0.35, width: width, color: AppColors.LightPink,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.05),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: ClipOval(child: Image.asset(ImageAssets.logo, height: 90, width: 90, fit: BoxFit.cover)),
                        ),
                        const SizedBox(height: 15),
                        Obx(() => Text(controller.userName.value, style: GoogleFonts.oswald(textStyle: const TextStyle(color: AppColors.DarkPink, fontSize: 28, fontWeight: FontWeight.bold)))),
                        Obx(() => Text(controller.email.value, style: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500)))),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 50, right: 20,
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
          const SizedBox(height: 20),

          // TAB SWITCHER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.isFavoritesTab.value = true,
                      child: Container(
                        decoration: BoxDecoration(color: controller.isFavoritesTab.value ? AppColors.DarkPink : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                        child: Center(child: Text("Favorites", style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: controller.isFavoritesTab.value ? Colors.white : Colors.grey))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.isFavoritesTab.value = false,
                      child: Container(
                        decoration: BoxDecoration(color: !controller.isFavoritesTab.value ? AppColors.DarkPink : Colors.transparent, borderRadius: BorderRadius.circular(25)),
                        child: Center(child: Text("Requests", style: GoogleFonts.jost(fontSize: 16, fontWeight: FontWeight.bold, color: !controller.isFavoritesTab.value ? Colors.white : Colors.grey))),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
          const SizedBox(height: 15),

          // LIST VIEW
          Expanded(
            child: Obx(() {
              if (controller.status.value == Status.LOADING) {
                return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
              }

              final List<Map<String, dynamic>> currentList = controller.isFavoritesTab.value ? controller.savedPets : controller.userRequests;

              if (currentList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(controller.isFavoritesTab.value ? Icons.favorite_border : Icons.history, size: 50, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(controller.isFavoritesTab.value ? "No favorites yet!" : "No requests sent yet!", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  final item = currentList[index];

                  // Handle different ID fields
                  final String deleteId = controller.isFavoritesTab.value ? item['petId'] : item['requestId'];
                  final String displayStatus = controller.isFavoritesTab.value ? "Saved Pet" : "Status: ${(item['status'] ?? 'pending').toString().toUpperCase()}";
                  final String name = controller.isFavoritesTab.value ? item['name'] : item['petName'];
                  final String image = controller.isFavoritesTab.value ? item['image'] : item['petImage'];
                  final String origin = controller.isFavoritesTab.value ? item['origin'] : item['petOrigin'];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Slidable(
                      key: ValueKey(deleteId),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            onPressed: (context) => controller.deleteItem(deleteId),
                            backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                            icon: Icons.delete_outline, label: controller.isFavoritesTab.value ? 'Remove' : 'Cancel',
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ],
                      ),
                      child: VerticalPetCard(
                        imageUrl: image ?? "", name: name ?? "Unknown", info: origin ?? "Unknown",
                        shelterName: displayStatus, isCat: item['isCat'] ?? true, onTap: () {},
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
}