import '../../data/network/dio_network_api_services.dart';
import '../../model/cat_model.dart';
import '../../model/dog_model.dart';
import '../../resources/appUrl/app_url.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  // Fetch Cats
  Future<List<CatModel>> fetchCatList() async {
    try {
      dynamic response = await _apiServices.getApi(
        AppUrl.catListUrl,
        headers: {'x-api-key': AppUrl.catApiKey},
      );
      
      List<CatModel> catList = [];
      if (response != null) {
        for (var i in response) {
          catList.add(CatModel.fromJson(i));
        }
      }
      return catList;
    } catch (e) {
      rethrow;
    }
  }

  // Fetch Dogs
  Future<List<DogModel>> fetchDogList() async {
    try {
      dynamic response = await _apiServices.getApi(
        AppUrl.dogListUrl,
        headers: {'x-api-key': AppUrl.dogApiKey},
      );
      
      List<DogModel> dogList = [];
      if (response != null) {
        for (var i in response) {
          dogList.add(DogModel.fromJson(i));
        }
      }
      return dogList;
    } catch (e) {
      rethrow;
    }
  }
}