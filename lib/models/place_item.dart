class PlaceItem {
  final int id;
  final String name;
  final String beaconId;
  final int status;
  final int startTimeInMs;
  final int endTimeInMs;
  final String url;
  double? distance;
  PlaceItemDescription? description;

  PlaceItem({
    required this.id,
    required this.name,
    required this.beaconId,
    required this.status,
    required this.startTimeInMs,
    required this.endTimeInMs,
    required this.url,
    this.distance,
    this.description,
  });

  factory PlaceItem.fromJson(Map<String, dynamic> jsonData) {
    return PlaceItem(
      id: jsonData['id'],
      name: jsonData['name'],
      beaconId: jsonData['beaconId'],
      status: jsonData['status'],
      startTimeInMs: jsonData['startTimeInMs'],
      endTimeInMs: jsonData['endTimeInMs'],
      distance: jsonData['distance'] ?? 0.0,
      url: jsonData['url'] ?? jsonData['image'] ?? '',
      description: jsonData['itemDescriptions'] != null
          ? PlaceItemDescription.fromJson(
              (jsonData['itemDescriptions'] as List<dynamic>).firstOrNull,
            )
          : null,
    );
  }
}

class PlaceItemDescription {
  final String languageCode;
  final String name;
  final int id;
  final int itemId;

  PlaceItemDescription({
    required this.languageCode,
    required this.name,
    required this.id,
    required this.itemId,
  });

  factory PlaceItemDescription.fromJson(Map<String, dynamic> jsonData) {
    return PlaceItemDescription(
      languageCode: jsonData['languageCode'],
      name: jsonData['nameItem'],
      id: jsonData['id'],
      itemId: jsonData['placeItemId'],
    );
  }
}
