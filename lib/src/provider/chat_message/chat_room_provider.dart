import 'dart:async';
import 'package:flutter/material.dart';
import 'package:job_circle/src/model/chat_message/chat_message_model.dart';
import 'package:job_circle/src/services/chat_message/chat_api_service.dart';

class ChatRoomProvider extends ChangeNotifier {
  late int conversationId;
  late int myId;
  late String myType;
  late int otherPartyId;
  late String otherPartyType;
  int? jobId;

  List<ChatMessageEntity> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  Timer? _pollingTimer;
  int _lastFetchedId = 0;

  List<ChatMessageEntity> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  /// This provider is a single shared instance (registered once in
  /// ProviderScop), so a specific conversation's details are handed over
  /// here instead of through the constructor. Any previous conversation's
  /// messages/polling are reset first so they never leak into the new one.
  Future<void> openConversation({
    required int conversationId,
    required int myId,
    required String myType,
    required int otherPartyId,
    required String otherPartyType,
    int? jobId,
  }) async {
    _pollingTimer?.cancel();
    this.conversationId = conversationId;
    this.myId = myId;
    this.myType = myType;
    this.otherPartyId = otherPartyId;
    this.otherPartyType = otherPartyType;
    this.jobId = jobId;
    _messages = [];
    _lastFetchedId = 0;
    await initializeChat();
  }

  Future<void> initializeChat() async {
    _isLoading = true;
    notifyListeners();

    try {
      final history = await ChatApiService.fetchMessages(
        conversationId: conversationId,
      );
      _messages = history;
      if (_messages.isNotEmpty) {
        _lastFetchedId = _messages
            .map((e) => e.id)
            .reduce((c, n) => c > n ? c : n);
      }
      _markRead();
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final newItems = await ChatApiService.fetchMessages(
          conversationId: conversationId,
          afterId: _lastFetchedId,
        );

        if (newItems.isNotEmpty) {
          _messages.addAll(newItems);
          _lastFetchedId = newItems
              .map((e) => e.id)
              .reduce((c, n) => c > n ? c : n);
          _markRead();
          notifyListeners();
        }
      } catch (_) {}
    });
  }

  Future<bool> sendTextMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return false;

    _isSending = true;
    notifyListeners();

    try {
      final sentEntity = await ChatApiService.sendMessage(
        senderId: myId,
        senderType: myType,
        receiverId: otherPartyId,
        receiverType: otherPartyType,
        messageText: cleanText,
        jobId: jobId,
      );

      _messages.add(sentEntity);
      if (sentEntity.id > _lastFetchedId) {
        _lastFetchedId = sentEntity.id;
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void _markRead() {
    ChatApiService.markAsRead(
      conversationId: conversationId,
      readerId: myId,
      readerType: myType,
    );
  }

  /// Call when leaving the chat room screen — this provider is a global
  /// singleton now, so there's no widget-lifecycle dispose() tied to one
  /// conversation to rely on for stopping the polling timer.
  void stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
