import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class LanguageRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getLanguages() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse(AppUrl.getLanguagesEndpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getNationalities() async {
    try {
      dynamic response =
          await _apiServices.getGetApiResponse(AppUrl.getNationalitiesEndpoint);
      return response['nationalities'];
    } catch (e) {
      rethrow;
    }
  }
}
