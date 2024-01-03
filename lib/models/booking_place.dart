class BookingPlaces {
  int? bookingPlaceId;
  int? placeId;
  int? journeyId;
  String? placeName;
  double? longitude;
  double? latitude;
  String? googlePlaceId;
  double? price;
  String? placeImage;
  // String? startTime;
  int? ordinal;
  int? status;
  String? statusName;

  BookingPlaces({
    this.bookingPlaceId,
    this.placeId,
    this.journeyId,
    this.placeName,
    this.longitude,
    this.latitude,
    this.googlePlaceId,
    this.price,
    this.placeImage,
    // this.startTime,
    this.ordinal,
    this.status,
    this.statusName,
  });

  BookingPlaces.fromJson(Map<String, dynamic> json) {
    bookingPlaceId = json['bookingPlaceId'];
    placeId = json['placeId'];
    journeyId = json['journeyId'];
    placeName = json['placeName'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    googlePlaceId = json['googlePlaceId'];
    price = json['price'];
    placeImage = json['placeImage'];
    // startTime = json['startTime'];
    ordinal = json['ordinal'];
    status = json['status'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingPlaceId'] = bookingPlaceId;
    data['placeId'] = placeId;
    data['journeyId'] = journeyId;
    data['placeName'] = placeName;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['googlePlaceId'] = googlePlaceId;
    data['price'] = price;
    // data['startTime'] = startTime;
    data['ordinal'] = ordinal;
    data['status'] = status;
    data['statusName'] = statusName;
    return data;
  }
}
