import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Controllers and Models
import '../../controller/home/home_controller.dart';

// Resources
import '../../resources/assets/image_assets.dart';
import '../../resources/colors/app_colors.dart';

// Widgets
import '../Detail/detail_screen.dart';
import 'Widgets/horizontal_card.dart';
import 'Widgets/section_tile.dart';
import 'Widgets/vertical_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<String> pakCities = [
      "Lahore (Gulberg Hub)",
      "Karachi (Clifton Node)",
      "Islamabad (G-11 Shelter)",
      "Faisalabad (Samanabad Hub)"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pet_requests')
              .where('status', isEqualTo: 'approved')
              .snapshots(),
          builder: (context, snapshot) {
            final fbDocs = snapshot.data?.docs ?? [];

            bool parseIsCat(dynamic val) {
              if (val == null) return false;
              if (val is bool) return val;
              return val.toString().toLowerCase().trim() == 'true';
            }

            final fbCats = fbDocs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return parseIsCat(data['isCat']);
            }).toList();

            final fbDogs = fbDocs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return !parseIsCat(data['isCat']);
            }).toList();

            return GetBuilder<HomeViewModel>(
              init: HomeViewModel(),
              builder: (homeModel) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: Image.asset(ImageAssets.logo,
                                  height: 40, width: 40, fit: BoxFit.cover),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Welcome to",
                                      style: GoogleFonts.jost(
                                          fontSize: 14,
                                          color: AppColors.MyGray)),
                                  Text("Paw Shelter",
                                      style: GoogleFonts.jost(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.AppColor)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),

                        SizedBox(height: height * 0.02),

                        // --- BANNER SLIDER ---
                        CarouselSlider(
                          items: [
                            ImageAssets.b1,
                            ImageAssets.b2,
                            ImageAssets.b3
                          ].map((i) {
                            return Container(
                              width: width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage(i), fit: BoxFit.cover),
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

                        // --- HORIZONTAL LIST: CATS ---
                        const SectionTitleWidget(title: "Meet the Cats"),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: fbCats.length + homeModel.catList.length,
                            itemBuilder: (context, index) {
                              if (index < fbCats.length) {
                                final catData = fbCats[index].data()
                                    as Map<String, dynamic>;
                                return HorizontalPetCard(
                                  imageUrl: catData['image'] ?? "",
                                  name: catData['name'] ?? "New Cat",
                                  onTap: () => Get.to(
                                      () => const PetDetailScreen(),
                                      arguments: [catData, true]),
                                );
                              }

                              final apiIndex = index - fbCats.length;
                              if (apiIndex >= homeModel.catList.length)
                                return const SizedBox.shrink();
                              final cat = homeModel.catList[apiIndex];

                              String name =
                                  (cat.breeds != null && cat.breeds!.isNotEmpty)
                                      ? cat.breeds![0].name ?? "Cute Cat"
                                      : "Cute Cat";

                              // Pass all keys matching Firebase map structure to keep PetDetailScreen consistent
                              final apiCatMap = {
                                'name': name,
                                'image': cat.url ?? '',
                                'breed': (cat.breeds != null &&
                                        cat.breeds!.isNotEmpty)
                                    ? cat.breeds![0].name ?? 'Local Rescue'
                                    : 'Local Rescue',
                                'temperament': (cat.breeds != null &&
                                        cat.breeds!.isNotEmpty)
                                    ? cat.breeds![0].temperament ?? ''
                                    : '',
                                'description': (cat.breeds != null &&
                                        cat.breeds!.isNotEmpty)
                                    ? cat.breeds![0].description ?? ''
                                    : '',
                                'isCat': true
                              };

                              return HorizontalPetCard(
                                imageUrl: cat.url ?? "",
                                name: name,
                                onTap: () => Get.to(
                                    () => const PetDetailScreen(),
                                    arguments: [apiCatMap, true]),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        // --- HORIZONTAL LIST: DOGS ---
                        const SectionTitleWidget(title: "Meet the Dogs"),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: fbDogs.length + homeModel.dogList.length,
                            itemBuilder: (context, index) {
                              if (index < fbDogs.length) {
                                final dogData = fbDogs[index].data()
                                    as Map<String, dynamic>;
                                return HorizontalPetCard(
                                  imageUrl: dogData['image'] ?? "",
                                  name: dogData['name'] ?? "New Dog",
                                  onTap: () => Get.to(
                                      () => const PetDetailScreen(),
                                      arguments: [dogData, false]),
                                );
                              }

                              final apiIndex = index - fbDogs.length;
                              if (apiIndex >= homeModel.dogList.length)
                                return const SizedBox.shrink();
                              final dog = homeModel.dogList[apiIndex];

                              final apiDogMap = {
                                'name': dog.name ?? "Dog",
                                'image': dog.imageUrl ?? '',
                                'breed': dog.breedGroup ?? 'Local Rescue',
                                'temperament': dog.temperament ?? '',
                                'isCat': false
                              };

                              return HorizontalPetCard(
                                imageUrl: dog.imageUrl ?? "",
                                name: dog.name ?? "Dog",
                                onTap: () => Get.to(
                                    () => const PetDetailScreen(),
                                    arguments: [apiDogMap, false]),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        // --- VERTICAL LIST: ADOPT A BUDDY ---
                        const SectionTitleWidget(title: "Adopt a Buddy"),
                        Builder(
                          builder: (context) {
                            final List<Widget> dynamicVerticalList = [];

                            // 1. Firebase Data Add Kiya
                            for (var doc in fbDocs) {
                              final petData =
                                  doc.data() as Map<String, dynamic>;
                              String petName = petData['name'] ?? "Pet";
                              bool isPetCat = parseIsCat(petData['isCat']);
                              String location = petData['city'] ??
                                  pakCities[petName.hashCode.abs() %
                                      pakCities.length];

                              dynamicVerticalList.add(
                                VerticalPetCard(
                                  imageUrl: petData['image'] ?? "",
                                  name: petName,
                                  info: petData['breed'] ??
                                      (isPetCat
                                          ? "Local Cat Rescue"
                                          : "Local Dog Rescue"),
                                  shelterName: location,
                                  isCat: isPetCat,
                                  onTap: () => Get.to(
                                      () => const PetDetailScreen(),
                                      arguments: [petData, isPetCat]),
                                ),
                              );
                            }

                            // 2. API Data Append Kiya
                            int maxDummyCount = homeModel.catList.length >
                                    homeModel.dogList.length
                                ? homeModel.catList.length
                                : homeModel.dogList.length;

                            for (int i = 0; i < maxDummyCount; i++) {
                              if (i < homeModel.catList.length) {
                                final cat = homeModel.catList[i];
                                String catName = (cat.breeds != null &&
                                        cat.breeds!.isNotEmpty)
                                    ? cat.breeds![0].name!
                                    : "Cat";
                                String location = pakCities[
                                    catName.hashCode.abs() % pakCities.length];

                                final apiCatMap = {
                                  'name': catName,
                                  'image': cat.url ?? '',
                                  'breed': (cat.breeds != null &&
                                          cat.breeds!.isNotEmpty)
                                      ? cat.breeds![0].name ?? 'Local Rescue'
                                      : 'Local Rescue',
                                  'temperament': (cat.breeds != null &&
                                          cat.breeds!.isNotEmpty)
                                      ? cat.breeds![0].temperament ?? ''
                                      : '',
                                  'description': (cat.breeds != null &&
                                          cat.breeds!.isNotEmpty)
                                      ? cat.breeds![0].description ?? ''
                                      : '',
                                  'city': location,
                                  'isCat': true
                                };

                                dynamicVerticalList.add(
                                  VerticalPetCard(
                                    imageUrl: cat.url ?? "",
                                    name: catName,
                                    info: "Local Rescue",
                                    shelterName: location,
                                    isCat: true,
// home_screen.dart ke line 280 (ya onTap) mein:
                                    onTap: () => Get.to(
                                        () => const PetDetailScreen(),
                                        arguments: [apiCatMap, true]),
                                  ),
                                );
                              }
                              if (i < homeModel.dogList.length) {
                                final dog = homeModel.dogList[i];
                                String dogName = dog.name ?? "Dog";
                                String location = pakCities[
                                    dogName.hashCode.abs() % pakCities.length];

                                final apiDogMap = {
                                  'name': dogName,
                                  'image': dog.imageUrl ?? '',
                                  'breed': dog.breedGroup ?? 'Local Rescue',
                                  'temperament': dog.temperament ?? '',
                                  'city': location,
                                  'isCat': false
                                };

                                dynamicVerticalList.add(
                                  VerticalPetCard(
                                    imageUrl: dog.imageUrl ?? "",
                                    name: dogName,
                                    info: dog.breedGroup ?? "Local Rescue",
                                    shelterName: location,
                                    isCat: false,
                                    onTap: () => Get.to(
                                        () => const PetDetailScreen(),
                                        arguments: [apiDogMap, false]),
                                  ),
                                );
                              }
                            }

                            if (dynamicVerticalList.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child:
                                      Text("No animals found in active pool."),
                                ),
                              );
                            }

                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dynamicVerticalList.length,
                              itemBuilder: (context, index) {
                                return dynamicVerticalList[index];
                              },
                            );
                          },
                        ),

                        SizedBox(height: height * 0.1),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
