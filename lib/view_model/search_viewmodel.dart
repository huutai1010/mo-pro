import 'package:geolocator/geolocator.dart';
import '../models/category.dart';
import '../models/place.dart';
import '../repository/category_repository.dart';
import '../repository/place_repository.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/foundation.dart';
import '../services/location_service.dart';
import '../services/logger_service.dart';

class SearchViewModel with ChangeNotifier {
  final _categoryRepo = CategoryRepository();
  final _placeRepo = PlaceRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<CategoryLanguage>> getCategory() async {
    String? languageCode;
    var categories = <CategoryLanguage>[];
    await LocalStorageService.getInstance.getAccount().then((account) {
      if (account != null) {
        languageCode = account.languageCode;
        loggerInfo.i('languageCode = $languageCode');
      }
    });

    if (languageCode != null) {
      await _categoryRepo.getCategories(languageCode!).then((value) {
        setLoading(false);
        if (value['categoryLanguages'] != null) {
          var json = (value as Map<String, dynamic>);
          json['categoryLanguages'].forEach((v) {
            categories.add(CategoryLanguage.fromJson(v));
          });
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
    return categories;
  }

  Future<List<Place>> getPlacesAround() async {
    var placesAround = <Place>[];
    late Position position;
    await LocationService.getInstance
        .getUserCurrentLocation()
        .then((value) async {
      if (value != null) {
        position = value;
        loggerInfo.i('current lat = ${position.latitude}');
        loggerInfo.i('current long = ${position.longitude}');
        await _placeRepo
            .getNearbyPlaces(
          currentLatitude: position.latitude,
          currentLongtitude: position.longitude,
        )
            .then((value) {
          setLoading(false);
          if (value['places'] != null) {
            var json = value as Map<String, dynamic>;
            json['places'].forEach((v) => placesAround.add(Place.fromJson(v)));
          }
        }).onError((error, stackTrace) {
          setLoading(false);
          if (kDebugMode) {
            print(error.toString());
          }
        });
      }
    });

    return placesAround;
  }

  Future<List<Place>> getPlacesAroundV2(double lat, double long) async {
    var placesAround = <Place>[];
    await _placeRepo
        .getNearbyPlaces(
      currentLatitude: lat,
      currentLongtitude: long,
    )
        .then((value) {
      setLoading(false);
      if (value['places'] != null) {
        var json = value as Map<String, dynamic>;
        json['places'].forEach((v) => placesAround.add(Place.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });

    return placesAround;
  }

  Future<List<Place>> getPlacesAroundSelectedPlace(int placeId) async {
    var placesAround = <Place>[];
    await _placeRepo
        .getNearbyPlaceOfSelectedPlace(
      placeId,
    )
        .then((value) {
      setLoading(false);
      if (value['places'] != null) {
        var json = value as Map<String, dynamic>;
        json['places'].forEach((v) => placesAround.add(Place.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });

    return placesAround;
  }

  Future<List<Place>> searchByCategories(List<int> categories) async {
    setLoading(true);
    String queryParamVal = '';
    var places = <Place>[];
    for (int i = 0; i < categories.length; i++) {
      if (i != categories.length - 1) {
        queryParamVal += ('${categories[i]},');
      } else {
        queryParamVal += '${categories[i]}';
      }
    }
    loggerInfo.i(queryParamVal);
    await _placeRepo.getSearchResultPlaces(queryParamVal).then((value) {
      setLoading(false);
      if (value['places'] != null) {
        var json = value as Map<String, dynamic>;
        json['places'].forEach((v) => places.add(Place.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    loggerInfo.i('Search place size = ${places.length}');
    return places;
  }
}
