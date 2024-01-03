class Nationality {
  final String phoneCode;
  final String nationalCode;
  final String nationalName;
  final String icon;
  final String languageName;

  Nationality({
    required this.phoneCode,
    required this.nationalCode,
    required this.nationalName,
    required this.icon,
    required this.languageName,
  });

  factory Nationality.fromJson(Map<String, dynamic> jsonData) => Nationality(
        phoneCode: jsonData['phoneCode'],
        nationalCode: jsonData['nationalCode'],
        nationalName: jsonData['nationalName'],
        icon: jsonData['icon'],
        languageName: jsonData['languageName'],
      );
}
