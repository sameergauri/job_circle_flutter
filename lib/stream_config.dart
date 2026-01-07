// lib/stream_config.dart
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamConfig {
  static const String apiKey = "4zkr3zjd6nsa"; // Stream Chat API Key

  // Client ka instance
  static final StreamChatClient client = StreamChatClient(
    apiKey,
    logLevel: Level.SEVERE,
  );
}
