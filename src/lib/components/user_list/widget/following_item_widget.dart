import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';

class FollowingItemWidget extends ConsumerStatefulWidget {
  const FollowingItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.isNewUser,
    required this.followIdx,
    required this.memberIdx,
    required this.oldMemberIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final bool isNewUser;
  final int followIdx;
  final int memberIdx;
  final int oldMemberIdx;

  @override
  FollowingItemWidgetState createState() => FollowingItemWidgetState();
}

class FollowingItemWidgetState extends ConsumerState<FollowingItemWidget> {
  @override
  void initState() {
    super.initState();

    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.followIdx];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(widget.followIdx, widget.isFollow);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.followIdx] ?? false;

    return InkWell(
      onTap: () {
        ref.read(userInfoProvider).userModel!.idx == widget.followIdx
            ? context.push("/home/myPage")
            : context.push("/home/myPage/followList/${widget.followIdx}/userPage/${widget.userName}/${widget.followIdx}/${widget.oldMemberIdx}");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                    ),
                    child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                  ),
                  Expanded(
                    child: Column(
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
                            Flexible(
                              child: Text(
                                widget.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            widget.isNewUser
                                ? Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        border: Border.all(color: kPreviousErrorColor),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          "NEW",
                                          style: kBadge9RegularStyle.copyWith(color: kPreviousErrorColor),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          widget.content,
                          style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ref.read(userInfoProvider).userModel!.idx == widget.followIdx
                ? Container()
                : Consumer(builder: (context, ref, child) {
                    return isFollow
                        ? GestureDetector(
                            onTap: () async {
                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                if (ref.read(userInfoProvider).userModel == null) {
                                  context.pushReplacement("/loginScreen");
                                } else {
                                  final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                        memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                        followIdx: widget.followIdx,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.followIdx, false);
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: 56.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: kPreviousNeutralColor300,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "팔로잉",
                                  style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
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
                                        followIdx: widget.followIdx,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.followIdx, true);
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: 56.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                color: kPreviousPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "팔로우",
                                  style: kButton12BoldStyle.copyWith(color: kPreviousNeutralColor100),
                                ),
                              ),
                            ),
                          );
                  })
          ],
        ),
      ),
    );
  }
}
