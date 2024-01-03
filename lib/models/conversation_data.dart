class ConversationData {
  final int accountOneId;
  final String accountOneUsername;
  final String accountOneFirstName;
  final String accountOneLastName;
  final String accountOneImage;
  final String accountOnePhone;
  final int accountTwoId;
  final String accountTwoUsername;
  final String accountTwoFirstName;
  final String accountTwoPhone;
  final String accountTwoLastName;
  final String accountTwoImage;

  ConversationData({
    required this.accountOneId,
    required this.accountOneFirstName,
    required this.accountOneImage,
    required this.accountOnePhone,
    required this.accountOneLastName,
    required this.accountOneUsername,
    required this.accountTwoFirstName,
    required this.accountTwoId,
    required this.accountTwoImage,
    required this.accountTwoPhone,
    required this.accountTwoLastName,
    required this.accountTwoUsername,
  });

  factory ConversationData.fromJson(Map<String, dynamic> jsonData) {
    return ConversationData(
      accountOneId: jsonData['accountOneId'],
      accountOneFirstName: jsonData['accountOneFirstName'],
      accountOneImage: jsonData['accountOneImage'],
      accountOneLastName: jsonData['accountOneLastName'],
      accountOneUsername: jsonData['accountOneUsername'],
      accountOnePhone: jsonData['accountOnePhone'],
      accountTwoFirstName: jsonData['accountTwoFirstName'],
      accountTwoId: jsonData['accountTwoId'],
      accountTwoImage: jsonData['accountTwoImage'],
      accountTwoLastName: jsonData['accountTwoLastName'],
      accountTwoUsername: jsonData['accountTwoUsername'],
      accountTwoPhone: jsonData['accountTwoPhone'],
    );
  }
}
