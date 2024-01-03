import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/repository/tour_repository.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const/const.dart';

class TourTrackingViewModel with ChangeNotifier {
  final _bookingRepo = BookingRepository();
  final _tourRepo = TourRepository();

  bool isFailed = false;
  bool _loading = false;
  bool get loading => _loading;
  bool notFeedback = true;
  List<String> times = [];
  final DateFormat timeFormat = DateFormat(kDateTimeFormat);

  setNotFeedback(bool value) {
    notFeedback = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setFailed(bool value) {
    isFailed = value;
    notifyListeners();
  }

  initTimes(List<Place> placesForTimeline) {
    setLoading(true);
    times = placesForTimeline.map((e) {
      if (e.startTime == null) {
        return '';
      }
      var dateObj = DateTime.parse(e.startTime!);
      return timeFormat.format(dateObj);
    }).toList();
    setLoading(false);
    notifyListeners();
  }

  _updateTimeAt(int index) {
    setLoading(true);
    var currentTime = DateTime.now();
    var formatted = timeFormat.format(currentTime);
    times[index] = formatted;
    setLoading(false);
    notifyListeners();
  }

  Future<dynamic> checkInPlace(
      int checkinStatus, int indexPlace, BuildContext context) async {
    dynamic checkInResult;
    return _bookingRepo
        .checkInPlace(checkinStatus, isFinish: indexPlace == times.length - 1)
        .then(
      (value) {
        checkInResult = value;
        return LocalStorageService.getInstance.getAccount();
      },
    ).then((account) {
      final authVm = Provider.of<AuthViewModel>(context, listen: false);
      authVm.submitToSocket('check-in', account!);
      if (times[indexPlace] == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 500),
            content: Text(context.tr(
              indexPlace == times.length - 1
                  ? 'checkin_the_last_place_successfully'
                  : 'checkin_successfully',
            )),
          ),
        );
        _updateTimeAt(indexPlace);
      }
      return checkInResult;
    });
  }

  Future<Place?> getDataPlaceVoiceScreen(int placeId) async {
    late Place? place;
    setLoading(true);
    await _bookingRepo.getDataPlaceVoiceScreen(placeId).then((value) {
      place = Place.fromJson(value['place']);
    });
    return place;
  }

  Future<Tour?> getTourdetailsToFeedback(int tourId) async {
    Tour? tour;
    setLoading(true);
    await _tourRepo.getTourDetailsToFeedback(tourId).then((value) {
      setLoading(false);
      tour = Tour.fromJson(value['tour']);
    });
    return tour;
  }
}
