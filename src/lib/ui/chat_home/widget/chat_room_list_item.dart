import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';

enum RoomContextMenuType {
  pin,
  favorite,
  leave,
}

class ChatRoomItem extends ConsumerWidget {
  final void Function()? onTap;
  final void Function(Offset?)? onLongPress;
  final void Function(ChatRoomModel)? onLeave;
  final void Function(bool)? onPin;
  final void Function(bool)? onFavorite;

  // final String avatarUrl;
  // final String nick;
  // final String lastMsg;
  // final int newCount;
  // final bool isRead;
  // final bool isPin;
  // final String msgDateTime;
  // final bool isMine;
  final ChatRoomModel roomModel;

  ChatRoomItem({
    Key? key,
    this.onTap,
    this.onLongPress,
    this.onLeave,
    this.onPin,
    this.onFavorite,
    // required this.avatarUrl,
    // required this.nick,
    // required this.lastMsg,
    // required this.newCount,
    // this.isRead = false,
    // this.isPin = false,
    // required this.msgDateTime,
    // this.isMine = false,
    required this.roomModel,
  }) : super(key: key);

  Offset? _lastPointerDownPosition;

  ///NOTE
  ///GPT Code
  void _showMenu(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final screenHeight = overlay.size.height;

    selectedItemBuilder(BuildContext context) {
      return <PopupMenuEntry<RoomContextMenuType>>[
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.pin,
          child: Row(
            children: [
              Text(
                roomModel.fixState == 1 ? '메시지.고정 해제'.tr() : '메시지.고정'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
              ),
              const Spacer(),
              roomModel.fixState == 1
                  ? Image.asset(
                      'assets/image/chat/icon_fix_ac.png',
                      color: kPreviousTextSubTitleColor,
                      width: 20,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/image/chat/icon_fix_de.png',
                      color: kPreviousTextSubTitleColor,
                      width: 20,
                      height: 20,
                    ),
            ],
          ),
        ),
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.favorite,
          child: Row(
            children: [
              Text(
                roomModel.favoriteState == 1 ? '메시지.즐겨찾기 해제'.tr() : '메시지.즐겨찾기'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
              ),
              const Spacer(),
              roomModel.favoriteState == 1
                  ? Image.asset(
                      'assets/image/chat/icon_star_s_on.png',
                      color: kPreviousTextSubTitleColor,
                      width: 20,
                      height: 20,
                    )
                  : Image.asset(
                      'assets/image/chat/icon_star_s_off.png',
                      color: kPreviousTextSubTitleColor,
                      width: 20,
                      height: 20,
                    ),
            ],
          ),
        ),
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.leave,
          child: Row(
            children: [
              Text(
                '메시지.나가기'.tr(),
                style: kBody12SemiBoldStyle.copyWith(color: kPreviousErrorColor),
              ),
              const Spacer(),
              Image.asset(
                'assets/image/chat/icon_exit.png',
                color: kPreviousErrorColor,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
      ];
    }

    // Get height of single menu item
    const menuItemHeight = 48.0; // Standard Material Design menu item height
    // Calculate estimated menu height
    final menuHeight = selectedItemBuilder(context).length * menuItemHeight;

    // Calculate top of the menu
    final double menuTop = position.dy < screenHeight / 2 ? position.dy : max(0, position.dy - menuHeight);

    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      items: selectedItemBuilder(context),
      position: RelativeRect.fromLTRB(position.dx, menuTop, overlay.size.width - position.dx, overlay.size.height - menuTop),
      elevation: 8.0,
    ).then<void>((RoomContextMenuType? newValue) {
      if (newValue == null) return;
      switch (newValue) {
        case RoomContextMenuType.pin:
          _onPin();
        case RoomContextMenuType.favorite:
          _onFavorite();
        case RoomContextMenuType.leave:
          _onLeave();
      }
    });
  }

  void _onPin() {
    if (onPin != null) {
      onPin!(roomModel.fixState == 1);
    }
  }

  void _onLeave() {
    if (onLeave != null) {
      onLeave!(roomModel);
    }
  }

