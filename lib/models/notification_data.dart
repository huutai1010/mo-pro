import 'package:agora_chat_sdk/agora_chat_sdk.dart';

class NotificationTypes {
  static const int contactRequest = 1;
  static const int chat = 2;
  static const int paymentSuccessful = 3;
  static const int call = 4;
  static const int bookingCancelled = 5;

  static const int incomingMessage = 6;
}

class NotificationData {
  final int type;

  NotificationData({
    required this.type,
  });

  factory NotificationData.fromJson(Map<String, dynamic> jsonData) =>
      NotificationData(
        type: int.parse(jsonData['notificationType']),
      );
}

class ContactRequestNotificationData extends NotificationData {
  final int senderId;
  final String senderEmail;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;

  ContactRequestNotificationData({
    required this.senderId,
    required this.senderEmail,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
  }) : super(type: NotificationTypes.contactRequest);

  factory ContactRequestNotificationData.fromJson(
          Map<String, dynamic> jsonData) =>
      ContactRequestNotificationData(
        senderId: int.parse(jsonData['senderId']),
        senderEmail: jsonData['senderEmail'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
      );
}

class ChatNotificationData extends NotificationData {
  final int senderId;
  final String senderEmail;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;
  ChatNotificationData({
    required this.senderId,
    required this.senderEmail,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
  }) : super(type: NotificationTypes.chat);

  factory ChatNotificationData.fromJson(Map<String, dynamic> jsonData) =>
      ChatNotificationData(
        senderId: int.parse(jsonData['senderId']),
        senderEmail: jsonData['senderEmail'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
      );
}

class CallNotificationData extends NotificationData {
  final int senderId;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;
  final String channelId;
  final String callingToken;
  final String remoteUid;

  CallNotificationData({
    required this.senderId,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
    required this.channelId,
    required this.callingToken,
    required this.remoteUid,
  }) : super(type: NotificationTypes.call);

  factory CallNotificationData.fromJson(Map<String, dynamic> jsonData) =>
      CallNotificationData(
        senderId: jsonData['senderId'].runtimeType == String
            ? int.parse(jsonData['senderId'])
            : jsonData['senderId'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
        channelId: jsonData['channelId'],
        callingToken: jsonData['callingToken'],
        remoteUid: jsonData['remoteUid'],
      );

  toJson() => {
        'senderId': senderId,
        'senderPhone': senderPhone,
        'senderFirstName': senderFirstName,
        'senderLastName': senderLastName,
        'senderImage': senderImage,
        'channelId': channelId,
        'callingToken': callingToken,
        'remoteUid': remoteUid
      };
}

class PaymentSuccessfulNotificationData extends NotificationData {
  final int bookingId;
  PaymentSuccessfulNotificationData({
    required this.bookingId,
  }) : super(type: NotificationTypes.paymentSuccessful);

  factory PaymentSuccessfulNotificationData.fromJson(
      Map<String, dynamic> jsonData) {
    return PaymentSuccessfulNotificationData(
        bookingId: int.parse(jsonData['bookingId']));
  }
}

class BookingCancelledNotificationData extends NotificationData {
  final int bookingId;
  BookingCancelledNotificationData({
    required this.bookingId,
  }) : super(type: NotificationTypes.bookingCancelled);

  factory BookingCancelledNotificationData.fromJson(
      Map<String, dynamic> jsonData) {
    return BookingCancelledNotificationData(
        bookingId: int.parse(jsonData['bookingId']));
  }
}

class IncomingMessageNotificationData extends NotificationData {
  final ChatMessage chatMessage;

  IncomingMessageNotificationData({required this.chatMessage})
      : super(type: NotificationTypes.incomingMessage);

  factory IncomingMessageNotificationData.fromJson(
      Map<String, dynamic> jsonData) {
    return IncomingMessageNotificationData(
      chatMessage: ChatMessage.fromJson(jsonData['chatMessage']),
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'notificationType': type.toString(),
      'chatMessage': chatMessage,
    };
    return result;
  }
}
