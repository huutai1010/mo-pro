import 'package:etravel_mobile/data/app_exception.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/repository/tour_repository.dart';
import 'package:etravel_mobile/view/payment/choosepayment_view.dart';
import 'package:flutter/material.dart';

class TourDetailViewModel with ChangeNotifier {
  final _tourRepo = TourRepository();
  bool _loading = false;
  bool get loading => _loading;
  bool isFailed = false;

  setFailed(bool value) {
    isFailed = value;
    notifyListeners();
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future bookTour(BuildContext context, List<Place> places, int tourId,
      double price) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChoosePaymentView(places: places, tourId: tourId, price: price),
      ),
    );
  }

  Future<Tour?> getTourdetail(tourId) async {
    Tour? tour;
    try {
      await _tourRepo.getTourDetails(tourId).then((value) {
        setLoading(false);
        if (value['tour'] != null) {
          tour = Tour.fromJson(value['tour']);
        }
      });
    } on InternetServerException catch (_) {
      setFailed(true);
    } on RequestTimeoutException catch (_) {
      setFailed(true);
    } on NotFoundException catch (_) {
      setFailed(true);
    }
    return tour;
  }
}
