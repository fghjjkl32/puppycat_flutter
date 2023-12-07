import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/feed_detail/feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:thumbor/thumbor.dart';

class FeedFollowCardWidget extends ConsumerStatefulWidget {
  const FeedFollowCardWidget({
    required this.profileImage,
    required this.userName,
    required this.imageList,
    required this.followCount,
    required this.isSpecialUser,
    required this.memberIdx,
    required this.oldMemberIdx,
    Key? key,
  }) : super(key: key);

  final List<ContentsListData> imageList;
  final String? profileImage;
  final String userName;
  final int followCount;
  final bool isSpecialUser;
  final int memberIdx;
  final int oldMemberIdx;

  @override
  FeedFollowCardWidgetState createState() => FeedFollowCardWidgetState();
}

class FeedFollowCardWidgetState extends ConsumerState<FeedFollowCardWidget> {
  @override
  void initState() {
    super.initState();
    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.memberIdx];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberIdx] ?? false;

    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: kPreviousNeutralColor300,
          ),
          color: kWhiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 6,
              spreadRadius: 0,
              color: Color(0x0A000000),
            ),
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 0,
              color: Color(0x1F000000),
            ),
          ],
        ),
        width: 230.w,
        height: 202.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  ref.read(userInfoProvider).userModel?.idx == widget.memberIdx
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPageMainScreen(
                              oldMemberIdx: widget.oldMemberIdx,
                            ),
                          ),
                        )
                      : context.push("/home/myPage/followList/${widget.memberIdx}/userPage/${widget.userName}/${widget.memberIdx}/${widget.oldMemberIdx}");
                },
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.w,
                          top: 12.h,
                          bottom: 12.h,
                          right: 8.w,
                        ),
                        child: getProfileAvatar(widget.profileImage ?? "", 32.w, 32.h),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                Text(
                                  "  ·  ",
                                  style: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor400),
                                ),
                                isFollow
                                    ? Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () async {
                                            if (!ref.watch(followApiIsLoadingStateProvider)) {
                                              if (ref.read(userInfoProvider).userModel == null) {
                                                context.pushReplacement("/loginScreen");
                                              } else {
                                                final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                                      memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                      followIdx: widget.memberIdx,
                                                    );

                                                if (result.result) {
                                                  setState(() {
                                                    ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, false);
                                                  });
                                                }
                                                print(ref.read(followUserStateProvider));
                                              }
                                            }
                                          },
                                          child: Text(
                                            "팔로잉",
                                            style: kBody12SemiBoldStyle.copyWith(color: kPreviousNeutralColor500),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () async {
                                            if (!ref.watch(followApiIsLoadingStateProvider)) {
                                              if (ref.read(userInfoProvider).userModel == null) {
                                                context.pushReplacement("/loginScreen");
                                              } else {
                                                final result = await ref.watch(followStateProvider.notifier).postFollow(
                                                      memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                      followIdx: widget.memberIdx,
                                                    );

                                                if (result.result) {
                                                  setState(() {
                                                    ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, true);
                                                  });
                                                }
                                              }
                                            }
                                          },
                                          child: Text(
                                            "팔로우",
                                            style: kBody12SemiBoldStyle.copyWith(color: kPreviousPrimaryColor),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "팔로워 ${NumberFormat('###,###,###,###').format(widget.followCount)}",
                              style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.imageList.length == 1) ...[
              GestureDetector(
                onTap: () async {
                  await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[0].idx!).then((value) {
                    if (value == null) {
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedDetailScreen(
                                firstTitle: widget.userName,
                                secondTitle: "피드",
                                memberIdx: widget.memberIdx,
                                contentIdx: widget.imageList[0].idx!,
                                contentType: "FollowCardContent",
                                oldMemberIdx: widget.oldMemberIdx,
                              )),
                    );
                  });
                },
                child: Row(
                  children: [
                    Flexible(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[0].imgUrl!}").toUrl(),
                              fit: BoxFit.cover,
                              height: 147.h,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 4.w,
                            top: 4.w,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              width: 18.w,
                              height: 14.w,
                              child: Center(
                                child: Text(
                                  "${widget.imageList[0].imageCnt}",
                                  style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (widget.imageList.length == 2) ...[
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[0].idx!).then((value) {
                          if (value == null) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedDetailScreen(
                                      firstTitle: widget.userName,
                                      secondTitle: "피드",
                                      memberIdx: widget.memberIdx,
                                      contentIdx: widget.imageList[0].idx!,
                                      contentType: "FollowCardContent",
                                      oldMemberIdx: widget.oldMemberIdx,
                                    )),
                          );
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[0].imgUrl!}").toUrl(),
                              fit: BoxFit.cover,
                              height: 147.h,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 4.w,
                            top: 4.w,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              width: 18.w,
                              height: 14.w,
                              child: Center(
                                child: Text(
                                  "${widget.imageList[0].imageCnt}",
                                  style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[1].idx!).then((value) {
                          if (value == null) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedDetailScreen(
                                      firstTitle: widget.userName,
                                      secondTitle: "피드",
                                      memberIdx: widget.memberIdx,
                                      contentIdx: widget.imageList[1].idx!,
                                      contentType: "FollowCardContent",
                                      oldMemberIdx: widget.oldMemberIdx,
                                    )),
                          );
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[1].imgUrl!}").toUrl(),
                              fit: BoxFit.cover,
                              height: 147.h,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 4.w,
                            top: 4.w,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              width: 18.w,
                              height: 14.w,
                              child: Center(
                                child: Text(
                                  "${widget.imageList[1].imageCnt}",
                                  style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (widget.imageList.length == 3) ...[
              Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: GestureDetector(
                      onTap: () async {
                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[0].idx!).then((value) {
                          if (value == null) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedDetailScreen(
                                      firstTitle: widget.userName,
                                      secondTitle: "피드",
                                      memberIdx: widget.memberIdx,
                                      contentIdx: widget.imageList[0].idx!,
                                      contentType: "FollowCardContent",
                                      oldMemberIdx: widget.oldMemberIdx,
                                    )),
                          );
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[0].imgUrl!}").toUrl(),
                              fit: BoxFit.cover,
                              height: 147.h,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 4.w,
                            top: 4.w,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              width: 18.w,
                              height: 14.w,
                              child: Center(
                                child: Text(
                                  "${widget.imageList[0].imageCnt}",
                                  style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[1].idx!).then((value) {
                              if (value == null) {
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedDetailScreen(
                                          firstTitle: widget.userName,
                                          secondTitle: "피드",
                                          memberIdx: widget.memberIdx,
                                          contentIdx: widget.imageList[1].idx!,
                                          contentType: "FollowCardContent",
                                          oldMemberIdx: widget.oldMemberIdx,
                                        )),
                              );
                            });
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[1].imgUrl!}").toUrl(),
                                fit: BoxFit.cover,
                                height: 73.h,
                                width: double.infinity,
                              ),
                              Positioned(
                                right: 4.w,
                                top: 4.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff414348).withOpacity(0.75),
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  width: 18.w,
                                  height: 14.w,
                                  child: Center(
                                    child: Text(
                                      "${widget.imageList[1].imageCnt}",
                                      style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[2].idx!).then((value) {
                              if (value == null) {
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedDetailScreen(
                                          firstTitle: widget.userName,
                                          secondTitle: "피드",
                                          memberIdx: widget.memberIdx,
                                          contentIdx: widget.imageList[2].idx!,
                                          contentType: "FollowCardContent",
                                          oldMemberIdx: widget.oldMemberIdx,
                                        )),
                              );
                            });
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${widget.imageList[2].imgUrl!}").toUrl(),
                                  fit: BoxFit.cover,
                                  height: 73.h,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  right: 4.w,
                                  top: 4.w,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff414348).withOpacity(0.75),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    width: 18.w,
                                    height: 14.w,
                                    child: Center(
                                      child: Text(
                                        "${widget.imageList[2].imageCnt}",
                                        style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
