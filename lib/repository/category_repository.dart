import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class CategoryRepository {
  final BaseApiServices _baseApiServices = NetworkApiService();

  Future<dynamic> getCategories(String languageCode) async {
    try {
      dynamic response = _baseApiServices.getGetApiResponseAuth(
          '${AppUrl.getCategoriesEndpoint}$languageCode');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
