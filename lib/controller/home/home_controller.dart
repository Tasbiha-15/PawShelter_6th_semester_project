import 'package:get/get.dart';

import '../../data/responses/api_Response.dart';
import '../../model/cat_model.dart';
import '../../model/dog_model.dart';
import '../../repository/home_repository/home_reposity.dart';


class HomeViewModel extends GetxController {
  final _repo = HomeRepository();

  // We keep one main Status for the whole screen
  Rx<ApiResponse<bool>> apiStatus = ApiResponse<bool>.loading().obs;

  // Store data separately
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
      // Fetch both at the same time for speed
      final results = await Future.wait([
        _repo.fetchCatList(),
        _repo.fetchDogList(),
      ]);

      // Assign data
      catList = results[0] as List<CatModel>;
      dogList = results[1] as List<DogModel>;

      apiStatus.value = ApiResponse.completed(true);
    } catch (e) {
      apiStatus.value = ApiResponse.error(e.toString());
    }
  }
}