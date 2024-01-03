import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/place_image.dart';

class Tour {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  double? total;
  double? rate;
  List<Place>? places;
  List<FeedBacks>? feedBacks;
  List<PlaceImages>? placeImages;
  Map<String, double>? exchanges;
  int? reviewsCount;

  Tour({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.total,
    this.rate,
    this.places,
    this.feedBacks,
    this.placeImages,
    this.exchanges,
    this.reviewsCount,
  });

  Tour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    total = json['total'];
    rate = json['rate'];
    if (json['places'] != null) {
      places = <Place>[];
      json['places'].forEach((v) {
        places!.add(Place.fromJson(v));
      });
    }
    if (json['feedBacks'] != null) {
      feedBacks = <FeedBacks>[];
      json['feedBacks'].forEach((v) {
        feedBacks!.add(FeedBacks.fromJson(v));
      });
    }
    if (json['placeImages'] != null) {
      placeImages = <PlaceImages>[];
      json['placeImages'].forEach((v) {
        placeImages!.add(PlaceImages.fromJson(v));
      });
    }
    exchanges = (json['exchanges'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, value),
    );
    reviewsCount = json['reviewsCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['total'] = total;
    data['rate'] = rate;
    if (places != null) {
      data['places'] = places!.map((v) => v.toJson()).toList();
    }
    if (feedBacks != null) {
      data['feedBacks'] = feedBacks!.map((v) => v.toJson()).toList();
    }
    if (placeImages != null) {
      data['placeImages'] = placeImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
