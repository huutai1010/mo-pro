import 'dart:io';

import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class VoiceViewModel with ChangeNotifier {
  final _bookingRepo = BookingRepository();
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future checkInPlace(int checkinPlaceId) async {
    await _bookingRepo.checkInPlace(checkinPlaceId).then((value) {});
  }

  Future<Place?> getDataPlaceVoiceScreen(int placeId) async {
    Place? place;
    await _bookingRepo.getDataPlaceVoiceScreen(placeId).then((value) {
      place = Place.fromJson(value['place']);
    });
    return place;
  }

  Future postCelebratedImage(
      int bookingPlaceId, MultipartFile multipartFile) async {
    await _bookingRepo.postCelebratedImage(bookingPlaceId, multipartFile);
  }
}
