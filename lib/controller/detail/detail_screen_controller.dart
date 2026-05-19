import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controller/profile/profile_controller.dart'; // 🔥 Aapki profile controller ka sahi path
import '../../Utiles/utiles.dart'; // 🔥 Aapki utils file ka sahi path

class PetDetailController extends GetxController {
  var name = 'Unknown'.obs;
  var imageUrl = ''.obs;
  var breed = 'Local Rescue'.obs;
  var temperament = 'Friendly, Playful'.obs;
  var description = 'This adorable pet is looking for a loving forever home.'.obs;
  var lifeSpan = '2-5'.obs;
  var isCat = false.obs;

  var localizedLocation = ''.obs;
  var finalDonorName = ''.obs;
  var codAmount = 0.0.obs;

  var isFavorite = false.obs;
  var isLoading = false.obs;
  
  var petId = ''.obs;

  final List<String> pakCities = [
    "Lahore (Gulberg Hub)",
    "Karachi (Clifton Node)",
    "Islamabad (G-11 Shelter)",
    "Faisalabad (Samanabad Hub)"
  ];

  final List<String> donorNames = [
    "Ali Raza (Rescuer)",
    "Amna Bibi (Donor)",
    "Zainab Ahmed",
    "Usman Khan"
  ];

  @override
  void onInit() {
    super.onInit();
    initPetData();
  }

  void initPetData() {
    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List<dynamic>;

      if (args.isNotEmpty && args[0] is Map) {
        final Map<String, dynamic> argument = Map<String, dynamic>.from(args[0]);

        name.value = argument['name'] ?? 'Unknown';
        imageUrl.value = argument['image'] ?? argument['imageUrl'] ?? argument['petImage'] ?? '';
        breed.value = argument['breed'] ?? 'Local Rescue';
        temperament.value = argument['temperament'] ?? 'Friendly, Playful';
        description.value = argument['description'] ?? 'This adorable pet is looking for a loving forever home.';
        lifeSpan.value = argument['lifeSpan'] ?? argument['age'] ?? '2-5';
        
        // Dynamic ID catch tracking
        petId.value = argument['id'] ?? argument['petId'] ?? name.value.hashCode.toString(); 

        if (args.length > 1 && args[1] is bool) {
          isCat.value = args[1] as bool;
        } else {
          isCat.value = argument['isCat'] ?? false;
        }

        final int uniqueSeed = name.value.hashCode.abs();

        if (argument['city'] != null && argument['city'].toString().isNotEmpty) {
          localizedLocation.value = argument['city'];
        } else if (argument['location'] != null && argument['location'].toString().isNotEmpty) {
          localizedLocation.value = argument['location'];
        } else if (argument['origin'] != null && argument['origin'].toString().isNotEmpty) {
          localizedLocation.value = argument['origin'];
        } else {
          localizedLocation.value = pakCities[uniqueSeed % pakCities.length];
        }

        if (argument['donorName'] != null) {
          finalDonorName.value = argument['donorName'];
        } else {
          finalDonorName.value = donorNames[uniqueSeed % donorNames.length];
        }

        if (argument['codAmount'] != null) {
          codAmount.value = (argument['codAmount'] is double) ? argument['codAmount'] as double : double.tryParse(argument['codAmount'].toString()) ?? 0.0;
        } else {
          codAmount.value = (uniqueSeed % 3 + 1) * 500.0;
        }
        
        _checkIfFavorite();
      }
    }
  }

  // --- 1. CHECK FAVORITE (Matches your service collection structure) ---
  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites') // 🔥 Plural, as per FirestoreService
          .doc(petId.value)
          .get();
          
      if (doc.exists) {
        isFavorite.value = true;
      }
    }
  }

  // --- 2. TOGGLE FAVORITE (Writes exact keys like 'image' and 'origin' for your profile stream) ---
  void toggleFavorite() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Utils.toastMesseges("Please login to add favorites");
        return;
      }

      isFavorite.value = !isFavorite.value;

      final favDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites') // 🔥 Fixed sub-collection name
          .doc(petId.value);

      if (isFavorite.value) {
        await favDocRef.set({
          "petId": petId.value,
          "name": name.value,
          "image": imageUrl.value, // 🔥 Fixed key name
          "origin": localizedLocation.value, // 🔥 Fixed key name
          "isCat": isCat.value,
          "savedAt": DateTime.now().toIso8601String(), // 🔥 Fixed format
        });
        Utils.toastMessegessuccess("Added to Favorites!");
      } else {
        await favDocRef.delete();
        Utils.toastMessegessuccess("Removed from Favorites");
      }
    } catch (e) {
      isFavorite.value = !isFavorite.value; // Revert UI on database error
      Utils.toastMesseges("Error updating favorites: $e");
    }
  }

  // --- 3. ADOPTION REQUEST (Maps exactly to 'requests' root with 'uid', 'petName', 'petImage', etc.) ---
  Future<void> requestAdoption() async {
    if (isLoading.value) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Utils.toastMesseges("Please login first");
      return;
    }

    isLoading.value = true;
    
    try {
      String requestId = DateTime.now().millisecondsSinceEpoch.toString();

      final reqData = {
        'requestId': requestId,
        'uid': user.uid, 
        'petId': petId.value,
        'petName': name.value, 
        'petImage': imageUrl.value, 
        'petOrigin': localizedLocation.value, 
        'isCat': isCat.value,
        'donorName': finalDonorName.value,
        'codAmount': codAmount.value,
        'status': 'pending', // 🔥 Fauran 'pending' state set ho rahi hai yahan
        'timestamp': FieldValue.serverTimestamp(),
      };

      // 📝 1. Root Requests collection update
      await FirebaseFirestore.instance.collection('requests').doc(requestId).set(reqData);
      
      // 📝 2. Central adoption requests update
      await FirebaseFirestore.instance.collection('adoption_requests').doc(requestId).set(reqData);

      // 🔥 --- INSTANT STATE REFRESH FOR PROFILE TAB ---
      // Agar user profile controller active hai, tou uski requests list ko local target data inject kar ke instant update trigger dein ge
      if (Get.isRegistered<UserProfileController>()) {
        final profileCtrl = Get.find<UserProfileController>();
        // Add locally to the reactive list so it draws on screen instantly without waiting for network stream callback
        profileCtrl.userRequests.insert(0, reqData);
        profileCtrl.userRequests.refresh();
      }

      Utils.toastMessegessuccess("Adoption Request Sent!");
    } catch (e) {
      Utils.toastMesseges("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}