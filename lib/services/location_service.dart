import 'package:etravel_mobile/services/logger_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static LocationService getInstance = LocationService();

  Future<bool> grantAccessCurrentLocation() async {
    var permission = false;
    await Geolocator.requestPermission().then((locationPermission) {
      permission = true;
      loggerInfo.i("permission = $permission");
    });
    return permission;
  }

  Future<Position?> getUserCurrentLocation() async {
    Position? userPosition;
    await Geolocator.getCurrentPosition().then((position) {
      userPosition = position;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return userPosition;
  }
}
