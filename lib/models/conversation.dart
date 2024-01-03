import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

class Conversation {
  final chat_types.User receiver;
  final ChatConversation convData;

  Conversation({
    required this.receiver,
    required this.convData,
  });

  factory Conversation.fromJson(
          Map<String, dynamic> json, ChatConversation convData) =>
      Conversation(
        receiver: chat_types.User(
          id: json['accountTwoId'].toString(),
          metadata: {
            'phone': json['accountTwoPhone'],
            'username': json['accountTwoUsername'],
          },
          firstName: json['accountTwoFirstName'],
          lastName: json['accountTwoLastName'],
          imageUrl: json['accountTwoImage'],
        ),
        convData: convData,
      );
}
