import 'dart:convert';
import '../models/account.dart';
import '../models/place.dart';
import 'logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService getInstance = LocalStorageService();

  Future saveAccountInfo(Account account) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accountInfo = jsonEncode(account.toJson());
    sharedPreferences.setString('account', accountInfo);
  }

  Future saveLanguageCode(String languageCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('languageCode', languageCode);
  }

  Future<String> getLanguageCode() async {
    late String languageCode;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    languageCode = sharedPreferences.getString('languageCode') ?? '';
    return languageCode;
  }

  Future<Account?> getAccount() async {
    Account? account;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accountInfo = sharedPreferences.getString('account');
    if (accountInfo != null) {
      account = Account.fromJson(jsonDecode(accountInfo));
      loggerInfo.i(
          'Get account from local storage: ${account.firstName} ${account.lastName}');
    } else {
      loggerInfo.e('No account from storage');
    }
    return account;
  }

  Future removeAccountData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('account');
    Account? account = await getAccount();
    if (account == null) {
      loggerInfo.i('Clear account from storage successfully!');
    } else {
      loggerInfo.e('Clear account from storage unsuccessfully!');
    }
  }

  Future clearCart() async {
    var phone = '';
    var cartPlace = <Map<String, dynamic>>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    sharedPreferences.setString('cartPlace$phone', jsonEncode(cartPlace));
  }

  Future addToCartPlace(Place bookingItem) async {
    var cart = <Map<String, dynamic>>[];
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) {
      phone = account?.phone ?? '';
    });
    cart.add(bookingItem.toJson());
    await getCartPlace().then((places) {
      if (places.isNotEmpty) {
        for (var item in places) {
          cart.add(item.toJson());
        }
      }
      sharedPreferences.setString('cartPlace$phone', jsonEncode(cart));
    });
  }

  Future<List<Place>> getCartPlace() async {
    var cart = <Place>[];
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    var cartString = sharedPreferences.getString('cartPlace$phone');
    if (cartString != null) {
      var listBookingItems = jsonDecode(cartString);
      listBookingItems.forEach((bookingItem) {
        var place = Place.fromJson(bookingItem);
        cart.add(place);
      });
    }
    return cart;
  }

  Future deletePlaceInCart(int placeId) async {
    var cartPlace = <Place>[];
    await getCartPlace().then((value) async {
      cartPlace = value;
      for (var place in cartPlace) {
        if (place.id == placeId) {
          cartPlace.remove(place);
          await _updateCartPlace(cartPlace);
          break;
        }
      }
    });
  }

  Future _updateCartPlace(List<Place> places) async {
    var phone = '';
    var newCartPlace = <Map<String, dynamic>>[];
    for (var place in places) {
      newCartPlace.add(place.toJson());
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    await sharedPreferences.setString(
        'cartPlace$phone', jsonEncode(newCartPlace));
  }

  Future saveUserJourneyRoutes(List<String> routes, int journeyId) async {
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    await sharedPreferences.setStringList('${phone}journey$journeyId', routes);
  }

  Future<List<String>> getUserJourneyRoutes(int journeyId) async {
    var routes = <String>[];
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    routes = sharedPreferences.getStringList('${phone}journey$journeyId') ?? [];
    return routes;
  }
}
