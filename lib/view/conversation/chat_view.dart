import 'dart:math' as math;

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../repository/conversation_repository.dart';
import '../widgets/appbar_action_item.dart';
import 'video_call_view.dart';

class ChatViewArguments {
  final chat_types.User receiver;
  final chat_types.User sender;

  ChatViewArguments({
    required this.receiver,
    required this.sender,
  });
}

class ChatView extends StatefulWidget {
  final chat_types.User receiver;
  final chat_types.User sender;

  const ChatView({
    super.key,
    required this.receiver,
    required this.sender,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FocusNode _inputTextFieldFocusNode = FocusNode();
  final TextEditingController _inputTextFieldController =
      TextEditingController();

  bool _isInit = true;
  final List<chat_types.Message> _localMessages = [];

  late chat_types.User _sender;
  late chat_types.User _receiver;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _addChatListener();
      fetchConversation().then((value) {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _sender = widget.sender;
    _receiver = widget.receiver;
  }

  Future<void> fetchConversation() async {
    ChatClient.getInstance.chatManager
        .fetchHistoryMessages(
      conversationId: _receiver.metadata!['username'],
      pageSize: 100000,
    )
        .then((cursor) {
      var data = cursor.data.toList();
      for (var e in data) {
        _addMessagesToChat(e);
      }
      setState(() {});
    });
  }

  void _onMessageEvent(List<ChatMessage> messages) {
    for (var msg in messages) {
      _addMessagesToChat(msg);
    }
    setState(() {});
  }

  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      _receiver.id,
      ChatEventHandler(
        onMessagesReceived: (messages) {
          _onMessageEvent(messages);
        },
      ),
    );

    ChatClient.getInstance.chatManager.addMessageEvent(
      _receiver.id,
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          _addMessagesToChat(msg);
          setState(() {});
        },
        onError: (msgId, msg, error) {
          // Do nothing
        },
      ),
    );
  }

  void _addMessagesToChat(
    ChatMessage message,
  ) {
    final dynamic insertMessage;

    switch (message.body.type) {
      case MessageType.IMAGE:
        final messageBody = message.body as ChatImageMessageBody;
        insertMessage = chat_types.ImageMessage(
          status: chat_types.Status.seen,
          author: _sender.metadata!['username'] == message.from
              ? _sender
              : _receiver,
          id: message.msgId,
          name: messageBody.displayName!,
          size: messageBody.fileSize!,
          uri: messageBody.remotePath!,
        );
        break;
      default:
        final messageBody = message.body as ChatTextMessageBody;
        insertMessage = chat_types.TextMessage(
          status: chat_types.Status.seen,
          id: message.msgId,
          text: messageBody.content,
          author: _sender.metadata!['username'] == message.from
              ? _sender
              : _receiver,
        );
        break;
    }
    int index =
        _localMessages.indexWhere((element) => element.id == message.msgId);
    if (index >= 0) {
      _localMessages[index] = insertMessage;
    } else {
      _localMessages.insert(
        0,
        insertMessage,
      );
    }
  }

  void _sendMessage(String? content) async {
    if (content == null || content.isEmpty) {
      return;
    }
    var msg = ChatMessage.createTxtSendMessage(
      targetId: _receiver.metadata!['username'],
      content: content,
    );

    msg = await ChatClient.getInstance.chatManager.sendMessage(msg);
    _inputTextFieldController.text = '';
  }

  Future<void> _sendImageMessage(XFile? file) async {
    if (file == null) {
      return;
    }

    var msg = ChatMessage.createImageSendMessage(
      targetId: _receiver.metadata!['username'],
      filePath: file.path,
    );

    await ChatClient.getInstance.chatManager.sendMessage(msg);
  }

  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler(_receiver.id);
    ChatClient.getInstance.chatManager.removeMessageEvent(_receiver.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverName = '${_receiver.firstName} ${_receiver.lastName}';
    final customBottomWidget = Container(
      height: 72,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  focusNode: _inputTextFieldFocusNode,
                  controller: _inputTextFieldController,
                  minLines: 1,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: Color(0xffe4e9f2),
                      ),
                    ),
                    hintText: 'Aa',
                    hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(
                      Icons.sentiment_satisfied_alt,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _inputTextFieldFocusNode.unfocus();

                        _inputTextFieldFocusNode.canRequestFocus = false;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  Text(context.tr('please_select_the_source')),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(ImageSource.gallery);
                                    },
                                    child: Text(context.tr('gallery'))),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(ImageSource.camera);
                                  },
                                  child: Text(context.tr('camera')),
                                )
                              ],
                            );
                          },
                        ).then((imageSource) {
                          if (imageSource == null) return Future.value();
                          final ImagePicker picker = ImagePicker();
                          return picker.pickImage(source: imageSource);
                        }).then((file) {
                          if (file == null) return Future.value();
                          return _sendImageMessage(file);
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          _inputTextFieldFocusNode.canRequestFocus = true;
                        });
                      },
                      child: const Icon(
                        Icons.attachment,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Transform.rotate(
                angle: -math.pi / 4,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _sendMessage(_inputTextFieldController.text);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                ),
              )
            ]),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              if (_receiver.imageUrl != null) ...[
                Image.network(
                  _receiver.imageUrl!,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
              Text(
                receiverName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              )
            ],
          ),
          actions: [
            AppBarActionItem(
              onPressed: () {
                ConversationRepository()
                    .postCallApi(_receiver.id)
                    .then((response) {
                  final token = response['conversation']['token'];
                  final channelName = response['conversation']['channelName'];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => VideoCallView(
                        localUid: int.parse(widget.sender.id),
                        token: token,
                        channelName: channelName,
                        remoteUid: int.parse(_receiver.id),
                        autoJoinCall: true,
                        isJoinedThroughNotification: false,
                        onDisconnect: () {
                          ChatClient.getInstance.chatManager.sendMessage(
                            ChatMessage.createTxtSendMessage(
                                targetId: widget.receiver.metadata!['username'],
                                content: "The call ended."),
                          );
                        },
                      ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.camera_alt),
            ),
            AppBarActionItem(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: _isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Chat(
                customBottomWidget: customBottomWidget,
                showUserAvatars: true,
                theme: DefaultChatTheme(
                  backgroundColor: Colors.white,
                  primaryColor: Theme.of(context).colorScheme.primary,
                  secondaryColor: const Color(0xfff6f6f6),
                ),
                messages: _localMessages,
                onSendPressed: (_) {},
                user: _sender,
              ));
  }
}
