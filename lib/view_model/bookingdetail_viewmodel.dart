import 'package:etravel_mobile/data/app_exception.dart';
import 'package:etravel_mobile/models/booking.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:flutter/foundation.dart';

class BookingDetailViewModel with ChangeNotifier {
  final _bookingRepo = BookingRepository();
  bool _loading = false;
  bool get loading => _loading;
  bool isFailed = false;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setFailed(bool value) {
    isFailed = value;
    notifyListeners();
  }

  Future<Booking?> getBookingDetail(int id) async {
    late Booking? booking;
    try {
      await _bookingRepo.getBookingDetail(id).then((value) {
        setLoading(false);
        if (value['booking'] != null) {
          booking = Booking.fromJson(value['booking']);
        }
      }).onError((error, stackTrace) {
        setLoading(false);
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } on InternetServerException catch (_) {
      setFailed(true);
    } on RequestTimeoutException catch (_) {
      setFailed(true);
    } on NotFoundException catch (_) {
      setFailed(true);
    }

    return booking;
  }

  Future cancelBooking(int bookingId) async {
    setLoading(true);
    await _bookingRepo.cancelBooking(bookingId);
    setLoading(false);
  }
}
