import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class TourRepository {
  final BaseApiServices _baseApiServices = NetworkApiService();

  Future<dynamic> getPopularTour() async {
    try {
      dynamic response =
          _baseApiServices.getGetApiResponseAuth(AppUrl.topTourEndpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTourDetails(int tourId) async {
    try {
      dynamic response = _baseApiServices
          .getGetApiResponseAuth('${AppUrl.tourDetailsEndpoint}/$tourId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getListPopularTours(int pageNumber, int pageSize) async {
    try {
      dynamic response = await _baseApiServices.getGetApiResponseAuth(
          '${AppUrl.getListToursEndpoint}?pageSize=$pageSize&pageNumber=$pageNumber');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTourDetailsToFeedback(int tourId) async {
    try {
      dynamic response = _baseApiServices.getGetApiResponseAuth(
          '${AppUrl.getTourDetailToFeedbackEndpoint}/$tourId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
