import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum RoomContextMenuType {
  pin,
  favorite,
  leave,
}

class ChatRoomItem extends ConsumerWidget {
  final void Function()? onTap;
  final void Function(Offset?)? onLongPress;
  final void Function()? onLeave;
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
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final screenHeight = overlay.size.height;

    selectedItemBuilder(BuildContext context) {
      return <PopupMenuEntry<RoomContextMenuType>>[
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.pin,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    roomModel.isPin ? '메시지.고정 해제'.tr() : '메시지.고정'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(
                        color: kTextSubTitleColor),
                  ),
                  Spacer(),
                  roomModel.isPin
                      ? Image.asset(
                          'assets/image/chat/icon_fix_ac.png',
                          color: kTextSubTitleColor,
                          width: 20.w,
                          height: 20.h,
                        )
                      : Image.asset(
                          'assets/image/chat/icon_fix_de.png',
                          color: kTextSubTitleColor,
                          width: 20.w,
                          height: 20.h,
                        ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.favorite,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  Text(
                    roomModel.isFavorite ? '메시지.즐겨찾기 해제'.tr() : '메시지.즐겨찾기'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(
                        color: kTextSubTitleColor),
                  ),
                  Spacer(),
                  roomModel.isFavorite
                      ? Image.asset(
                          'assets/image/chat/icon_star_s_on.png',
                          color: kTextSubTitleColor,
                          width: 20.w,
                          height: 20.h,
                        )
                      : Image.asset(
                          'assets/image/chat/icon_star_s_off.png',
                          color: kTextSubTitleColor,
                          width: 20.w,
                          height: 20.h,
                        ),
                ],
              ),
            ),
          ),
        ),
        PopupMenuItem<RoomContextMenuType>(
          value: RoomContextMenuType.leave,
          child: SizedBox(
            width: 212.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 8.h),
              child: Row(
                children: [
                  Text(
                    '메시지.나가기'.tr(),
                    style: kBody12SemiBoldStyle.copyWith(color: kBadgeColor),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/image/chat/icon_exit.png',
                    color: kBadgeColor,
                    width: 20.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    // Get height of single menu item
    final menuItemHeight = 48.0; // Standard Material Design menu item height
    // Calculate estimated menu height
    final menuHeight = selectedItemBuilder(context).length * menuItemHeight;

    // Calculate top of the menu
    final double menuTop = position.dy < screenHeight / 2
        ? position.dy
        : max(0, position.dy - menuHeight);

    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      items: selectedItemBuilder(context),
      position: RelativeRect.fromLTRB(position.dx, menuTop,
          overlay.size.width - position.dx, overlay.size.height - menuTop),
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
      onPin!(roomModel.isPin);
    }
  }

  void _onLeave() {
    if (onLeave != null) {
      onLeave!();
    }
  }

  void _onFavorite() {
    if (onFavorite != null) {
      onFavorite!(roomModel.isFavorite);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pinBackgroundColor =
        roomModel.isPin ? kNeutralColor300 : kPrimaryLightColor;
    var pinForegroundColor = roomModel.isPin ? kTextBodyColor : kPrimaryColor;

    var favoriteBackgroundColor =
        roomModel.isFavorite ? kTextBodyColor : kPrimaryColor;
    var favoriteForegroundColor = kNeutralColor100;

    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 0.34.w,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              _onPin();
            },
            backgroundColor: pinBackgroundColor,
            foregroundColor: pinForegroundColor,
            icon: roomModel.isPin
                ? Image.asset(
                    'assets/image/chat/icon_fix_ac.png',
                    color: pinForegroundColor,
                  )
                : Image.asset(
                    'assets/image/chat/icon_fix_de.png',
                    color: pinForegroundColor,
                  ),
            label: roomModel.isPin ? '메시지.해제'.tr() : '메시지.고정'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
          ),
          SlidableAction(
            onPressed: (_) async {
              _onFavorite();
            },
            backgroundColor: favoriteBackgroundColor,
            foregroundColor: favoriteForegroundColor,
            icon: roomModel.isFavorite
                ? Image.asset(
                    'assets/image/chat/icon_star_s_on.png',
                    color: favoriteForegroundColor,
                  )
                : Image.asset(
                    'assets/image/chat/icon_star_s_off.png',
                    color: favoriteForegroundColor,
                  ),
            label: roomModel.isFavorite ? '메시지.해제'.tr() : '메시지.즐겨찾기'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.15.w,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              ///TODO
              ///provider call -> leave
              // await room.leave();
              _onLeave();
            },
            backgroundColor: kBadgeColor,
            foregroundColor: kPrimaryLightColor,
            icon: Image.asset(
              'assets/image/chat/icon_exit.png',
              color: kNeutralColor100,
            ),
            label: '메시지.나가기'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
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
            padding: EdgeInsets.fromLTRB(12.0.w, 4.0.h, 12.0.w, 4.0.h),
            child: Row(
              children: [
                getProfileAvatar(roomModel.avatarUrl ?? '', 42, 42),
                SizedBox(
                  width: 8.0.w,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            roomModel.nick,
                            style: kBody13BoldStyle.copyWith(
                                color: kTextTitleColor),
                          ),
                          Visibility(
                            visible: roomModel.isPin,
                            child: const ImageIcon(
                              AssetImage(
                                  'assets/image/chat/icon_fix_small.png'),
                              size: 20,
                              color: kNeutralColor400,
                            ),
                          ),
                          const Spacer(),
                          !roomModel.isLastMsgMine
                              ? const SizedBox.shrink()
                              : roomModel.isRead
                                  ? const ImageIcon(
                                      AssetImage(
                                          'assets/image/chat/icon_check_pair.png'),
                                      size: 20,
                                      color: kNeutralColor500,
                                    )
                                  : const ImageIcon(
                                      AssetImage(
                                          'assets/image/chat/icon_check_single.png'),
                                      size: 20,
                                      color: kNeutralColor500,
                                    ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0.w),
                            child: Text(
                              roomModel.msgDateTime,
                              style: kBadge10MediumStyle.copyWith(
                                  color: kNeutralColor500),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              roomModel.lastMsg,
                              style: roomModel.isRead
                                  ? kBody12RegularStyle400.copyWith(
                                      color: kTextBodyColor, height: 1.3)
                                  : kBody12ExtraBoldStyle.copyWith(
                                      color: kTextBodyColor, height: 1.3),
                              softWrap: false,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 32.0.w,
                          ),
                          if (roomModel.newCount > 0)
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: const BoxDecoration(
                                  color: kBadgeColor, shape: BoxShape.circle),
                              child: Center(
                                child: roomModel.newCount > 0
                                    ? Text(
                                        roomModel.newCount.toString(),
                                        style: kBadge8RegularStyle.copyWith(
                                            color: kNeutralColor100),
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
