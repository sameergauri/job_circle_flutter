import 'package:flutter/material.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/provider/chat_message/chat_room_provider.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final int conversationId;
  final int myId;
  final String myType;
  final int otherPartyId;
  final String otherPartyType;
  final String otherPartyName;
  final String? otherPartyAvatar;
  final int? jobId;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.myId,
    required this.myType,
    required this.otherPartyId,
    required this.otherPartyType,
    required this.otherPartyName,
    this.otherPartyAvatar,
    this.jobId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // Captured in didChangeDependencies instead of looked up fresh in
  // dispose(): by the time dispose() runs on back navigation, the widget's
  // element can already be deactivated, and context.read() there walks the
  // ancestor tree, which throws "Looking up a deactivated widget's ancestor
  // is unsafe." Grabbing the reference early and reusing it avoids that.
  late final ChatRoomProvider _chatRoomProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatRoomProvider = context.read<ChatRoomProvider>();
  }

  @override
  void initState() {
    super.initState();
    // ChatRoomProvider is a single shared instance (registered once in
    // ProviderScop), so this conversation's details are handed over via
    // openConversation() instead of through a constructor.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatRoomProvider.openConversation(
        conversationId: widget.conversationId,
        myId: widget.myId,
        myType: widget.myType,
        otherPartyId: widget.otherPartyId,
        otherPartyType: widget.otherPartyType,
        jobId: widget.jobId,
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // The provider outlives this screen (it's global), so polling for this
    // conversation has to be stopped explicitly instead of relying on the
    // provider's own dispose().
    _chatRoomProvider.stopPolling();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  widget.otherPartyAvatar != null &&
                      widget.otherPartyAvatar!.isNotEmpty
                  ? NetworkImage(
                      "${GlobalConstants.Image_url}${widget.otherPartyAvatar}",
                    )
                  : null,
              child:
                  widget.otherPartyAvatar == null ||
                      widget.otherPartyAvatar!.isEmpty
                  ? Text(widget.otherPartyName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.otherPartyName,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = provider.messages[index];
                    final isMe =
                        msg.senderType == widget.myType &&
                        msg.senderId == widget.myId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.indigo : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg.messageText,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Colors.white,
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.indigo),
                        onPressed: () async {
                          final success = await provider.sendTextMessage(
                            _controller.text,
                          );
                          if (success) {
                            _controller.clear();
                            _scrollToBottom();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
