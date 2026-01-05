import 'package:flutter/material.dart';
import 'package:job_circle/src/screen/chat/chat_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final StreamChannelListController _listController;

  @override
  void initState() {
    super.initState();

    // 1. Controller Initialize: Yeh decide karta hai kaunsi chats dikhani hai
    _listController = StreamChannelListController(
      client: StreamChat.of(context).client,

      // Filter: Sirf wo chats dikhao jisme CURRENT USER member hai
      filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),

      // Sort: Naya message sabse upar
      //sort: const [SortOption('last_message_at')],
      limit: 20, // Ek baar me 20 chats load karo
    );
  }

  @override
  void dispose() {
    _listController.dispose(); // Memory leak rokne ke liye dispose zaroori hai
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // 2. Main List View Widget provided by Stream
      body: StreamChannelListView(
        controller: _listController,

        // Agar koi chat nahi hai to kya dikhaye?
        emptyBuilder: (context) {
          return const Center(
            child: Text(
              "No conversations yet.\nStart chatting via Job Details page.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        },

        // Jab user kisi chat pe click kare
        onChannelTap: (channel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: const ChatScreen(), // Opens the individual chat room
              ),
            ),
          );
        },

        // Optional: List item ka design customize karne ke liye 'itemBuilder' use kar sakte ho.
        // Default design WhatsApp jaisa hi hota hai.
      ),
    );
  }
}
