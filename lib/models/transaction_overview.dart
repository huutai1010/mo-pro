class TransactionOverview {
  int? id;
  int? bookingId;
  String? paymentMethod;
  // Null? customerName;
  String? description;
  double? amount;
  DateTime? createTime;
  DateTime? updateTime;
  int? status;
  String? statusName;
  String? statusType;
  String? paymentUrl;

  TransactionOverview({
    this.id,
    this.bookingId,
    this.paymentMethod,
    this.description,
    this.amount,
    this.createTime,
    this.updateTime,
    // this.customerName,
    this.status,
    this.statusName,
    this.statusType,
    this.paymentUrl,
  });

  factory TransactionOverview.fromJson(Map<String, dynamic> jsonData) =>
      TransactionOverview(
        id: jsonData['id'],
        bookingId: jsonData['bookingId'],
        paymentMethod: jsonData['paymentMethod'],
        // customerName: jsonData['customerName'],
        description: jsonData['description'],
        amount: jsonData['amount'],
        status: jsonData['status'],
        statusName: jsonData['statusName'],
        createTime: jsonData['createTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
        updateTime: jsonData['updateTime'] != null
            ? DateTime.parse(jsonData['createTime'])
            : null,
        statusType: jsonData['statusType'],
        paymentUrl: jsonData['paymentUrl'],
      );

  toJson() {}
}
