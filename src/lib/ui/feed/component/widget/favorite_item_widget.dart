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
        ref.read(followUserStateProvider.notifier).setFollowState(widget.followerUuid, widget.isFollow);
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
            : context.push("/member/userPage/${widget.userName}/${widget.followerUuid}/${widget.oldMemberUuid == "" ? null : widget.oldMemberUuid}");
        //TODO
        //Route 다시
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: getProfileAvatar(widget.profileImage ?? "", 40, 40),
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
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          widget.userName,
                          style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
              ],
            ),
            Consumer(builder: (context, ref, child) {
              return myInfo.uuid == widget.followerUuid
                  ? Container()
                  : isFollow
                      ? GestureDetector(
                          onTap: () async {
                            if (!ref.watch(followApiIsLoadingStateProvider)) {
                              if (!isLogined) {
                                context.push("/home/login");
                              } else {
                                final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                      followUuid: widget.followerUuid,
                                    );

                                if (result.result) {
                                  setState(() {
                                    ref.read(followUserStateProvider.notifier).setFollowState(widget.followerUuid, false);
                                  });
                                }
                              }
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
                                "팔로잉",
                                style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (!ref.watch(followApiIsLoadingStateProvider)) {
                              if (!isLogined) {
                                context.push("/home/login");
                              } else {
                                final result = await ref.watch(followStateProvider.notifier).postFollow(
                                      followUuid: widget.followerUuid,
                                    );

                                if (result.result) {
                                  setState(() {
                                    ref.read(followUserStateProvider.notifier).setFollowState(widget.followerUuid, true);
                                  });
                                }
                              }
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
