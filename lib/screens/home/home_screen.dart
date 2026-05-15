import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Controllers and Models
import '../../controller/home/home_controller.dart';
import '../../data/responses/status.dart';

// Import Resources
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';

// Import Widgets
import '../Detail/detail_screen.dart';
import 'Widgets/horizontal_card.dart';
import 'Widgets/section_tile.dart';
import 'Widgets/vertical_card.dart';

// Import Detail Screen for Navigation


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeModel = Get.put(HomeViewModel());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          switch (homeModel.apiStatus.value.status) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator(color: AppColors.DarkPink));
            case Status.ERROR:
              return Center(child: Text(homeModel.apiStatus.value.message.toString()));
            case Status.Completed:
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---  HEADER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left: Logo
                          ClipOval(
                            child: Image.asset(ImageAssets.logo, height: 40, width: 40, fit: BoxFit.cover),
                          ),

                          // Center: App Name & Welcome
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center, // Centers the text
                              children: [
                                Text(
                                    "Welcome to",
                                    style: GoogleFonts.jost(fontSize: 14, color: AppColors.MyGray)
                                ),
                                Text(
                                    "Paw Shelter",
                                    style: GoogleFonts.jost(
                                        fontSize: 22, // Slightly larger for impact
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.AppColor
                                    )
                                ),
                              ],
                            ),
                          ),

                          // Right: Invisible Box (To balance Logo width and force true center)
                          const SizedBox(width: 40),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      // ---  SLIDER ---
                      CarouselSlider(
                        items: [ImageAssets.b1, ImageAssets.b2, ImageAssets.b3].map((i) {
                          return Container(
                            width: width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(image: AssetImage(i), fit: BoxFit.cover),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: height * 0.2,
                          autoPlay: true,
                          viewportFraction: 0.9,
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // ---  HORIZONTAL LIST (Cats) ---
                      const SectionTitleWidget(title: "Meet the Cats"),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeModel.catList.length,
                          itemBuilder: (context, index) {
                            final cat = homeModel.catList[index];
                            String name = (cat.breeds != null && cat.breeds!.isNotEmpty)
                                ? cat.breeds![0].name ?? "Unknown" : "Cute Cat";

                            return HorizontalPetCard(
                                imageUrl: cat.url ?? "",
                                name: name,
                                onTap: () {
                                  // NAVIGATE: Pass Cat Object + true (isCat)
                                  Get.to(() => PetDetailScreen(), arguments: [cat, true]);
                                }
                            );
                          },
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // ---  HORIZONTAL LIST (Dogs) ---
                      const SectionTitleWidget(title: "Meet the Dogs"),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeModel.dogList.length,
                          itemBuilder: (context, index) {
                            final dog = homeModel.dogList[index];
                            return HorizontalPetCard(
                                imageUrl: dog.imageUrl,
                                name: dog.name ?? "Dog",
                                onTap: () {
                                  // NAVIGATE: Pass Dog Object + false (isCat)
                                  Get.to(() => const PetDetailScreen(), arguments: [dog, false]);
                                }
                            );
                          },
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // --- 5. VERTICAL LIST (Interleaved) ---
                      const SectionTitleWidget(title: "Adopt a Buddy"),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          // Safety check for list bounds
                          if (index >= homeModel.catList.length || index >= homeModel.dogList.length) return const SizedBox();

                          final cat = homeModel.catList[index];
                          final dog = homeModel.dogList[index];

                          // Cat Logic
                          String catName = (cat.breeds != null && cat.breeds!.isNotEmpty) ? cat.breeds![0].name! : "Cat";
                          String catOrigin = (cat.breeds != null && cat.breeds!.isNotEmpty) ? cat.breeds![0].origin! : "Shelter";

                          return Column(
                            children: [
                              // Cat Card
                              VerticalPetCard(
                                imageUrl: cat.url ?? "",
                                name: catName,
                                info: "Origin: $catOrigin",
                                shelterName: "Happy Paws Shelter",
                                isCat: true,
                                onTap: () {
                                  // NAVIGATE: Pass Cat Object + true
                                  Get.to(() => const PetDetailScreen(), arguments: [cat, true]);
                                },
                              ),

                              // Dog Card
                              VerticalPetCard(
                                imageUrl: dog.imageUrl,
                                name: dog.name ?? "Dog",
                                info: dog.breedGroup ?? "Good Boy",
                                shelterName: "City Rescue Center",
                                isCat: false,
                                onTap: () {
                                  // NAVIGATE: Pass Dog Object + false
                                  Get.to(() => const PetDetailScreen(), arguments: [dog, false]);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox();
          }
        }),
      ),
    );
  }
}