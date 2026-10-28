import 'package:flutter/material.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/provider/chat_message/chat_inbox_provider.dart';
import 'package:job_circle/src/screen/chat_message/chat_conversation_screen.dart';
import 'package:provider/provider.dart';

class ChatInboxScreen extends StatefulWidget {
  final int myId;
  final String myType;

  const ChatInboxScreen({super.key, required this.myId, required this.myType});

  @override
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
  @override
  void initState() {
    super.initState();
    // ChatInboxProvider is provided once, app-wide, in ProviderScop — it has
    // no per-instance constructor params, so unlike ChatRoomProvider it's a
    // normal global provider. Kick off the load after the first frame
    // instead of calling it during create, since there's no local create
    // callback here anymore to chain it onto.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatInboxProvider>().loadInbox(
        participantId: widget.myId,
        participantType: widget.myType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          Consumer<ChatInboxProvider>(
            builder: (context, provider, _) => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => provider.loadInbox(
                participantId: widget.myId,
                participantType: widget.myType,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ChatInboxProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          if (provider.inboxList.isEmpty) {
            return const Center(child: Text('No conversations found.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadInbox(
              participantId: widget.myId,
              participantType: widget.myType,
            ),
            child: ListView.separated(
              itemCount: provider.inboxList.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = provider.inboxList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    backgroundImage:
                        item.otherPartyAvatar != null &&
                            item.otherPartyAvatar!.isNotEmpty
                        ? NetworkImage(
                            "${GlobalConstants.Image_url}${item.otherPartyAvatar}",
                          )
                        : null,
                    child:
                        item.otherPartyAvatar == null ||
                            item.otherPartyAvatar!.isEmpty
                        ? Text(
                            item.otherPartyName.isNotEmpty
                                ? item.otherPartyName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(color: Colors.indigo),
                          )
                        : null,
                  ),
                  title: Text(item.otherPartyName),
                  subtitle: Text(
                    item.lastMessage ?? 'No messages yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: item.unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${item.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(
                          conversationId: item.conversationId,
                          myId: widget.myId,
                          myType: widget.myType,
                          otherPartyId: item.otherPartyId,
                          otherPartyType: item.otherPartyType,
                          otherPartyName: item.otherPartyName,
                          otherPartyAvatar: item.otherPartyAvatar,
                          jobId: item.jobId,
                        ),
                      ),
                    );
                    if (context.mounted) {
                      provider.loadInbox(
                        participantId: widget.myId,
                        participantType: widget.myType,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
