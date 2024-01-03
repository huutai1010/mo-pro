import 'package:etravel_mobile/models/favorite.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../const/data_sample.dart';
import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';
import '../services/logger_service.dart';

class PlaceRepository {
  final BaseApiServices _baseApiServices = NetworkApiService();

  Future<dynamic> getPopularPlaces() async {
    try {
      dynamic response =
          _baseApiServices.getGetApiResponseAuth(AppUrl.topPlaceEndpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getListPopularPlaces(int pageNumber, int pageSize) async {
    try {
      dynamic response = await _baseApiServices.getGetApiResponseAuth(
          '${AppUrl.getListPlacesEndpoint}?pageSize=$pageSize&pageNumber=$pageNumber');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPlaceDetails(int placeId) async {
    try {
      dynamic response = await _baseApiServices
          .getGetApiResponseAuth('${AppUrl.placeDetailsEndpoint}/$placeId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getNearbyPlaces(
      {required double currentLatitude,
      required double currentLongtitude}) async {
    try {
      dynamic response = _baseApiServices.getGetApiResponseAuth(
          '${AppUrl.getPlacesAroundEndpoint}?latitudeVisitor=$currentLatitude&longitudeVisitor=$currentLongtitude');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getNearbyPlaceOfSelectedPlace(int placeId) async {
    try {
      dynamic response = _baseApiServices
          .getGetApiResponseAuth('${AppUrl.getPlacesAroundEndpoint}/$placeId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getSearchResultPlaces(String categories) async {
    try {
      dynamic response = _baseApiServices
          .getGetApiResponseAuth('${AppUrl.searchPlacesEndpoint}$categories');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Set<Polyline> getPolylinesFromSearchPlacesResult() {
    List<List<LatLng>> listLatLngPolylines = [];
    Set<Polyline> polylines = {};
    for (var element in listDirection) {
      listLatLngPolylines.add(element.polylinePoints
          .map((pointLatLng) =>
              LatLng(pointLatLng.latitude, pointLatLng.longitude))
          .toList());
    }
    loggerInfo.i('listLatLngPolylines = ${listLatLngPolylines.length}');
    for (var list in listLatLngPolylines) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('polyline_id'),
          color: Colors.orange,
          points: list,
          width: 6,
        ),
      );
    }
    return polylines;
  }

  Set<Marker> getSampleMarkers() {
    return listPlacesSearchByCategories
        .map(
          (e) => Marker(
            markerId: const MarkerId('1'),
            position: LatLng(e.latitude ?? 0, e.longitude ?? 0),
          ),
        )
        .toSet();
  }

  Future<List<Favorite>> getFavoritePlaces(int pageKey, int pageSize) async {
    try {
      final response = await _baseApiServices.getGetApiResponseAuth(
        '${AppUrl.markFavoritePlaceEndpoint}?pagesize=$pageSize&pagenumber=$pageKey',
      );
      return (response['places']['data'] as List)
          .map((e) => Favorite.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future postFavoritePlace(int placeId) async {
    try {
      await _baseApiServices.getPostApiRepsonseAuth(
          '${AppUrl.markFavoritePlaceEndpoint}$placeId', {});
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isBookingPlace(int placeId) async {
    var result = false;
    var cart = <Place>[];
    try {
      await LocalStorageService.getInstance.getCartPlace().then((value) {
        cart = value;
        for (var item in cart) {
          if (item.id == placeId) {
            result = true;
            return result;
          }
        }
      });
    } catch (e) {
      rethrow;
    }
    return result;
  }

  Future<dynamic> getListBeaconsAtPlace(int placeId) async {
    try {
      var url = '${AppUrl.getPlaceItemEndpoint}/$placeId/items';
      var response = await _baseApiServices.getGetApiResponseAuth(url);
      print(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
