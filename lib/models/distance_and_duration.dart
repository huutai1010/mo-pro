class DistanceAndDuration {
  Infos? distance;
  Infos? duration;
  String? status;

  DistanceAndDuration({this.distance, this.duration, this.status});

  DistanceAndDuration.fromJson(Map<String, dynamic> json) {
    distance =
        json['distance'] != null ? Infos.fromJson(json['distance']) : null;
    duration =
        json['duration'] != null ? Infos.fromJson(json['duration']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Infos {
  String? text;
  int? value;

  Infos({this.text, this.value});

  Infos.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
