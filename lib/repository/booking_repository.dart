import 'package:http/http.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class BookingRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> postBooking(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiRepsonseAuth(
          AppUrl.postBookingEndpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> confirmBooking(String confirmUrl) async {
    try {
      final url = confirmUrl.replaceAll(
          RegExp('http://replacement.link'), AppUrl.baseUrl);
      dynamic response = await _apiServices.getGetApiResponseAuth(url);
      return response;
    } catch (e) {
      // Do nothing
    }
  }

  Future<dynamic> getCelebratedImages(int journeyId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getCelebratedPlaceEndpoint}/$journeyId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postCelebratedImage(
      int bookingPlaceId, MultipartFile multipartFile) async {
    try {
      dynamic response = await _apiServices.getPostMultipartResponseAuth(
          '${AppUrl.createCelebratedPlaceEndpoint}/$bookingPlaceId',
          multipartFile);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getHistoryBookings(int pageNumber, int pageSize) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getHistoryBookingsEndPoint}?pageSize=$pageSize&pageNumber=$pageNumber');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBookingDetail(int id) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponseAuth('${AppUrl.getBookingDetail}/$id');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getJourneysByStatus(int status) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getJourneysByStatusEndpoint}/$status');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getPlacesByStatus(bool isJourney) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getPlacesBookingByStatus}?isJourney=$isJourney');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future createJourney(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiRepsonseAuth(
          AppUrl.createJourneyEndpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getJourneyDetail(int id) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponseAuth('${AppUrl.getJourneyDetailsEndPoint}/$id');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future checkInPlace(int bookingPlaceId, {bool isFinish = false}) async {
    try {
      var url = isFinish
          ? '${AppUrl.checkinEndpoint}/$bookingPlaceId?isFinish=true'
          : '${AppUrl.checkinEndpoint}/$bookingPlaceId';
      dynamic response = await _apiServices.getGetApiResponseAuth(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future updateJourneyStatus(int journeyId, int status) async {
    try {
      dynamic response = await _apiServices.getPutApiResponseAuthNoRequestBody(
          '${AppUrl.updateJourneyStatusEndPoint}/$journeyId/$status');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getDataPlaceVoiceScreen(int placeId) async {
    try {
      print('${AppUrl.getVoiceEndPoint}/$placeId');
      dynamic response = await _apiServices
          .getGetApiResponseAuth('${AppUrl.getVoiceEndPoint}/$placeId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future cancelBooking(int bookingId) async {
    try {
      dynamic response = await _apiServices.getPutApiResponseAuthNoRequestBody(
          '${AppUrl.cancelBookingEndpoint}/$bookingId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
