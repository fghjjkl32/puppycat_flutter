import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class FavoriteItemWidget extends ConsumerStatefulWidget {
  const FavoriteItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.followerUuid,
    required this.contentsIdx,
    required this.oldMemberUuid,
    this.contentType,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final String followerUuid;
  final int contentsIdx;
  final String? contentType;
  final String oldMemberUuid;

  @override
  FavoriteItemWidgetState createState() => FavoriteItemWidgetState();
}

class FavoriteItemWidgetState extends ConsumerState<FavoriteItemWidget> {
  @override
  void initState() {
    super.initState();

    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.followerUuid];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followerUuid, followState: widget.isFollow, isActionButton: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.followerUuid] ?? false;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return InkWell(
      onTap: () {
        myInfo.uuid == widget.followerUuid
            ? context.push("/member/myPage")
            : context.push("/member/userPage", extra: {"nick": widget.userName, "memberUuid": widget.followerUuid, "oldMemberUuid": widget.oldMemberUuid == "" ? null : widget.oldMemberUuid});
        //TODO
        //Route 다시
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: getProfileAvatar(widget.profileImage ?? "", 40, 40),
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
                                        height: 13,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                    ],
                                  )
                                : Container(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.userName,
                                  style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.content,
                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Consumer(builder: (context, ref, child) {
              return myInfo.uuid == widget.followerUuid || widget.userName == "알 수 없음"
                  ? Container()
                  : isFollow
                      ? GestureDetector(
                          onTap: () async {
                            if (!isLogined) {
                              context.push("/home/login");
                            } else {
                              setState(() {
                                ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followerUuid, followState: false, isActionButton: true);
                              });
                            }
                            // setState(() {
                            //   isFollowing = false;
                            // });
                            //
                            // if (widget.contentType == null) {
                            //   await ref.watch(contentLikeUserListStateProvider.notifier).deleteFollow(
                            //         memberIdx: ref.read(userInfoProvider).userModel!.idx,
                            //         followIdx: widget.followerIdx,
                            //         contentsIdx: widget.contentsIdx,
                            //       );
                            // } else {
                            //   ref.watch(feedListStateProvider.notifier).deleteFollow(
                            //         memberIdx: ref.read(userInfoProvider).userModel!.idx,
                            //         followIdx: widget.followerIdx,
                            //         contentsIdx: widget.contentsIdx,
                            //         contentType: widget.contentType,
                            //       );
                            // }
                          },
                          child: Container(
                            width: 56,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: kPreviousNeutralColor300,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "피드.팔로잉".tr(),
                                style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (!isLogined) {
                              context.push("/home/login");
                            } else {
                              setState(() {
                                ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followerUuid, followState: true, isActionButton: true);
                              });
                            }
                            // if (ref.read(userInfoProvider).userModel == null) {
                            //   context.push("/home/login");
                            // } else {
                            //   setState(() {
                            //     isFollowing = true;
                            //   });
                            //   if (widget.contentType == null) {
                            //     await ref.watch(contentLikeUserListStateProvider.notifier).postFollow(
                            //           memberIdx: ref.read(userInfoProvider).userModel!.idx,
                            //           followIdx: widget.followerIdx,
                            //           contentsIdx: widget.contentsIdx,
                            //         );
                            //   } else {
                            //     ref.watch(feedListStateProvider.notifier).postFollow(
                            //           memberIdx: ref.read(userInfoProvider).userModel!.idx,
                            //           followIdx: widget.followerIdx,
                            //           contentsIdx: widget.contentsIdx,
                            //           contentType: widget.contentType,
                            //         );
                            //   }
                            // }
                          },
                          child: Container(
                            width: 56,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: kPreviousPrimaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "피드.팔로우".tr(),
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
