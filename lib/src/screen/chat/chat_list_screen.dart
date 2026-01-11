// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/screen/chat/chat_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // Controller for the Search text field
  final TextEditingController _searchController = TextEditingController();

  // Search State variables to pass down to tabs
  String _searchQuery = "";
  List<String>? _foundUserIds;
  bool _isSearching = false;
  Timer? _debounce;

  /// Handle Search Logic (Same as before, but updates state for the Tabs)
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchQuery = "";
          _foundUserIds = null;
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);

      try {
        final userClient = StreamChat.of(context).client;
        final result = await userClient.queryUsers(
          filter: Filter.or([
            Filter.autoComplete('name', query),
            Filter.autoComplete('id', query),
          ]),
        );

        final List<String> foundUserIds = result.users
            .map((u) => u.id)
            .toList();

        if (mounted) {
          setState(() {
            _searchQuery = query;
            _foundUserIds = foundUserIds;
            _isSearching = false;
          });
        }
      } catch (e) {
        debugPrint('Search error: $e');
        setState(() => _isSearching = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Wrap with DefaultTabController for the 3 tabs
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Messages"),
          backgroundColor:
              Constants.borderColor, // Ensure this color exists in your project
          elevation: 1,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            // --- SEARCH BAR ---
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                ),
              ),
            ),

            // --- TABS (All | Unread | Read) ---
            TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: Colors.black, // Color of selected tab text
              unselectedLabelColor: Colors.grey, // Color of unselected tab text
              indicatorColor: Colors.blue, // Underline color
              tabs: [
                Tab(text: "All"),
                Tab(text: "Unread"),
              ],
            ),
            // --- TAB VIEWS (The Lists) ---
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: All Channels
                  FilteredChannelList(
                    filterType: ChannelFilterType.all,
                    searchQuery: _searchQuery,
                    foundUserIds: _foundUserIds,
                  ),
                  // Tab 2: Unread Channels
                  FilteredChannelList(
                    filterType: ChannelFilterType.unread,
                    searchQuery: _searchQuery,
                    foundUserIds: _foundUserIds,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- REUSABLE CHILD WIDGET FOR THE LIST ---

enum ChannelFilterType { all, unread }

class FilteredChannelList extends StatefulWidget {
  final ChannelFilterType filterType;
  final String searchQuery;
  final List<String>? foundUserIds;

  const FilteredChannelList({
    super.key,
    required this.filterType,
    required this.searchQuery,
    this.foundUserIds,
  });

  @override
  State<FilteredChannelList> createState() => _FilteredChannelListState();
}

class _FilteredChannelListState extends State<FilteredChannelList> {
  late StreamChannelListController _listController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  // Reload controller if Search Query or Filter changes
  @override
  void didUpdateWidget(covariant FilteredChannelList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.filterType != widget.filterType) {
      _listController.dispose();
      _initController();
    }
  }

  void _initController() {
    // 1. Base Filter: User must be a member
    Filter filter = Filter.in_('members', [
      StreamChat.of(context).currentUser!.id,
    ]);

    // 2. Apply Tab Logic (Unread vs Read)
    if (widget.filterType == ChannelFilterType.unread) {
      // Show only channels with unread count > 0
      filter = Filter.and([filter, Filter.greater('unread_count', 0)]);
    }
    // 'ChannelFilterType.all' adds no extra filter, so it shows everything.

    // 3. Apply Search Logic (if user is typing)
    if (widget.searchQuery.isNotEmpty) {
      List<Filter> searchOptions = [];
      searchOptions.add(Filter.autoComplete('name', widget.searchQuery));
      searchOptions.add(Filter.equal('id', widget.searchQuery));

      if (widget.foundUserIds != null && widget.foundUserIds!.isNotEmpty) {
        searchOptions.add(Filter.in_('members', widget.foundUserIds!));
      }

      filter = Filter.and([filter, Filter.or(searchOptions)]);
    }

    _listController = StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: filter,
      presence: true,
      channelStateSort: const [SortOption.desc('last_message_at')],
      limit: 20,
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannelListView(
      // Key ensures rebuild when filter/query changes
      key: ValueKey('${widget.filterType}_${widget.searchQuery}'),
      controller: _listController,
      emptyBuilder: (context) {
        return Center(
          child: Text(
            widget.searchQuery.isNotEmpty
                ? "No results found."
                : "No conversations in '${widget.filterType.name}'.",
            style: const TextStyle(color: Colors.grey),
          ),
        );
      },
      onChannelTap: (channel) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                StreamChannel(channel: channel, child: const ChatScreen()),
          ),
        );
      },
    );
  }
}


/* import 'package:flutter/material.dart';
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
      // Filter to fetch channels where current user is a member
      filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
      // sort channels by last message time descending
      channelStateSort: const [SortOption.desc('last_message_at')],
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
      body: StreamChannelListView(  
        controller: _listController,
        emptyBuilder: (context) {
          return const Center(
            child: Text(
              "No conversations yet.\nStart chatting via Job Details page.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
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
      ),
    );
  }
}
 */