import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class FollowerItemWidget extends ConsumerStatefulWidget {
  const FollowerItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.followerIdx,
    required this.memberIdx,
    required this.oldMemberIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final int followerIdx;
  final int memberIdx;
  final int oldMemberIdx;

  @override
  FollowerItemWidgetState createState() => FollowerItemWidgetState();
}

class FollowerItemWidgetState extends ConsumerState<FollowerItemWidget> {
  @override
  void initState() {
    super.initState();

    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.followerIdx];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(widget.followerIdx, widget.isFollow);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.followerIdx] ?? false;

    return InkWell(
      onTap: () {
        ref.read(userInfoProvider).userModel!.idx == widget.followerIdx
            ? context.push("/home/myPage")
            : context.push("/home/myPage/followList/${widget.followerIdx}/userPage/${widget.userName}/${widget.followerIdx}/${widget.oldMemberIdx}");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.w,
                  ),
                  child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        widget.isSpecialUser
                            ? Row(
                                children: [
                                  Image.asset(
                                    'assets/image/feed/icon/small_size/icon_special.png',
                                    height: 13.h,
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          widget.userName,
                          style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      widget.content,
                      style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
            ref.read(userInfoProvider).userModel!.idx == widget.followerIdx
                ? Container()
                : Row(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        return isFollow
                            ? GestureDetector(
                                onTap: () async {
                                  if (!ref.watch(followApiIsLoadingStateProvider)) {
                                    if (ref.read(userInfoProvider).userModel == null) {
                                      context.pushReplacement("/loginScreen");
                                    } else {
                                      final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                            memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                            followIdx: widget.followerIdx,
                                          );

                                      if (result.result) {
                                        setState(() {
                                          ref.read(followUserStateProvider.notifier).setFollowState(widget.followerIdx, false);
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: 56.w,
                                  height: 32.h,
                                  decoration: const BoxDecoration(
                                    color: kNeutralColor300,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "팔로잉",
                                      style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (!ref.watch(followApiIsLoadingStateProvider)) {
                                    if (ref.read(userInfoProvider).userModel == null) {
                                      context.pushReplacement("/loginScreen");
                                    } else {
                                      final result = await ref.watch(followStateProvider.notifier).postFollow(
                                            memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                            followIdx: widget.followerIdx,
                                          );

                                      if (result.result) {
                                        setState(() {
                                          ref.read(followUserStateProvider.notifier).setFollowState(widget.followerIdx, true);
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: 56.w,
                                  height: 32.h,
                                  decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "팔로우",
                                      style: kButton12BoldStyle.copyWith(color: kNeutralColor100),
                                    ),
                                  ),
                                ),
                              );
                      }),
                      SizedBox(
                        width: 10.w,
                      ),
                      widget.memberIdx != ref.read(userInfoProvider).userModel!.idx
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.userName,
                                              style: kBody16BoldStyle.copyWith(color: kPrimaryColor),
                                            ),
                                            Text(
                                              " 님을 삭제하시겠어요?",
                                              style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${widget.userName} 님은 팔로워 리스트에서 삭제되며",
                                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                      ),
                                      Text(
                                        "나중에 ${widget.userName} 님을 다시 팔로우 할 수 있습니다.",
                                        style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "취소",
                                                  style: kButton14BoldStyle.copyWith(color: kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                                context.pop();
                                                await ref.watch(followStateProvider.notifier).deleteFollower(
                                                      memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                      followIdx: widget.followerIdx,
                                                    );
                                              }
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kBadgeColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "삭제",
                                                  style: kButton14BoldStyle.copyWith(color: kNeutralColor100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(
                                Puppycat_social.icon_close_large,
                                size: 20,
                                color: kNeutralColor500,
                              ),
                            ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
