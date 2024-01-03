import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../conversation/chat_view.dart';
import '../../services/local_storage_service.dart';

class ChatItem extends StatefulWidget {
  final chat_types.User receiver;
  final ChatConversation convData;
  const ChatItem({
    super.key,
    required this.receiver,
    required this.convData,
  });

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  String? _parseDateTime(int? timeInMs) {
    if (timeInMs == null) {
      return '';
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime.fromMillisecondsSinceEpoch(timeInMs);
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (aDate == today) {
      return DateFormat.Hm().format(dateToCheck);
    } else if (aDate == yesterday) {
      return 'Yesterday';
    }
    return DateFormat('EEEEE').format(dateToCheck);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.convData.latestMessage(),
      builder: (context, snapshot) {
        dynamic messageBody;
        final msgType = snapshot.data?.body.type;
        if (msgType == MessageType.IMAGE) {
          messageBody = snapshot.data?.body as ChatImageMessageBody;
        } else {
          messageBody = snapshot.data?.body as ChatTextMessageBody?;
        }
        return InkWell(
          onTap: () {
            LocalStorageService.getInstance.getAccount().then((account) {
              final sender = chat_types.User(
                id: account!.id.toString(),
                metadata: {
                  'username': account.email!.split('@')[0],
                },
                firstName: account.firstName,
                lastName: account.lastName,
                imageUrl: account.image,
              );
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (ctx) =>
                      ChatView(sender: sender, receiver: widget.receiver),
                ),
              )
                  .then((value) {
                setState(() {});
              });
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            margin: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.receiver.imageUrl ?? '',
                      ),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.receiver.firstName} ${widget.receiver.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              messageBody is ChatImageMessageBody
                                  ? 'Sends you an image'
                                  : (messageBody as ChatTextMessageBody?)
                                          ?.content ??
                                      '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),
                Column(
                  children: [
                    Text(_parseDateTime(snapshot.data?.serverTime) ?? ''),
                    FutureBuilder(
                      future: widget.convData.unreadCount(),
                      builder: (ctx, snapshot) =>
                          snapshot.hasData && snapshot.data! > 0
                              ? Chip(
                                  label: Text(
                                  snapshot.data!.toString(),
                                ))
                              : Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
