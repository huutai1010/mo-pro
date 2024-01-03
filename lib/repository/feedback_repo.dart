import 'package:etravel_mobile/data/network/BaseApiServices.dart';
import 'package:etravel_mobile/data/network/NetworkApiService.dart';
import 'package:etravel_mobile/res/strings/app_url.dart';

class FeedbackRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<dynamic> createFeedback(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiRepsonseAuth(
          AppUrl.createFeedbackEnpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
