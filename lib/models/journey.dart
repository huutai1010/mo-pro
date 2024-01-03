import 'package:etravel_mobile/models/place.dart';

class Journey {
  String? startTime;
  String? endTime;
  double? totalTime;
  double? totalDistance;
  String? firstPlaceName;
  String? lastPlaceName;
  int? status;
  String? statusName;
  int? tourId;
  int? id;
  late List<Place> bookingPlaces;

  Journey({
    this.startTime,
    this.endTime,
    this.totalTime,
    this.totalDistance,
    this.firstPlaceName,
    this.lastPlaceName,
    this.status,
    this.statusName,
    this.tourId,
    this.id,
    this.bookingPlaces = const [],
  });

  Journey.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalTime = json['totalTime'];
    totalDistance = json['totalDistance'];
    firstPlaceName = json['firstPlaceName'];
    lastPlaceName = json['lastPlaceName'];
    status = json['status'];
    statusName = json['statusName'];
    tourId = json['tourId'];
    id = json['id'];
    if (json['bookingPlaces'] != null) {
      bookingPlaces = <Place>[];
      json['bookingPlaces'].forEach((v) {
        bookingPlaces!.add(Place.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['totalTime'] = totalTime;
    data['totalDistance'] = totalDistance;
    data['status'] = status;
    data['statusName'] = statusName;
    data['id'] = id;
    return data;
  }
}
