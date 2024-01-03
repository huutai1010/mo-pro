class FeedBacks {
  int? accountId;
  String? firstName;
  String? lastName;
  String? image;
  String? nationalImage;
  int? placeId;
  int? tourId;
  double? rate;
  String? content;
  String? createTime;
  bool? isPlace;
  int? id;

  FeedBacks(
      {this.accountId,
      this.firstName,
      this.lastName,
      this.image,
      this.placeId,
      this.nationalImage,
      this.tourId,
      this.rate,
      this.content,
      this.createTime,
      this.isPlace,
      this.id});

  FeedBacks.fromJson(Map<String, dynamic> json) {
    accountId = json['accountId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    placeId = json['placeId'];
    tourId = json['tourId'];
    rate = json['rate'];
    content = json['content'];
    createTime = json['createTime'];
    nationalImage = json['nationalImage'];
    isPlace = json['isPlace'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['image'] = image;
    data['placeId'] = placeId;
    data['tourId'] = tourId;
    data['rate'] = rate;
    data['content'] = content;
    data['createTime'] = createTime;
    data['nationalImage'] = nationalImage;
    data['isPlace'] = isPlace;
    data['id'] = id;
    return data;
  }
}
