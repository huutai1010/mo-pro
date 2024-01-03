import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import '../../configs/agora_options.dart';
import '../../repository/people_repository.dart';

class VideoCallView extends StatefulWidget {
  final String token;
  final int remoteUid;
  final int localUid;
  final String channelName;
  final bool autoJoinCall;
  final bool isJoinedThroughNotification;
  final Function? onDisconnect;
  const VideoCallView({
    super.key,
    required this.token,
    required this.remoteUid,
    required this.localUid,
    required this.channelName,
    this.isJoinedThroughNotification = false,
    this.autoJoinCall = true,
    this.onDisconnect,
  });

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  late AgoraClient client;
  showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    client = AgoraClient(
        agoraEventHandlers: AgoraRtcEventHandlers(
          onUserOffline: (connection, remoteUid, reason) {
            if (widget.onDisconnect != null) {
              widget.onDisconnect!();
            }
            Navigator.of(context).pop();
          },
        ),
        agoraConnectionData: AgoraConnectionData(
          appId: AgoraChatConfig.appId,
          channelName: widget.channelName,
          tempToken: widget.token,
          rtmEnabled: false,
          uid: widget.localUid,
        ));

    client.initialize();

    if (!widget.isJoinedThroughNotification && context.mounted) {
      PeopleRepository().sendNotificationApi(4, widget.remoteUid);
    }
  }

  @override
  void dispose() async {
    client.release();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          AgoraVideoViewer(
            client: client,
            layoutType: Layout.oneToOne,
          ),
          AgoraVideoButtons(
            onDisconnect: () {
              if (widget.onDisconnect != null) {
                widget.onDisconnect!();
              }
              Navigator.of(context).pop();
            },
            client: client,
          ),
        ],
      ),
    ));
  }
}
