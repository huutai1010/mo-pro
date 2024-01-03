import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../models/place_item.dart';
import '../res/strings/app_url.dart';

class PlaceItemRepository {
  final BaseApiServices _baseApiServices = NetworkApiService();

  Future<List<PlaceItem>> getPlaceItems(int placeId) async {
    try {
      dynamic response = await _baseApiServices.getGetApiResponseAuth(
        AppUrl.getPlaceItems.replaceAll(
          '{placeId}',
          placeId.toString(),
        ),
      );
      return (response['placeItems'] as List<dynamic>)
          .map((e) => PlaceItem.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<PlaceItem> getPlaceItemDetails(int placeItemId) async {
    dynamic response = await _baseApiServices
        .getGetApiResponseAuth('${AppUrl.getPlaceItemDetails}/$placeItemId');
    return PlaceItem.fromJson(response['placeItem']);
  }
}
