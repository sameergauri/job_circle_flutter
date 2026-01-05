import 'package:flutter/material.dart';
import 'package:job_circle/src/screen/chat/chat_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// IMPORT YOUR CHAT SCREEN HERE

class ChatUtils {
  /// Call this function from anywhere to start a chat
  static Future<void> startChatWithRecruiter({
    required BuildContext context,
    required String recruiterId,
    required String recruiterName,
    String? recruiterImage,
    String? jobTitle, // Optional: To pass job context
  }) async {
    final client = StreamChat.of(context).client;
    final myId = client.state.currentUser!.id;

    // 1. Show Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ), // Use your app theme color
      ),
    );

    try {
      // 2. Validate IDs (Basic Safety)
      if (recruiterId.isEmpty || myId.isEmpty) {
        throw Exception("Invalid User IDs");
      }

      // 3. Ensure Recruiter Exists in Stream DB (Ghost User Fix)
      /*  await client.updateUsers([
        User(
          id: recruiterId,
          name: recruiterName,
          image:
              recruiterImage ??
              "https://ui-avatars.com/api/?name=$recruiterName", // Default Avatar
        ),
      ]); */

      // 4. Create or Retrieve the Unique Channel
      final channel = client.channel(
        'messaging',
        extraData: {
          'members': [myId, recruiterId],
          // You can add custom data if needed, e.g.
          // 'last_job_context': jobTitle ?? 'General Inquiry',
        },
      );

      await channel.watch(); // Fetches history or creates new

      // 5. Close Loading Dialog
      if (context.mounted) Navigator.pop(context);

      // 6. Navigate to Chat Screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const ChatScreen(), // Make sure you import your ChatScreen
            ),
          ),
        );
      }
    } catch (e) {
      // Handle Error
      if (context.mounted) {
        Navigator.pop(context); // Close loading if open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Chat Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
