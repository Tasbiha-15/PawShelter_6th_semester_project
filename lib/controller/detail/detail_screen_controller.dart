import 'package:get/get.dart';
import '../../data/fireStoreDB/fireStore_DB_Service.dart';
import '../../model/cat_model.dart';
import '../../model/dog_model.dart';

class PetDetailController extends GetxController {

  final FirestoreService _firestoreService = FirestoreService();

  // Dynamic variable to hold either Cat or Dog model
  late final dynamic pet;
  late final bool isCat;

  // Rx Variables for UI
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // We expect arguments passed; like: Get.toNamed(route, arguments: [petObj, isCatBool])
    pet = Get.arguments[0];
    isCat = Get.arguments[1];
  }

  // --- Getters to Normalize Data (So UI is clean) ---

  String get name {
    if (isCat) {
      return (pet as CatModel).breeds?.isNotEmpty == true
          ? (pet as CatModel).breeds![0].name ?? "Unknown Cat"
          : "Cat";
    } else {
      return (pet as DogModel).name ?? "Unknown Dog";
    }
  }

  String get imageUrl {
    if (isCat) {
      return (pet as CatModel).url ?? "";
    } else {
      return (pet as DogModel).imageUrl;
    }
  }

  String get id {
    if (isCat) {
      return (pet as CatModel).id ?? "";
    } else {
      return (pet as DogModel).id?.toString() ?? "";
    }
  }

  String get originOrGroup {
    if (isCat) {
      return (pet as CatModel).breeds?.isNotEmpty == true
          ? (pet as CatModel).breeds![0].origin ?? "Unknown"
          : "Unknown Origin";
    } else {
      return (pet as DogModel).breedGroup ?? "Good Boy";
    }
  }

  String get description {
    if (isCat) {
      return (pet as CatModel).breeds?.isNotEmpty == true
          ? (pet as CatModel).breeds![0].description ?? "No description available."
          : "A lovely cat looking for a home.";
    } else {
      // Dogs usually have temperament, we use that as description
      return (pet as DogModel).temperament ?? "A loyal and friendly companion.";
    }
  }

  String get temperament {
    if (isCat) {
      return (pet as CatModel).breeds?.isNotEmpty == true
          ? (pet as CatModel).breeds![0].temperament ?? "Playful"
          : "Playful";
    } else {
      return (pet as DogModel).temperament ?? "Friendly";
    }
  }

  String get lifeSpan {
    if (isCat) {
      return (pet as CatModel).breeds?.isNotEmpty == true
          ? (pet as CatModel).breeds![0].lifeSpan ?? "-"
          : "-";
    } else {
      return (pet as DogModel).lifeSpan ?? "-";
    }
  }

  // --- Actions ---

  Future<void> saveToFavorites() async {
    await _firestoreService.savePetToFavorites(
      petId: id,
      name: name,
      imageUrl: imageUrl,
      origin: originOrGroup,
      isCat: isCat,
    );
  }

  Future<void> requestAdoption() async {
    isLoading.value = true;
    await _firestoreService.requestAdoption(
      petId: id,
      name: name,
      imageUrl: imageUrl,
      origin: originOrGroup,
      isCat: isCat,
    );
    isLoading.value = false;
  }
}