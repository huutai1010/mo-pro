import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:etravel_mobile/view/widgets/custom_yes_no_dialog.dart';

import '../../models/conversation.dart';
import '../../res/colors/app_color.dart';
import 'chat_item.dart';
import 'package:flutter/material.dart';

class ChatHistory extends StatelessWidget {
  final List<Conversation> conversations;
  final Function onRefresh;
  const ChatHistory({
    super.key,
    required this.onRefresh,
    required this.conversations,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(index),
        background: const ColoredBox(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          final isConfirm = await showDialog<bool>(
              context: context,
              builder: (ctx) {
                return CustomYesNoDialog(
                    yesContent: 'OK',
                    noContent: 'No',
                    title: 'Delete messages',
                    content: 'Are you sure you want to delete all messages?',
                    icon: const Icon(
                      Icons.task_alt,
                      color: AppColors.primaryColor,
                      size: 70,
                    ),
                    onYes: () {
                      Navigator.of(ctx).pop(true);
                    },
                    onNo: () {
                      Navigator.of(ctx).pop(false);
                    });
              });
          if (isConfirm ?? false) {
            final convId = conversations[index].receiver.metadata!['username'];
            await ChatClient.getInstance.chatManager
                .deleteRemoteConversation(convId, isDeleteMessage: true);
            await ChatClient.getInstance.chatManager
                .deleteConversation(convId, deleteMessages: true);
            await onRefresh();
          }
          return false;
        },
        child: ChatItem(
          receiver: conversations[index].receiver,
          convData: conversations[index].convData,
        ),
      ),
      itemCount: conversations.length,
    );
  }
}
