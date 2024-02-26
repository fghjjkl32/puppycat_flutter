import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_empty_widget.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/widget/chat_room_list_item.dart';

class ChatRoomWidget extends ConsumerStatefulWidget {
  const ChatRoomWidget({super.key});

  @override
  ChatRoomWidgetState createState() => ChatRoomWidgetState();
}

class ChatRoomWidgetState extends ConsumerState<ChatRoomWidget> {
  late PagingController<int, ChatRoomModel> _pagingController;

  @override
  void initState() {
    _pagingController = ref.read(chatRoomListStateProvider);
    _pagingController.refresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pagingController = ref.watch(chatRoomListStateProvider);
    final myInfo = ref.read(myInfoStateProvider);

    return Column(
      children: [
        Expanded(
          child: PagedListView<int, ChatRoomModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<ChatRoomModel>(
              noItemsFoundIndicatorBuilder: (context) {
                ref.read(chatRoomListEmptyProvider.notifier).state = true;
                return ChatEmptyWidget(
                  nick: myInfo.nick,
                );
                // return const Text('empty');
              },
              itemBuilder: (context, item, index) {
                return ChatRoomItem(
                  roomModel: item,
                  onPin: (isPin) async {
                    await ref.read(chatRoomListStateProvider.notifier).pinChatRoom(roomUuid: item.uuid, isPin: isPin);
                    // await ref.read(chatRoomListStateProvider.notifier).updateChatRoom(roomUuid: item.uuid, isPin: !isPin);
                  },
                  onFavorite: (isFavorite) async {
                    await ref.read(chatFavoriteStateProvider.notifier).favoriteChatMember(targetMemberUuid: item.targetMemberUuid, isFavorite: isFavorite);
                    await ref.read(chatRoomListStateProvider.notifier).updateChatRoom(roomUuid: item.uuid, isFavorite: !isFavorite);
                  },
                  onLeave: () async {
                    await ref.read(chatRoomListStateProvider.notifier).exitChatRoom(roomUuid: item.uuid);
                    await ref.read(chatRoomListStateProvider.notifier).updateChatRoom(roomUuid: item.uuid, isDelete: true);
                  },
                  onTap: () {
                    print('item.profileImgUrl ${item.profileImgUrl}');
                    context.push('/chatHome/chatRoom', extra: {
                      'roomId': item.roomId,
                      'nick': item.nick,
                      'profileImgUrl': item.profileImgUrl,
                      'targetMemberUuid': item.targetMemberUuid,
                    }).then((value) => ref.read(chatRoomListStateProvider).refresh());
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
