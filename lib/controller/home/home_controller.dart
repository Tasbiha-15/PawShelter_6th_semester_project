import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../../data/responses/api_Response.dart';
import '../../model/cat_model.dart';
import '../../model/dog_model.dart';
import '../../repository/home_repository/home_reposity.dart';

class HomeViewModel extends GetxController {
  final _repo = HomeRepository();

  // Screen status management
  Rx<ApiResponse<bool>> apiStatus = ApiResponse<bool>.loading().obs;

  // Store data separately (ONLY FOR API DATA)
  List<CatModel> catList = [];
  List<DogModel> dogList = [];

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    apiStatus.value = ApiResponse.loading();
    try {
      // 1. Fetch API Repository data for Cats and Dogs parallelly
      final results = await Future.wait([
        _repo.fetchCatList(),
        _repo.fetchDogList(),
      ]);

      // Assign original API repository lists
      catList = results[0] as List<CatModel>;
      dogList = results[1] as List<DogModel>;

      apiStatus.value = ApiResponse.completed(true);
    } catch (e) {
      apiStatus.value = ApiResponse.error(e.toString());
      print("API Fetch Error: $e");
    } finally {
      // CRITICAL FIX: GetBuilder UI ko notify karega ke API data successfully aa gaya hai!
      update(); 
    }
  }
}