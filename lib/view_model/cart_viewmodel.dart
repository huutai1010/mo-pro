import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:flutter/foundation.dart';

class CartViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  int size = 0;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  uploadSize(int newSize) {
    size = newSize;
  }

  Future<List<Place>> getCartPlace() async {
    var cart = <Place>[];
    await LocalStorageService.getInstance.getCartPlace().then((value) {
      if (value.isNotEmpty) {
        cart = value;
      }
    });
    return cart;
  }

  Future<double> getCartPrice() async {
    double price = 0.0;
    var places = <Place>[];
    await getCartPlace().then((value) => places = value);
    if (places.isNotEmpty) {
      for (var place in places) {
        price += place.price!;
      }
    }
    return price;
  }

  Future removeAllBookingItems() async {
    await LocalStorageService.getInstance.clearCart();
  }

  Future deletePlaceInCart(int placeId) async {
    await LocalStorageService.getInstance
        .deletePlaceInCart(placeId)
        .then((value) {
      loggerInfo.i('Removed placeId = $placeId');
    });
  }
}
