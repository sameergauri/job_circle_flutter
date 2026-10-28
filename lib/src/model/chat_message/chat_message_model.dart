class ChatInboxItem {
  final int conversationId;
  final int? jobId;
  final int otherPartyId;
  final String otherPartyType;
  final String otherPartyName;
  final String? otherPartyAvatar;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  ChatInboxItem({
    required this.conversationId,
    this.jobId,
    required this.otherPartyId,
    required this.otherPartyType,
    required this.otherPartyName,
    this.otherPartyAvatar,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory ChatInboxItem.fromJson(Map<String, dynamic> json) {
    return ChatInboxItem(
      conversationId: json['conversationId'] ?? 0,
      jobId: json['jobId'],
      otherPartyId: json['otherPartyId'] ?? 0,
      otherPartyType: json['otherPartyType'] ?? '',
      otherPartyName: json['otherPartyName'] ?? 'User',
      otherPartyAvatar: json['otherPartyAvatar'],
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  static List<ChatInboxItem> listFromJson(dynamic list) {
    if (list is List) {
      return list
          .map((e) => ChatInboxItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

class ChatMessageEntity {
  final int id;
  final int conversationId;
  final int senderId;
  final String senderType;
  final int receiverId;
  final String receiverType;
  final String messageText;
  final bool isRead;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderType,
    required this.receiverId,
    required this.receiverType,
    required this.messageText,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id: json['id'] ?? 0,
      conversationId: json['conversationId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      senderType: json['senderType'] ?? '',
      receiverId: json['receiverId'] ?? 0,
      receiverType: json['receiverType'] ?? '',
      messageText: json['messageText'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static List<ChatMessageEntity> listFromJson(dynamic list) {
    if (list is List) {
      return list
          .map((e) => ChatMessageEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
