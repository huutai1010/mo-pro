import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:flutter/foundation.dart';

class PlaceBookingViewModel extends ChangeNotifier {
  final _bookingRepo = BookingRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<Place>> getPlacesByStatus(bool isJourney) async {
    List<Place> places = [];
    await _bookingRepo.getPlacesByStatus(isJourney).then((value) {
      setLoading(false);
      places = (value['bookingPlaces'] as List<dynamic>)
          .map((e) => Place.fromJson(e))
          .toList();
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return places;
  }
}
