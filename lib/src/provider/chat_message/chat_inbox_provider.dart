import 'package:flutter/material.dart';
import 'package:job_circle/src/model/chat_message/chat_message_model.dart';
import 'package:job_circle/src/services/chat_message/chat_api_service.dart';


class ChatInboxProvider extends ChangeNotifier {
  List<ChatInboxItem> _inboxList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatInboxItem> get inboxList => _inboxList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadInbox({
    required int participantId,
    required String participantType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _inboxList = await ChatApiService.fetchInbox(
        participantId: participantId,
        participantType: participantType,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
