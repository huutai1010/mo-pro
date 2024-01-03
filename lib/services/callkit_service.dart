import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

import '../models/notification_data.dart';
import 'logger_service.dart';
import '../models/account.dart';
import '../view/conversation/video_call_view.dart';

const uuid = Uuid();

class CallkitService {
  static final CallkitService _callkitService = CallkitService._internal();

  factory CallkitService() {
    return _callkitService;
  }

  CallkitService._internal();

  void closeCallkit(StreamSubscription<CallEvent?> streamSubscription) async {
    await streamSubscription.cancel();
  }

  Future<StreamSubscription<CallEvent?>?> initializeCallkit(
      Account accountSender, GlobalKey<NavigatorState> navigatorKey) async {
    return FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event!.event) {
        case Event.actionCallIncoming:
          break;
        case Event.actionCallAccept:
          final Map<String, dynamic> eventExtraData =
              Map<String, dynamic>.from(event.body['extra'] as Map);
          final notificationData =
              CallNotificationData.fromJson(eventExtraData);

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
          break;
        default:
          break;
      }
    });
  }

  void receiveCall(CallNotificationData data) async {
    loggerInfo.i('receiveCall');
    final callerName = '${data.senderFirstName} ${data.senderLastName}';
    CallKitParams callKitParams = CallKitParams(
      id: uuid.v4(),
      nameCaller: callerName,
      appName: 'eTravel',
      avatar: data.senderImage,
      type: 1,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      extra: data.toJson(),
      android: AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: data.senderImage,
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }
}
