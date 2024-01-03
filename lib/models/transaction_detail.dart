class TransactionItem {
  final int id;
  final int bookingId;
  final String paymentMethod;
  final String description;
  final double amount;
  final DateTime? createTime;
  final DateTime? updateTime;
  final int status;
  final String statusName;
  final TransactionBooking booking;
  final TransactionDetail details;

  const TransactionItem({
    required this.id,
    required this.bookingId,
    required this.paymentMethod,
    required this.description,
    required this.amount,
    this.createTime,
    this.updateTime,
    required this.status,
    required this.statusName,
    required this.booking,
    required this.details,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> jsonData) =>
      TransactionItem(
        id: jsonData['id'],
        bookingId: jsonData['bookingId'],
        paymentMethod: jsonData['paymentMethod'],
        description: jsonData['description'],
        amount: jsonData['amount'],
        status: jsonData['status'],
        statusName: jsonData['statusName'],
        createTime: jsonData['createTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
        updateTime: jsonData['updateTime'] != null
            ? DateTime.parse(jsonData['updateTime'])
            : null,
        booking: TransactionBooking.fromJson(jsonData['booking']),
        details: TransactionDetail.fromJson(jsonData['details']),
      );
}

class TransactionDetail {
  final int transactionId;
  String? paymentId;
  String? captureId;
  String? paymentAccountId;
  final String currency;
  final int status;
  final String statusName;
  final int id;
  DateTime? createTime;
  DateTime? updateTime;

  TransactionDetail({
    required this.transactionId,
    required this.status,
    required this.statusName,
    required this.id,
    required this.currency,
    this.paymentAccountId,
    this.paymentId,
    this.captureId,
    this.createTime,
    this.updateTime,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> jsonData) =>
      TransactionDetail(
        currency: "USD",
        paymentAccountId: jsonData['paymentAccountId'],
        paymentId: jsonData['paymentId'],
        captureId: jsonData['captureId'],
        transactionId: jsonData['transactionId'],
        status: jsonData['status'],
        statusName: jsonData['statusName'],
        id: jsonData['id'],
        createTime: jsonData['createTime'],
        updateTime: jsonData['updateTime'],
      );
}

class TransactionBooking {
  final int tourId;
  final bool isPrepared;
  final double total;
  final int totalPlaces;
  final DateTime? createTime;
  final int status;

  TransactionBooking({
    required this.tourId,
    required this.isPrepared,
    required this.total,
    required this.totalPlaces,
    this.createTime,
    required this.status,
  });

  factory TransactionBooking.fromJson(Map<String, dynamic> jsonData) =>
      TransactionBooking(
        tourId: jsonData['tourId'] ?? 0,
        isPrepared: jsonData['isPrepared'],
        total: jsonData['total'],
        totalPlaces: jsonData['totalPlaces'],
        createTime: jsonData['createTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
        status: jsonData['status'],
      );
}
