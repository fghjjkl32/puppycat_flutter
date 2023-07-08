import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatRoomListItem extends ConsumerWidget {
  final Room room;
  final void Function()? onTap;
  final void Function()? onLongPress;

  // final String avatarUrl;
  // final String nick;
  // final String content;
  // final String newCount;

  const ChatRoomListItem({
    Key? key,
    required this.room,
    this.onTap,
    this.onLongPress,
    // required this.avatarUrl,
    // required this.nick,
    // required this.content,
    // required this.newCount,
  }) : super(key: key);

  Widget getAvatar() {
    return WidgetMask(
      blendMode: BlendMode.srcATop,
      childSaveLayer: true,
      mask: Center(
        child: Image.network(
          room.avatar != null ? room.avatar.toString() : 'https://via.placeholder.com/150/f66b97',
          height: 46.h,
          fit: BoxFit.fill,
        ),
      ),
      child: SvgPicture.asset(
        'assets/image/feed/image/squircle.svg',
        height: 46.h,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MatrixChatClientController matrixChatClientController = ref.read(chatControllerProvider('matrix').notifier).state as MatrixChatClientController;
    Client client = matrixChatClientController.client;

    final isMuted = room.pushRuleState != PushRuleState.notify;
    final typingUsers = room.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);
    final ownMessage = room.lastEvent?.senderId == client.userID;
    final unread = room.isUnread || room.membership == Membership.invite;
    final unreadBubbleSize = unread || room.hasNewMessages
        ? room.notificationCount > 0
            ? 20.0
            : 14.0
        : 0.0;

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              final pinnedEventIds = room.pinnedEventIds;
              await room.setPinnedEvents(pinnedEventIds);
              // final selectedEventIds = selectedEvents.map((e) => e.eventId).toSet();
              // final unpin = selectedEventIds.length == 1 &&
              //     pinnedEventIds.contains(selectedEventIds.single);
              // if (unpin) {
              //   pinnedEventIds.removeWhere(selectedEventIds.contains);
              // } else {
              //   pinnedEventIds.addAll(selectedEventIds);
              // }
              // showFutureLoadingDialog(
              //   context: context,
              //   future: () => room.setPinnedEvents(pinnedEventIds),
              // );
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: '메시지.고정'.tr(),
          ),
          SlidableAction(
            onPressed: (_) async {
                await room.setFavourite(!room.isFavourite);
            },
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.star_border,
            label: '메시지.즐겨찾기'.tr(),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.21,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              await room.leave();
            },
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.exit_to_app,
            label: '메시지.나가기'.tr(),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
                leading: getAvatar(),
                title: Row(
                  children: [
                    Text(room.getLocalizedDisplayname()),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        room.timeCreated.localizedTimeShort(context),
                        style: TextStyle(
                          fontSize: 13,
                          color: unread ? Theme.of(context).colorScheme.secondary : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                          room.lastEvent!.calcUnlocalizedBody(
                            hideReply: true,
                            hideEdit: true,
                            plaintextBody: true,
                            removeMarkdown: true,
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    // const Spacer(),
                    if (room.notificationCount > 0)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        height: unreadBubbleSize,
                        width: room.notificationCount == 0 && !unread && !room.hasNewMessages ? 0 : (unreadBubbleSize - 9) * room.notificationCount.toString().length + 9,
                        decoration: BoxDecoration(
                          color: room.highlightCount > 0 || room.membership == Membership.invite
                              ? Colors.red
                              : room.notificationCount > 0 || room.markedUnread
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: room.notificationCount > 0
                              ? Text(
                                  room.notificationCount.toString(),
                                  style: TextStyle(
                                    color: room.highlightCount > 0
                                        ? Colors.white
                                        : room.notificationCount > 0
                                            ? Theme.of(context).colorScheme.onPrimary
                                            : Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontSize: 13,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  if(onTap != null) {
                    onTap!();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
