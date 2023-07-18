import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/util/extensions/date_time_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatRoomItem extends ConsumerWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function()? onLeave;

  // final String avatarUrl;
  // final String nick;
  // final String lastMsg;
  // final int newCount;
  // final bool isRead;
  // final bool isPin;
  // final String msgDateTime;
  // final bool isMine;
  final ChatRoomModel roomModel;

  const ChatRoomItem({
    Key? key,
    this.onTap,
    this.onLongPress,
    this.onLeave,
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

  Widget getAvatar() {
    return WidgetMask(
      blendMode: BlendMode.srcATop,
      childSaveLayer: true,
      mask: Center(
        child: Image.network(
          roomModel.avatarUrl != null ? roomModel.avatarUrl! : 'https://via.placeholder.com/150/f66b97',
          // width: 42.w,
          height: 41.h,
          fit: BoxFit.fill,
        ),
      ),
      child: SvgPicture.asset(
        'assets/image/feed/image/squircle.svg',
        width: 41.w,
        height: 41.h,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 0.42.w,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              ///TODO
              ///provider call -> setFavorite (=> setPin)
              // await room.setFavourite(!room.isFavourite);
            },
            backgroundColor: kPrimaryLightColor,
            foregroundColor: kPrimaryColor,
            icon: Icons.push_pin,
            label: '메시지.고정'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
          ),
          SlidableAction(
            onPressed: (_) async {
              ///TODO
              ///provider call -> setFavorite(API)
              // await room.setFavourite(!room.isFavourite);
            },
            backgroundColor: kPrimaryColor,
            foregroundColor: kPrimaryLightColor,
            icon: Icons.star_border,
            label: '메시지.즐겨찾기'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.21.w,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              ///TODO
              ///provider call -> leave
              // await room.leave();
              if(onLeave != null) {
                onLeave!();
              }
            },
            backgroundColor: kBadgeColor,
            foregroundColor: kPrimaryLightColor,
            icon: Icons.exit_to_app,
            label: '메시지.나가기'.tr(),
            labelStyle: kBody11SemiBoldStyle.copyWith(height: 1.2.h),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        onLongPress: () {

        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0.w, 4.0.h, 12.0.w, 4.0.h),
          child: Row(
            children: [
              getAvatar(),
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
                          style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                        ),
                        Visibility(
                          visible: roomModel.isPin,
                          child: const Icon(Icons.push_pin), //TODO  나중에 이미지 바꾸기
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.check,
                          size: 15,
                        ),//TODO  나중에 이미지 바꾸기
                        Padding(
                          padding: EdgeInsets.only(left: 4.0.w),
                          child: Text(
                            roomModel.msgDateTime,
                            style: kBadge10MediumStyle.copyWith(color: kNeutralColor500),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            roomModel.lastMsg,
                            style: roomModel.isRead ? kBody12RegularStyle400.copyWith(color: kTextBodyColor, height: 1.3) : kBody12ExtraBoldStyle.copyWith(color: kTextBodyColor, height: 1.3),
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
                            decoration: const BoxDecoration(color: kBadgeColor, shape: BoxShape.circle),
                            child: Center(
                              child: roomModel.newCount > 0
                                  ? Text(
                                roomModel.newCount.toString(),
                                style: kBadge8RegularStyle.copyWith(color: kNeutralColor100),
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
    );
  }
}
