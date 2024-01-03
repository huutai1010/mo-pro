import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class PeopleRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getRecentPeopleApi() async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponseAuth(AppUrl.getNearbyAccountsEndpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future sendNotificationApi(int notificationType, int receiverId) async {
    try {
      await _apiServices.getPostApiRepsonseAuth(
        '${AppUrl.postNotificationEndpoint}?notificationType=$notificationType&receiverId=$receiverId',
        {},
      );
    } catch (e) {
      rethrow;
    }
  }
}
