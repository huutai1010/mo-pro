import 'package:etravel_mobile/models/journey.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class JourneyViewModel extends ChangeNotifier {
  final _bookingRepo = BookingRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<Journey>> getJourneyByStatus(int status) async {
    List<Journey> journeys = [];
    await _bookingRepo.getJourneysByStatus(status).then((value) {
      setLoading(false);
      journeys = (value['journeys'] as List<dynamic>)
          .map((e) => Journey.fromJson(e))
          .toList();
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return journeys;
  }

  Future<Journey> getJourneyDetails(int journeyId) async {
    Journey journey = Journey();
    setLoading(true);
    await _bookingRepo.getJourneyDetail(journeyId).then((value) {
      setLoading(false);
      if (value['journeys'] != null) {
        journey = Journey.fromJson(value['journeys']);
      }
    });
    return journey;
  }

  Future<List<String>> getUserJourneyRoutes(int journeyId) async {
    var routes = <String>[];
    await LocalStorageService.getInstance
        .getUserJourneyRoutes(journeyId)
        .then((value) => routes = value);
    return routes;
  }

  Future updateJourneyStatus(int journeyId, int status) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 4));
    await _bookingRepo.updateJourneyStatus(journeyId, status).then((value) {
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
