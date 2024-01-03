import 'package:etravel_mobile/data/network/BaseApiServices.dart';
import 'package:etravel_mobile/data/network/NetworkApiService.dart';
import 'package:etravel_mobile/res/strings/app_url.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapRespository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<dynamic> getTimeAndDistanceFromOriginToDestinations(
      LatLng origin, List<LatLng> destinations) async {
    var desStr = '';
    try {
      if (destinations.isNotEmpty) {
        if (destinations.length == 1) {
          desStr = '${destinations[0].latitude}%2C${destinations[0].longitude}';
        } else {
          for (var i = 0; i < destinations.length; i++) {
            desStr +=
                '${destinations[i].latitude}%2C${destinations[i].longitude}${(i != destinations.length - 1) ? '%7C' : ''}';
          }
        }
      }
      final url =
          '${AppUrl.calculateDistanceAndTimeGoongEndpoint}&origins=${origin.latitude}%2C${origin.longitude}&destinations=$desStr';
      loggerInfo.i('url = $url');
      dynamic response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRoute(LatLng origin, LatLng destination) async {
    try {
      final url =
          '${AppUrl.routeGoongEndpoint}&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&vehicle=bike';

      dynamic response = await _apiServices.getGetApiResponse(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
