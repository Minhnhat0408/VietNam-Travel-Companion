import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vn_travel_companion/core/utils/show_snackbar.dart';
import 'package:vn_travel_companion/features/chat/domain/entities/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vn_travel_companion/features/chat/domain/entities/message.dart';
import 'package:vn_travel_companion/features/chat/presentation/bloc/message_bloc.dart';
import 'package:vn_travel_companion/features/chat/presentation/widgets/chat_input.dart';
import 'package:vn_travel_companion/features/chat/presentation/widgets/message_item.dart';

class ChatDetailsPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailsPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  late MessageBloc _messageBloc;
  final List<Message> messages = [];
  bool _isOverlayVisible = false;

  void _toggleOverlay(bool isVisible) {
    setState(() {
      _isOverlayVisible = isVisible;
    });
  }

  int totalRecordCount = 0;
  final PagingController<int, Message> _pagingController =
      PagingController(firstPageKey: 0); // Start at page 0
  final _pageSize = 5;
  @override
  void initState() {
    super.initState();
    _messageBloc = context.read<MessageBloc>(); // Lưu tham chiếu
    _pagingController.addPageRequestListener((pageKey) {
      _messageBloc.add(GetMessagesInChat(
        chatId: widget.chat.id,
        limit: _pageSize,
        offset: pageKey,
      ));
    });

    _messageBloc.add(ListenToMessagesChannel(chatId: widget.chat.id));
  }

  @override
  void dispose() {
    _pagingController.dispose();

    _messageBloc.add(
        UnSubcribeToMessagesChannel(channelName: 'chat:${widget.chat.id}'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleOverlay(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.chevron_left),
                  iconSize: 32,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    if (_isOverlayVisible) {
                      _toggleOverlay(false);
                    } else {
                      Navigator.of(context).pop(); // Navigate back
                    }
                  },
                )
              : null,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          title: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.imageUrl),
              radius: 20,
            ),
            visualDensity: VisualDensity.compact,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 6),
            title: Text(
              widget.chat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Online',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline, fontSize: 12),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            BlocConsumer<MessageBloc, MessageState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is MessagesLoadedSuccess) {
                  if (widget.chat.isSeen == false && totalRecordCount == 0) {
                    log('Update seen message');
                    _messageBloc.add(UpdateSeenMessage(
                      chatId: widget.chat.id,
                      messageId: state.messages.first.id,
                    ));
                  }
                  totalRecordCount += state.messages.length;

                  log("Total record count: $totalRecordCount");

                  final next = totalRecordCount;
                  final isLastPage = state.messages.length < _pageSize;
                  if (isLastPage) {
                    _pagingController.appendLastPage(state.messages);
                  } else {
                    _pagingController.appendPage(state.messages, next);
                  }
                  log('Messages loaded successfully');
                }

                if (state is MessageInsertSuccess) {
                  // add message to first index of list

                  if (_pagingController.itemList != null) {
                    _pagingController.itemList = [
                      state.message, // Tin nhắn mới
                      ..._pagingController.itemList!,
                    ];
                  }
                  totalRecordCount++;
                }

                if (state is MessageFailure) {
                  // Show snackbar
                  showSnackbar(context, state.message, SnackBarState.error);
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: PagedListView<int, Message>(
                    reverse: true, // Show latest messages at the bottom
                    pagingController: _pagingController,

                    builderDelegate: PagedChildBuilderDelegate<Message>(
                      itemBuilder: (context, message, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: MessageItem(
                            key: Key(message.id.toString()), message: message),
                      ),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      animateTransitions: true,
                      newPageProgressIndicatorBuilder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      noItemsFoundIndicatorBuilder: (context) => Column(
                        children: [
                          const SizedBox(height: 200),
                          Icon(
                            Icons.folder_open,
                            size: 100,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No messages',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            ChatInput(
              chat: widget.chat,
              onOverlayToggle: _toggleOverlay,
              isOverlayVisible: _isOverlayVisible,
            ),
          ],
        ),
      ),
    );
  }
}
