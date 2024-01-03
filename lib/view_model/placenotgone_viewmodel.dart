import 'package:etravel_mobile/models/distance_and_duration.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/repository/map_repository.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/services/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceNotGoneViewModel with ChangeNotifier {
  final _googleMapRepo = GoogleMapRespository();
  final _bookingRepo = BookingRepository();
  var totalTime = 0.0;
  var totalDistance = 0.0;

  bool _loading = false;
  bool get loading => _loading;

  bool _createJourneyLoading = false;
  bool get createJourneyLoading => _createJourneyLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setCreateJourneyLoading(bool value) {
    _createJourneyLoading = value;
    notifyListeners();
  }

  updateTotalTime(int time) {
    totalTime += time;
    notifyListeners();
  }

  Future<List<Place>> managePlacesOrdinalV2(List<Place> places) async {
    var copyPlaces = places;
    var distanceAndDurations = <DistanceAndDuration>[];
    var ordinalPlaces = <Place>[];
    var toNew = <Place>[];
    final myLocation =
        await LocationService.getInstance.getUserCurrentLocation();
    LatLng originLatLng = const LatLng(0, 0);
    await Future.forEach(copyPlaces, (element) async {
      if (copyPlaces.indexOf(element) == 0) {
        originLatLng = LatLng(myLocation!.latitude, myLocation.longitude);
      }
      final destinationsLatLng =
          places.map((e) => LatLng(e.latitude!, e.longitude!)).toList();
      await _googleMapRepo
          .getTimeAndDistanceFromOriginToDestinations(
              originLatLng, destinationsLatLng)
          .then(
        (data) {
          (data['rows'][0]['elements']).forEach((element) {
            distanceAndDurations.add(DistanceAndDuration.fromJson(element));
          });
          var nearestLocation = distanceAndDurations[0];
          var nearestPlaceIndex = 0;
          for (int i = 0; i <= distanceAndDurations.length - 1; i++) {
            if (distanceAndDurations[i].distance!.value! <
                nearestLocation.distance!.value!) {
              nearestLocation = distanceAndDurations[i];
              nearestPlaceIndex = i;
            }
          }
          totalDistance +=
              distanceAndDurations[nearestPlaceIndex].distance!.value!;
          totalTime += distanceAndDurations[nearestPlaceIndex].duration!.value!;
          ordinalPlaces.add(places[nearestPlaceIndex]);
          originLatLng = LatLng(places[nearestPlaceIndex].latitude!,
              places[nearestPlaceIndex].longitude!);
          distanceAndDurations = [];
          toNew = [];
          for (var j = 0; j < places.length; j++) {
            if (j != nearestPlaceIndex) {
              toNew.add(places[j]);
            }
          }
          places = toNew;
        },
      );
    });
    return ordinalPlaces;
  }

  Future<List<String>> createRoutes(List<Place> places,
      {bool isCheckedOrdinal = true}) async {
    var routes = <String>[];
    var ordinalPlaces = <Place>[];
    if (isCheckedOrdinal) {
      ordinalPlaces = await managePlacesOrdinalV2(places);
      for (var place in ordinalPlaces) {
        print('${place.name}');
      }
    } else {
      ordinalPlaces = places;
    }
    final myLocation =
        await LocationService.getInstance.getUserCurrentLocation();
    var completedPlaces = [
          Place(
              latitude: myLocation?.latitude, longitude: myLocation?.longitude)
        ] +
        ordinalPlaces;

    for (var index = 0; index <= completedPlaces.length - 2; index++) {
      var origin = LatLng(
          completedPlaces[index].latitude!, completedPlaces[index].longitude!);
      var destination = LatLng(completedPlaces[index + 1].latitude!,
          completedPlaces[index + 1].longitude!);
      await _googleMapRepo.getRoute(origin, destination).then((response) {
        routes.add(response['routes'][0]['overview_polyline']['points']);
      });
    }
    return routes;
  }

  Future<Map<String, dynamic>?> createJourney(
      double totalTime, double totalDistance, List<Place> places) async {
    setLoading(true);
    Map<String, dynamic>? response;
    Map<String, dynamic> data = {
      "totalTime": totalTime / 3600,
      "totalDistance": totalDistance / 1000,
      "journeyDetails": List.generate(
        places.length,
        (index) => {
          "bookingDetailId": places[index].bookingPlaceId,
          "placeId": places[index].placeId,
          "ordinal": index + 1,
        },
      )
    };

    await _bookingRepo.createJourney(data).then((value) {
      setLoading(false);
      response = value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return response;
  }

  Future saveUserJourneyRoutes(List<String> routes, int journeyId) async {
    await LocalStorageService.getInstance
        .saveUserJourneyRoutes(routes, journeyId);
  }
}
