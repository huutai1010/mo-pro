class Language {
  String? name;
  String? icon;
  String? fileLink;
  String? languageCode;
  String? createTime;
  String? updateTime;
  int? status;
  int? id;

  Language(
      {this.name,
      this.icon,
      this.fileLink,
      this.languageCode,
      this.createTime,
      this.updateTime,
      this.status,
      this.id});

  Language.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    fileLink = json['fileLink'];
    languageCode = json['languageCode'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['fileLink'] = fileLink;
    data['languageCode'] = languageCode;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['status'] = status;
    data['id'] = id;
    return data;
  }

  @override
  operator ==(Object other) {
    return other is Language && other.id == id;
  }

  @override
  int get hashCode => super.hashCode;
}
