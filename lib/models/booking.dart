import 'package:etravel_mobile/models/booking_place.dart';
import 'package:etravel_mobile/models/place_image.dart';
import 'package:etravel_mobile/models/transaction_overview.dart';

class Booking {
  int? tourId;
  bool? isPrepared;
  String? firstPlaceName;
  String? lastPlaceName;
  double? total;
  int? totalPlaces;
  DateTime? createTime;
  String? updateTime;
  int? status;
  String? statusName;
  int? id;
  List<BookingPlaces>? bookingPlaces;
  List<TransactionOverview>? transactions;
  List<PlaceImages>? placeImages;

  Booking({
    this.tourId,
    this.isPrepared,
    this.firstPlaceName,
    this.lastPlaceName,
    this.total,
    this.totalPlaces,
    this.createTime,
    // this.updateTime,
    this.status,
    this.statusName,
    this.bookingPlaces,
    this.transactions,
    this.id,
    this.placeImages,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    tourId = json['tourId'] ?? 0;
    isPrepared = json['isPrepared'];
    firstPlaceName = json['firstPlaceName'];
    lastPlaceName = json['lastPlaceName'];
    total = json['total'];
    totalPlaces = json['totalPlaces'];
    createTime = DateTime.parse(json['createTime']);
    // updateTime = json['updateTime'];
    status = json['status'];
    statusName = json['statusName'];
    id = json['id'];
    if (json['bookingPlaces'] != null) {
      bookingPlaces = <BookingPlaces>[];
      json['bookingPlaces'].forEach((v) {
        bookingPlaces!.add(BookingPlaces.fromJson(v));
      });
    }
    if (json['transactions'] != null) {
      transactions = <TransactionOverview>[];
      json['transactions'].forEach((v) {
        transactions!.add(TransactionOverview.fromJson(v));
      });
    }
    if (json['placeImages'] != null) {
      placeImages = <PlaceImages>[];
      json['placeImages'].forEach((v) {
        placeImages!.add(PlaceImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tourId'] = tourId;
    data['isPrepared'] = isPrepared;
    data['firstPlaceName'] = firstPlaceName;
    data['lastPlaceName'] = lastPlaceName;
    data['total'] = total;
    data['totalPlaces'] = totalPlaces;
    data['createTime'] = createTime;
    // data['updateTime'] = updateTime;
    data['status'] = status;
    data['statusName'] = statusName;
    data['id'] = id;
    if (bookingPlaces != null) {
      data['bookingPlaces'] = bookingPlaces!.map((v) => v.toJson()).toList();
    }
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
