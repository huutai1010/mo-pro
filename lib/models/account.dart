import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

class Account {
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? phone;
  String? nationality;
  String? nationalCode;
  String? address;
  String? gender;
  int? roleId;
  int? languageId;
  String? languageCode;
  String? roleName;
  String? accessToken;
  int? id;
  late chat_types.User? chatUser;

  Account(
      {this.firstName,
      this.lastName,
      this.email,
      this.image,
      this.phone,
      this.nationality,
      this.address,
      this.gender,
      this.roleId,
      this.languageId,
      this.languageCode,
      this.roleName,
      this.accessToken,
      this.nationalCode,
      this.id});

  Account.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    nationality = json['nationality'];
    address = json['address'];
    gender = json['gender'];
    roleId = json['roleId'];
    languageId = json['languageId'];
    languageCode = json['languageCode'];
    nationalCode = json['nationalCode'];
    roleName = json['roleName'];
    accessToken = json['accessToken'];
    id = json['id'];
    final chatUsername = (json['email'] as String).split('@')[0];
    chatUser = chat_types.User(
      id: json['id'].toString(),
      metadata: {
        'phone': json['phone'],
        'username': chatUsername,
      },
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['image'] = image;
    data['phone'] = phone;
    data['nationality'] = nationality;
    data['address'] = address;
    data['gender'] = gender;
    data['roleId'] = roleId;
    data['languageId'] = languageId;
    data['languageCode'] = languageCode;
    data['nationalCode'] = nationalCode;
    data['roleName'] = roleName;
    //data['accessToken'] = accessToken;
    data['id'] = id;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
