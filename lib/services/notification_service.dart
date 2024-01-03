import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/notification_data.dart';
import 'package:etravel_mobile/repository/people_repository.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

import '../repository/conversation_repository.dart';
import '../view/booking/booking_detail_view.dart';
import '../view/conversation/chat_view.dart';
import '../view/conversation/video_call_view.dart';
import 'local_storage_service.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get initializationSettings => const InitializationSettings(
          android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ));

  Future<void> initialize(
    Function(NotificationResponse) onDidReceiveNotificationResponse,
  ) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  List<AndroidNotificationAction>? _getNotificationActions(
      int? notificationType) {
    switch (notificationType) {
      case 1: // Send request
        return [
          const AndroidNotificationAction(
            'accept',
            'Accept',
          ),
          const AndroidNotificationAction(
            'reject',
            'Reject',
          ),
        ];
      default:
        return null;
    }
  }

  Future<bool> ensurePermissionsGranted() async {
    final isGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    return isGranted ?? false;
  }

  void showChatNotification(ChatMessage chatMessage) async {
    final showNotificationGranted = await ensurePermissionsGranted();
    if (!showNotificationGranted) {
      return;
    }
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'etravel_notification',
        'eTravel Notification',
        channelDescription: 'eTravel Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    );
    String body = "";
    ChatMessageBody chatBody = chatMessage.body;
    if (chatBody is ChatTextMessageBody) {
      body = chatBody.content;
    }
    if (chatBody is ChatImageMessageBody) {
      body = "${chatMessage.from} sends you an image";
    }
    flutterLocalNotificationsPlugin.show(
      chatMessage.msgId.hashCode,
      chatMessage.from,
      body,
      details,
      payload: json.encode(
          IncomingMessageNotificationData(chatMessage: chatMessage).toJson()),
    );
  }

  void _showNotification(
    BuildContext ctx,
    RemoteMessage message, {
    String? title,
    String? body,
  }) async {
    final showNotificationGranted = await ensurePermissionsGranted();
    if (!showNotificationGranted) {
      return;
    }
    final notificationData = NotificationData.fromJson(message.data);
    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'etravel_notification',
        'eTravel Notification',
        channelDescription: 'eTravel Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        actions: _getNotificationActions(
          notificationData.type,
        ),
      ),
    );
    if (ctx.mounted) {
      flutterLocalNotificationsPlugin.show(
        message.messageId.hashCode,
        title ?? ctx.tr(message.notification!.title!),
        body ??
            ctx.tr(
              message.notification!.body!,
            ),
        details,
        payload: json.encode(message.data),
      );
    }
  }

  void _onContactRequestNotificationDataClicked(
    ContactRequestNotificationData notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }
    try {
      await ConversationRepository().postConversation({
        'accountOneId': accountSender.id,
        'accountTwoId': notificationData.senderId,
      });
    } catch (e) {
      // Do something if conversation exists
    }

    final senderUsername = accountSender.email!.split('@')[0]; // Current user
    final receiverUsername = notificationData.senderEmail
        .split('@')[0]; // User sends notification to

    await ConversationRepository()
        .sendChatMessage(receiverUsername, senderUsername, "👋");

    await PeopleRepository()
        .sendNotificationApi(NotificationTypes.chat, notificationData.senderId);
  }

  void _onPaymentSuccessfulNotificationDataClicked(
      PaymentSuccessfulNotificationData notificationData,
      GlobalKey<NavigatorState> navigatorKey) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (ctx) {
        return BookingDetailView(
          id: notificationData.bookingId,
          statusName: '',
        );
      }),
    );
  }

  void _onBookingCancelledNotificationDataClicked(
      BookingCancelledNotificationData notificationData,
      GlobalKey<NavigatorState> navigatorKey) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (ctx) {
        return BookingDetailView(
          id: notificationData.bookingId,
          statusName: '',
        );
      }),
    );
  }

  void _onCallNotificationDataClicked(
    CallNotificationData notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (ctx) => VideoCallView(
          localUid: accountSender.id!,
          autoJoinCall: false,
          isJoinedThroughNotification: true,
          token: notificationData.callingToken,
          channelName: notificationData.channelId,
          remoteUid: int.parse(
            notificationData.remoteUid,
          ),
        ),
      ),
    );
  }

  _onChatNotificationClicked(
    ChatNotificationData notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }

    final senderUsername = accountSender.email!.split('@')[0]; // Current user
    final receiverUsername = notificationData.senderEmail
        .split('@')[0]; // User sends notification to

    final sender = chat_types.User(
      id: accountSender.id.toString(),
      metadata: {
        'phone': accountSender.phone,
        'username': senderUsername,
      },
      firstName: accountSender.firstName,
      lastName: accountSender.lastName,
      imageUrl: accountSender.image,
    );

    final receiver = chat_types.User(
      id: notificationData.senderId.toString(),
      metadata: {
        'phone': notificationData.senderPhone,
        'username': receiverUsername,
      },
      firstName: notificationData.senderFirstName,
      lastName: notificationData.senderLastName,
      imageUrl: notificationData.senderImage,
    );

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (ctx) => ChatView(
          sender: sender,
          receiver: receiver,
        ),
      ),
    );
  }

  Future<void> onClickNotification(GlobalKey<NavigatorState> navigatorKey,
      NotificationResponse response) async {
    final decodedPayload = json.decode(response.payload!);
    final notificationData = NotificationData.fromJson(decodedPayload);

    switch (notificationData.type) {
      case NotificationTypes.contactRequest:
        final notificationData =
            ContactRequestNotificationData.fromJson(decodedPayload);
        _onContactRequestNotificationDataClicked(
            notificationData, navigatorKey);
        break;
      case NotificationTypes.call:
        final notificationData = CallNotificationData.fromJson(decodedPayload);
        _onCallNotificationDataClicked(notificationData, navigatorKey);
      case NotificationTypes.paymentSuccessful:
        final notificationData =
            PaymentSuccessfulNotificationData.fromJson(decodedPayload);
        _onPaymentSuccessfulNotificationDataClicked(
            notificationData, navigatorKey);
      case NotificationTypes.bookingCancelled:
        final notificationData =
            BookingCancelledNotificationData.fromJson(decodedPayload);
        _onBookingCancelledNotificationDataClicked(
            notificationData, navigatorKey);
      case NotificationTypes.chat:
        final notificationData = ChatNotificationData.fromJson(decodedPayload);
        _onChatNotificationClicked(notificationData, navigatorKey);
      case NotificationTypes.incomingMessage:
        final notificationData =
            IncomingMessageNotificationData.fromJson(decodedPayload);
        _onIncomingMessageNotificationClicked(notificationData, navigatorKey);
      default:
        break;
    }
  }

  void handleFirebaseNotification(RemoteMessage message, BuildContext ctx) {
    final notificationBasicData = NotificationData.fromJson(message.data);
    switch (notificationBasicData.type) {
      case NotificationTypes.call:
        final callNotificationData =
            CallNotificationData.fromJson(message.data);
        CallkitService().receiveCall(callNotificationData);
        break;
      case NotificationTypes.chat:
      case NotificationTypes.contactRequest:
      case NotificationTypes.paymentSuccessful:
        _showNotification(ctx, message);
        break;
      case NotificationTypes.bookingCancelled:
        final bookingCancelledNotificationData =
            BookingCancelledNotificationData.fromJson(message.data);

        final body = ctx.tr(message.notification!.body!).replaceAll(
            '{0}', bookingCancelledNotificationData.bookingId.toString());
        _showNotification(ctx, message, body: body);
        break;
      default:
        break;
    }
  }

  void _onIncomingMessageNotificationClicked(
      IncomingMessageNotificationData notificationData,
      GlobalKey<NavigatorState> navigatorKey) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }

    final conversation = await ConversationRepository().getConversationApi(
        notificationData.chatMessage.from!, notificationData.chatMessage.to!);

    final sender = chat_types.User(
      id: accountSender.id.toString(),
      metadata: {
        'phone': accountSender.phone,
        'username': accountSender.email!.split('@')[0],
      },
      firstName: accountSender.firstName,
      lastName: accountSender.lastName,
      imageUrl: accountSender.image,
    );

    final receiver = chat_types.User(
      id: conversation.accountOneId.toString(),
      metadata: {
        'username': conversation.accountOneUsername.split('@')[0],
        'phone': conversation.accountOnePhone,
      },
      firstName: conversation.accountOneFirstName,
      lastName: conversation.accountOneLastName,
      imageUrl: conversation.accountOneImage,
    );

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (ctx) => ChatView(
          sender: sender,
          receiver: receiver,
        ),
      ),
    );
  }
}
