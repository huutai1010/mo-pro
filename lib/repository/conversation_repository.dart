import 'package:etravel_mobile/models/conversation_data.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/strings/app_url.dart';

class ConversationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getConversationsApi() async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
        AppUrl.getConversationsEndpoint,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ConversationData> getConversationApi(String from, String to) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
        AppUrl.getConversationEndpoint
            .replaceAll("{from}", from)
            .replaceAll("{to}", to),
      );
      return ConversationData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future sendChatMessage(
      String fromUsername, String toUsername, String content) async {
    try {
      await _apiServices.getPostApiRepsonseAuth(
          AppUrl.postChatMessageEndpoint
              .replaceAll('{fromUsername}', fromUsername)
              .replaceAll('{toUsername}', toUsername),
          {
            'fromUsername': fromUsername,
            'toUsername': toUsername,
            'content': content,
          });
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Skip error
    }
  }

  Future postConversation(dynamic data) async {
    try {
      await _apiServices.getPostApiRepsonseAuth(
          AppUrl.postConversationsEndpoint, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postCallApi(String receiverId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
        '${AppUrl.postCallEndpoint}/$receiverId/1',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
