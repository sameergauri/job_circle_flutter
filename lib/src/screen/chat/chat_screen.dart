import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Header: Shows the other person's name & avatar automatically
      appBar: const StreamChannelHeader(showTypingIndicator: true),
      body: Column(
        children: [
          // 2. Message List: Shows history and live messages
          Expanded(
            child: StreamMessageListView(
              messageBuilder: (context, details, messages, defaultMessage) {
                return defaultMessage.copyWith(
                  // showUserAvatar: false, // 👈 avatar hide
                  showUsername: false, // 👈 username hide
                  showUserAvatar: DisplayWidget.gone,
                );
              },
              showUnreadIndicator: true,
              showFloatingDateDivider: true,
              emptyBuilder: (context) {
                return const Center(
                  child: Text("No messages yet. Start the conversation!"),
                );
              },
            ),
          ),
          // 3. Input Box: Where user types text, sends images/files
          StreamMessageInput(showCommandsButton: false),
        ],
      ),
    );
  }
}
