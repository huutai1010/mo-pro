import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/data/app_exception.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../models/place.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/material.dart';

class PlaceDetailViewModel with ChangeNotifier {
  final _placeRepo = PlaceRepository();
  var markers = <Marker>[];
  var places = <Place>[];
  var quantity = 0;
  bool isFailed = false;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setFailed(bool value) {
    isFailed = value;
    notifyListeners();
  }

  Future getQuantity() async {
    await LocalStorageService.getInstance.getCartPlace().then(
          (value) => quantity = value.isNotEmpty ? value.length : 0,
        );
  }

  Future<Place?> getPlaceDetails(
    int placeId,
    BuildContext context,
  ) async {
    late Place? place;
    try {
      await _placeRepo.getPlaceDetails(placeId).then((value) {
        setLoading(false);
        if (value['place'] != null) {
          place = Place.fromJson(value['place']);
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error.toString());
        }
      });
      await Future.delayed(const Duration(seconds: 1));
    } on InternetServerException catch (_) {
      setFailed(true);
    } on RequestTimeoutException catch (_) {
      setFailed(true);
    } on NotFoundException catch (_) {
      setFailed(true);
    }

    return place;
  }

  Future addPlaceToCart(Place place, BuildContext context) async {
    quantity += 1;
    notifyListeners();
    await LocalStorageService.getInstance.addToCartPlace(place).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            context.tr('add_place_to_tour_successfully'),
          ),
        ),
      );
    });
  }

  Future<bool> isBookingPlace(int placeId) async {
    var result = false;
    await _placeRepo.isBookingPlace(placeId).then((value) {
      result = value;
      return result;
    });
    return result;
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadMarkerData(Place place) async {
    places.add(place);
    final Uint8List markerIcon =
        await getBytesFromAssets('assets/images/map/pin-place.png', 150);
    for (int i = 0; i < places.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(places[i].latitude!, places[i].longitude!),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {},
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getListBeaconsAtPlace(int placeId) async {
    var placeItems = <Map<String, dynamic>>[];
    try {
      await _placeRepo.getListBeaconsAtPlace(placeId).then((value) {
        setLoading(false);
        if (value['placeItems'] != null) {
          var json = value as Map<String, dynamic>;
          json['placeItems'].forEach(
            (v) => placeItems.add({
              'name': v['name'],
              'url': v['url'],
            }),
          );
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error.toString());
        } else if (kReleaseMode) {
          loggerInfo.i(error.toString());
        }
      });
    } catch (e) {
      rethrow;
    }
    return placeItems;
  }
}
