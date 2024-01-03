import 'package:etravel_mobile/const/apiKey.dart';
import 'package:flutter/foundation.dart';

class AppUrl {
  static get baseUrl => kReleaseMode
      ? 'https://etravelapi.azurewebsites.net'
      : 'http://192.168.1.15:8000';

  static var socketBaseUrl =
      'https://etravel-tracking-location.azurewebsites.net';

  static var phoneLoginEndpoint = '$baseUrl/api/auth/user/login';

  static var getCurrentProfileEndpoint = '$baseUrl/api/auth/me';

  static var updateCurrentProfileEndpoint = '$baseUrl/api/auth/me';

  static var loginEndPoint = '$baseUrl/api/auth/user/login';

  static var getPlaceItemEndpoint = '$baseUrl/api/places';

  static var registerEndPoint = '$baseUrl/api/auth/register';

  static var getLanguagesEndpoint = '$baseUrl/api/languages';

  static var changeLanguageEndpoint = '$baseUrl/api/auth/languages';

  static var getPlacesAroundEndpoint = '$baseUrl/api/places/nearby';

  static var searchPlacesEndpoint = '$baseUrl/api/places/search?category=';

  static var topPlaceEndpoint = '$baseUrl/api/places/top?top=10';

  static var topTourEndpoint = '$baseUrl/api/itineraries/top?top=10';

  static var placeDetailsEndpoint = '$baseUrl/api/places';

  static var tourDetailsEndpoint = '$baseUrl/api/itineraries';

  static var getFeedbackEndpoint = '$baseUrl/api/feedbacks';

  static var createFeedbackEnpoint = '$baseUrl/api/feedbacks';

  static var getCategoriesEndpoint = '$baseUrl/api/categories?languageCode=';

  static var markFavoritePlaceEndpoint = '$baseUrl/api/accounts/mark-place/';

  static var getFavoritePlaceEndpoint = '$baseUrl/api/accounts/mark-place';

  static var pushNotificationEndpoint = '$baseUrl/notification';

  static var createConversationEndpoint = '$baseUrl/api/conversations';

  static var getConversationsEndpoint = '$baseUrl/api/conversations';
  static var getConversationEndpoint =
      '$baseUrl/api/conversations/{from}/to/{to}';
  static var postChatMessageEndpoint = '$baseUrl/api/conversations/chat';

  static var postConversationsEndpoint = '$baseUrl/api/conversations';

  static var getCelebratedPlaceEndpoint = '$baseUrl/api/bookings/celebrated';

  static var createCelebratedPlaceEndpoint = '$baseUrl/api/bookings/celebrated';

  static var getVideoCallDetailsEndpoint = '$baseUrl/api/conversations/call';

  static var getAccountsEndpoint = '$baseUrl/api/accounts?pagesize=10000';

  static var getNearbyAccountsEndpoint = '$baseUrl/api/accounts/nearby';

  static var postCallEndpoint = '$baseUrl/api/conversations/call';

  static var postNotificationEndpoint = '$baseUrl/notification';

  static var getTransactionsEndpoint = '$baseUrl/api/transactions';

  static var postBookingEndpoint = '$baseUrl/api/bookings';

  static var getNationalitiesEndpoint = '$baseUrl/api/nationalities';

  static var getHistoryBookingsEndPoint = '$baseUrl/api/history/bookings';

  static var getBookingDetail = '$baseUrl/api/history/bookings/information';

  static var getListPlacesEndpoint = '$baseUrl/api/places';

  static var getJourneysByStatusEndpoint =
      '$baseUrl/api/history/bookings/journeys/status';

  static var getPlacesBookingByStatus = '$baseUrl/api/history/bookings/place';

  // Google Map APIs
  static var googleMapHost = 'https://maps.googleapis.com/maps/api';

  static var calculateDistanceAndTimeEndpoint =
      '$googleMapHost/distancematrix/json?key=$apiKey';

  static var routeEndpoint = '$googleMapHost/directions/json?key=$apiKey';

  static var createJourneyEndpoint = '$baseUrl/api/bookings/journey';

  static var getJourneyDetailsEndPoint =
      '$baseUrl/api/history/bookings/journey';

  static var checkinEndpoint = '$baseUrl/api/checkin';

  static var updateJourneyStatusEndPoint =
      '$baseUrl/api/history/bookings/journey';

  static var getVoiceEndPoint = '$baseUrl/api/history/bookings/place';

  // Goong api
  static var goongMapHost = 'https://rsapi.goong.io';

  static var calculateDistanceAndTimeGoongEndpoint =
      '$goongMapHost/DistanceMatrix?api_key=$goongApiKey';

  static var routeGoongEndpoint =
      '$goongMapHost/Direction?api_key=$goongApiKey';

  static var getListToursEndpoint = '$baseUrl/api/itineraries';

  static var getPlaceItems = '$baseUrl/api/places/{placeId}/items';

  static var getPlaceItemDetails = '$baseUrl/api/places/placeItems';

  static var getTourDetailToFeedbackEndpoint =
      '$baseUrl/api/itineraries/feedbacks';

  static var cancelBookingEndpoint = '$baseUrl/api/bookings';
}
