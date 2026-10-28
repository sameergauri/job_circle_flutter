import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/chat_message/chat_message_model.dart';

class ChatApiService {
  static Future<List<ChatInboxItem>> fetchInbox({
    required int participantId,
    required String participantType,
  }) async {
    final uri = Uri.parse(GlobalConstants.chatInboxUrl).replace(
      queryParameters: {
        'participantId': participantId.toString(),
        'participantType': participantType,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        return ChatInboxItem.listFromJson(decoded['data']);
      }
    }
    throw Exception('Failed to load inbox: ${response.statusCode}');
  }

  static Future<int> startOrGetConversation({
    required int jobseekerId,
    required int recruiterId,
    int? jobId,
  }) async {
    final response = await http.post(
      Uri.parse(GlobalConstants.chatStartConversationUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'jobseekerId': jobseekerId,
        'recruiterId': recruiterId,
        if (jobId != null) 'jobId': jobId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded['data'] != null) {
        return decoded['data']['id'] ?? decoded['data']['conversationId'];
      }
    }
    throw Exception('Failed to initialize conversation');
  }

  static Future<List<ChatMessageEntity>> fetchMessages({
    required int conversationId,
    int? afterId,
  }) async {
    Map<String, String> queryParams = {};
    if (afterId != null && afterId > 0) {
      queryParams['afterId'] = afterId.toString();
    }

    final uri = Uri.parse(
      '${GlobalConstants.chatConversationUrl}$conversationId/messages',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true && decoded['data'] != null) {
        return ChatMessageEntity.listFromJson(decoded['data']);
      }
    }
    throw Exception('Failed to fetch messages');
  }

  static Future<ChatMessageEntity> sendMessage({
    required int senderId,
    required String senderType,
    required int receiverId,
    required String receiverType,
    required String messageText,
    int? jobId,
  }) async {
    final response = await http.post(
      Uri.parse(GlobalConstants.chatSendMessageUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': senderId,
        'senderType': senderType,
        'receiverId': receiverId,
        'receiverType': receiverType,
        'messageText': messageText,
        if (jobId != null) 'jobId': jobId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded['data'] != null) {
        return ChatMessageEntity.fromJson(decoded['data']);
      }
    }
    throw Exception('Failed to send message');
  }

  static Future<void> markAsRead({
    required int conversationId,
    required int readerId,
    required String readerType,
  }) async {
    final uri = Uri.parse(
      '${GlobalConstants.chatConversationUrl}$conversationId/read',
    ).replace(
      queryParameters: {
        'readerId': readerId.toString(),
        'readerType': readerType,
      },
    );
    await http.put(uri);
  }
}
