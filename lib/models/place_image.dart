class PlaceImages {
  int? id;
  int? placeId;
  String? url;
  bool? isPrimary;

  PlaceImages({this.id, this.placeId, this.url, this.isPrimary});

  PlaceImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    placeId = json['placeId'];
    url = json['url'] ?? json['imageUrl'];
    isPrimary = json['isPrimary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['placeId'] = placeId;
    data['url'] = url;
    data['isPrimary'] = isPrimary;
    return data;
  }
}
