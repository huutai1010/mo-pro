import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.registerEndPoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> changeLanguageApi(int languageId) async {
    try {
      dynamic response = await _apiServices.getPutApiRepsonseAuth(
          '${AppUrl.changeLanguageEndpoint}/$languageId', {});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiServices.getPutApiRepsonseAuth(
          AppUrl.updateCurrentProfileEndpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
