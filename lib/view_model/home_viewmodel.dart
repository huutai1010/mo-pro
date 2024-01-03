import 'package:etravel_mobile/data/app_exception.dart';

import '../models/place.dart';
import '../models/tour.dart';
import '../repository/place_repository.dart';
import '../repository/tour_repository.dart';
import '../services/logger_service.dart';
import '../view/tour/tour_detail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewViewModel with ChangeNotifier {
  final _placeRepo = PlaceRepository();
  final _tourRepo = TourRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<Place>> getPopularPlaces() async {
    var popularPlaces = <Place>[];
    await _placeRepo.getPopularPlaces().then((value) {
      setLoading(false);
      if (value['places'] != null) {
        var json = value as Map<String, dynamic>;
        json['places'].forEach((v) => popularPlaces.add(Place.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return popularPlaces;
  }

  Future<List<Tour>> getPopularTours() async {
    var popularTours = <Tour>[];
    await _tourRepo.getPopularTour().then((value) {
      setLoading(false);
      if (value['tours'] != null) {
        var json = value as Map<String, dynamic>;
        json['tours'].forEach((v) => popularTours.add(Tour.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return popularTours;
  }

  void getTourDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Container()));
  }

  Future<Tour?> getTourDetailsV2(int tourId, BuildContext homeViewContext,
      bool isPopularPlace, BuildContext context) async {
    Tour? tour;
    try {
      await _tourRepo.getTourDetails(tourId).then((value) {
        setLoading(false);
        if (value['tour'] != null) {
          tour = Tour.fromJson(value['tour']);
          loggerInfo.i('get tour success');
          Navigator.push(
            homeViewContext,
            MaterialPageRoute(
              builder: (_) => !isPopularPlace
                  ? TourDetailView(
                      tourId: tour?.id ?? 0,
                      exchanges: tour?.exchanges ?? {},
                    )
                  : Container(),
            ),
          );
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } on InternetServerException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/background/create_journey.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 15),
              const Text('Some thing went wrong!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }

    return tour;
  }
}
