import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user_list/popular_user_list/popular_user_list_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class FeedFollowCardWidget extends ConsumerStatefulWidget {
  const FeedFollowCardWidget({
    required this.profileImage,
    required this.userName,
    required this.imageList,
    required this.followCount,
    required this.isSpecialUser,
    required this.memberUuid,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final List<ContentsListData> imageList;
  final String? profileImage;
  final String userName;
  final int followCount;
  final bool isSpecialUser;
  final String memberUuid;
  final String oldMemberUuid;

  @override
  FeedFollowCardWidgetState createState() => FeedFollowCardWidgetState();
}

class FeedFollowCardWidgetState extends ConsumerState<FeedFollowCardWidget> {
  @override
  void initState() {
    super.initState();
    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.memberUuid];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberUuid] ?? false;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          boxShadow: [
            const BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 6,
              spreadRadius: 0,
              color: Color(0x0A000000),
            ),
            const BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 0,
              color: Color(0x1F000000),
            ),
          ],
        ),
        width: 230,
        height: 202,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  myInfo.uuid == widget.memberUuid
                      ? context.push("/member/myPage", extra: {"oldMemberUuid": widget.oldMemberUuid})
                      : context.push("/member/userPage/${widget.userName}/${widget.memberUuid}/${widget.oldMemberUuid}");
                },
                child: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 12,
                          bottom: 12,
                          right: 8,
                        ),
                        child: getProfileAvatar(widget.profileImage ?? "", 32, 32),
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
                                            height: 13,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Flexible(
                                  child: Text(
                                    widget.userName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTitle14BoldStyle.copyWith(color: kTextSecondary),
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
                                            if (!isLogined) {
                                              context.push("/home/login");
                                            } else {
                                              setState(() {
                                                ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, false);
                                              });
                                            }
                                          },
                                          child: Text(
                                            "팔로잉",
                                            style: kTitle14BoldStyle.copyWith(color: kPreviousNeutralColor500),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () async {
                                            if (!isLogined) {
                                              context.push("/home/login");
                                            } else {
                                              setState(() {
                                                ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, true);
                                              });
                                            }
                                          },
                                          child: Text(
                                            "팔로우",
                                            style: kTitle14BoldStyle.copyWith(color: kTextActionPrimary),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "팔로워 ${NumberFormat('###,###,###,###').format(widget.followCount)}",
                              style: kBody12RegularStyle.copyWith(color: kTextTertiary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).throttle(),
            ),
            if (widget.imageList.length == 1) ...[
              GestureDetector(
                onTap: () async {
                  await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[0].idx!).then((value) {
                    if (value == null) {
                      return;
                    }
                    Map<String, dynamic> extraMap = {
                      'firstTitle': widget.userName,
                      'secondTitle': "피드",
                      'memberUuid': widget.memberUuid,
                      'contentIdx': widget.imageList[0].idx!,
                      'contentType': "FollowCardContent",
                      'oldMemberUuid': widget.oldMemberUuid,
                    };

                    context.push('/feed/detail', extra: extraMap);
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
                              thumborUrl(widget.imageList[0].imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 147,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                child: Center(
                                  child: Text(
                                    "${widget.imageList[0].imageCnt}",
                                    style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).throttle(),
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
                          Map<String, dynamic> extraMap = {
                            'firstTitle': widget.userName,
                            'secondTitle': "피드",
                            'memberUuid': widget.memberUuid,
                            'contentIdx': widget.imageList[0].idx!,
                            'contentType': "FollowCardContent",
                            'oldMemberUuid': widget.oldMemberUuid,
                          };

                          context.push('/feed/detail', extra: extraMap);
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              thumborUrl(widget.imageList[0].imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 147,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                child: Center(
                                  child: Text(
                                    "${widget.imageList[0].imageCnt}",
                                    style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).throttle(),
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
                          Map<String, dynamic> extraMap = {
                            'firstTitle': widget.userName,
                            'secondTitle': "피드",
                            'memberUuid': widget.memberUuid,
                            'contentIdx': widget.imageList[1].idx!,
                            'contentType': "FollowCardContent",
                            'oldMemberUuid': widget.oldMemberUuid,
                          };

                          context.push('/feed/detail', extra: extraMap);
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              thumborUrl(widget.imageList[1].imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 147,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                child: Center(
                                  child: Text(
                                    "${widget.imageList[1].imageCnt}",
                                    style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).throttle(),
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
                          Map<String, dynamic> extraMap = {
                            'firstTitle': widget.userName,
                            'secondTitle': "피드",
                            'memberUuid': widget.memberUuid,
                            'contentIdx': widget.imageList[0].idx!,
                            'contentType': "FollowCardContent",
                            'oldMemberUuid': widget.oldMemberUuid,
                          };

                          context.push('/feed/detail', extra: extraMap);
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: Image.network(
                              thumborUrl(widget.imageList[0].imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 147,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff414348).withOpacity(0.75),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                child: Center(
                                  child: Text(
                                    "${widget.imageList[0].imageCnt}",
                                    style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).throttle(),
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
                              Map<String, dynamic> extraMap = {
                                'firstTitle': widget.userName,
                                'secondTitle': "피드",
                                'memberUuid': widget.memberUuid,
                                'contentIdx': widget.imageList[1].idx!,
                                'contentType': "FollowCardContent",
                                'oldMemberUuid': widget.oldMemberUuid,
                              };

                              context.push('/feed/detail', extra: extraMap);
                            });
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                thumborUrl(widget.imageList[1].imgUrl ?? ''),
                                fit: BoxFit.cover,
                                height: 73,
                                width: double.infinity,
                              ),
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff414348).withOpacity(0.75),
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                    child: Center(
                                      child: Text(
                                        "${widget.imageList[1].imageCnt}",
                                        style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).throttle(),
                        const SizedBox(
                          height: 1,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState("FollowCardContent", widget.imageList[2].idx!).then((value) {
                              if (value == null) {
                                return;
                              }
                              Map<String, dynamic> extraMap = {
                                'firstTitle': widget.userName,
                                'secondTitle': "피드",
                                'memberUuid': widget.memberUuid,
                                'contentIdx': widget.imageList[2].idx!,
                                'contentType': "FollowCardContent",
                                'oldMemberUuid': widget.oldMemberUuid,
                              };

                              context.push('/feed/detail', extra: extraMap);
                            });
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  thumborUrl(widget.imageList[2].imgUrl ?? ''),
                                  fit: BoxFit.cover,
                                  height: 73,
                                  width: double.infinity,
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff414348).withOpacity(0.75),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6.0),
                                      child: Center(
                                        child: Text(
                                          "${widget.imageList[2].imageCnt}",
                                          style: kBody12RegularStyle.copyWith(color: kTextWhite),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).throttle(),
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
