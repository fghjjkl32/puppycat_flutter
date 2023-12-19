import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/widget/chat_room_list_item.dart';

class ChatRoomWidget extends ConsumerStatefulWidget {
  const ChatRoomWidget({super.key});

  @override
  ChatRoomWidgetState createState() => ChatRoomWidgetState();
}

class ChatRoomWidgetState extends ConsumerState<ChatRoomWidget> {
  late PagingController<int, ChatRoomModel> _pagingController;

  @override
  void initState() {
    _pagingController = ref.read(chatRoomStateProvider);
    _pagingController.refresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pagingController = ref.watch(chatRoomStateProvider);
    return Column(
      children: [
        Expanded(
          child: PagedListView<int, ChatRoomModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ChatRoomModel>(
              noItemsFoundIndicatorBuilder: (context) {
                ref.read(chatRoomListEmptyProvider.notifier).state = true;
                return const Text('empty');
              },
              itemBuilder: (context, item, index) {
                return ChatRoomItem(
                  roomModel: item,
                  onTap: () {
                    context.push('/chatHome/chatRoom', extra: {
                      'roomId': item.roomId,
                      'nick': item.nick,
                      'profileImgUrl': item.profileImgUrl,
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