  void _onFavorite() {
    if (onFavorite != null) {
      onFavorite!(roomModel.favoriteState == 1);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pinBackgroundColor = roomModel.fixState == 1 ? kNeutralColor300 : kPrimaryColor200;
    var pinForegroundColor = roomModel.fixState == 1 ? kPreviousTextBodyColor : kPreviousPrimaryColor;

    var favoriteBackgroundColor = roomModel.favoriteState == 1 ? kPreviousTextBodyColor : kPreviousPrimaryColor;
    var favoriteForegroundColor = kNeutralColor100;

    final sliderWidth = 60 / MediaQuery.sizeOf(context).width;

    // print('roomModel $roomModel');
    // final test = DateTime.fromMillisecondsSinceEpoch(int.parse(roomModel.lastMessage!.regDate) * 1000).toString().substring(0, 19) + 'Z';
    // print('last reg date ${DateTime.parse(test).toLocal()}');
    // print(
    //     'roomModel.regDate ${roomModel.regDate} / DateTime.parse(roomModel.regDate).toLocal() ${DateTime.parse(roomModel.regDate).toLocal()} / ${DateTime.parse(roomModel.regDate).toLocal().millisecondsSinceEpoch}');

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: sliderWidth * 2, //0.34,
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) async {
              _onPin();
            },
            backgroundColor: pinBackgroundColor,
            foregroundColor: pinForegroundColor,
            child: roomModel.fixState == 1
                ? Image.asset(
                    'assets/image/chat/icon_fix_ac.png',
                    color: pinForegroundColor,
                    width: 25,
                    height: 25,
                  )
                : Image.asset(
                    'assets/image/chat/icon_fix_de.png',
                    color: pinForegroundColor,
                    width: 25,
                    height: 25,
                  ),
            // label: roomModel.fixState == 1 ? '메시지.해제'.tr() : '메시지.고정'.tr(),
            // labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2),
          ),
          CustomSlidableAction(
            onPressed: (_) async {
              _onFavorite();
            },
            backgroundColor: favoriteBackgroundColor,
            foregroundColor: favoriteForegroundColor,
            child: roomModel.favoriteState == 1
                ? Image.asset(
                    'assets/image/chat/icon_star_s_on.png',
                    color: favoriteForegroundColor,
                    width: 25,
                    height: 25,
                  )
                : Image.asset(
                    'assets/image/chat/icon_star_s_off.png',
                    color: favoriteForegroundColor,
                    width: 25,
                    height: 25,
                  ),
            // label: roomModel.favoriteState == 1 ? '메시지.해제'.tr() : '메시지.즐겨찾기'.tr(),
            // labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: sliderWidth, //0.15,
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) async {
              ///TODO
              ///provider call -> leave
              // await room.leave();
              _onLeave();
            },
            backgroundColor: kPreviousErrorColor,
            foregroundColor: kPreviousNeutralColor100,
            child: Image.asset(
              'assets/image/chat/icon_exit.png',
              color: kNeutralColor100,
              width: 25,
              height: 25,
            ),
            // label: '메시지.나가기'.tr(),
            // labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2),
          ),
        ],
      ),
      child: Listener(
        onPointerDown: (details) => _lastPointerDownPosition = details.position,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          onLongPress: () {
            if (onLongPress != null) {
              onLongPress!(_lastPointerDownPosition);
            } else {
              if (_lastPointerDownPosition != null) {
                _showMenu(context, _lastPointerDownPosition!);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
            child: Row(
              children: [
                getProfileAvatar(roomModel.profileImgUrl ?? '', 42, 42),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            roomModel.nick,
                            style: kBody14BoldStyle.copyWith(color: kNeutralColor900),
                          ),
                          Visibility(
                            visible: roomModel.fixState == 1,
                            child: const ImageIcon(
                              AssetImage('assets/image/chat/icon_fix_small.png'),
                              size: 20,
                              color: kNeutralColor400,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              roomModel.lastMessage == null
                                  ? DateTime.fromMillisecondsSinceEpoch(DateTime.parse(roomModel.regDate).toLocal().millisecondsSinceEpoch).localizedTimeDayDiff()
                                  : DateTime.fromMillisecondsSinceEpoch(int.parse(roomModel.lastMessage!.regDate) * 1000).toLocal().localizedTimeDayDiff(),
                              style: kBody12RegularStyle400.copyWith(color: kNeutralColor500),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              roomModel.lastMessage?.type == 'REPORT' ? '메시지.신고한 메시지입니다'.tr() : roomModel.lastMessage?.message ?? '메시지.채팅방이 개설 되었습니다'.tr(),
                              style: roomModel.noReadCount > 0
                                  ? kBody12ExtraBoldStyle.copyWith(color: kNeutralColor500, height: 1.3)
                                  : kBody12RegularStyle400.copyWith(color: kNeutralColor500, height: 1.3),
                              softWrap: false,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          //TODO 수정 필요
                          if (roomModel.noReadCount > 0)
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(color: kErrorColor400, shape: BoxShape.circle),
                              child: Center(
                                child: roomModel.noReadCount > 0
                                    ? Text(
                                        roomModel.noReadCount.toString(),
                                        style: kBody12RegularStyle400.copyWith(color: kWhiteColor),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
