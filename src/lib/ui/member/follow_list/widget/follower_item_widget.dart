import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';

class FollowerItemWidget extends ConsumerStatefulWidget {
  const FollowerItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.followerUuid,
    required this.memberUuid,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final String followerUuid;
  final String memberUuid;
  final String oldMemberUuid;

  @override
  FollowerItemWidgetState createState() => FollowerItemWidgetState();
}

class FollowerItemWidgetState extends ConsumerState<FollowerItemWidget> {
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
            : context.push("/member/userPage", extra: {"nick": widget.userName, "memberUuid": widget.followerUuid, "oldMemberUuid": widget.oldMemberUuid});

        //TODO
        //Route 다시
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8, top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
                            Flexible(
                              child: Text(
                                widget.userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
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
            myInfo.uuid == widget.followerUuid
                ? Container()
                : Row(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        return isFollow
                            ? GestureDetector(
                                onTap: () async {
                                  if (!isLogined) {
                                    context.push("/home/login");
                                  } else {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.followerUuid, false);
                                    });
                                  }
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
                                  if (!isLogined) {
                                    context.push("/home/login");
                                  } else {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.followerUuid, true);
                                    });
                                  }
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
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      widget.memberUuid != myInfo.uuid
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Lottie.asset(
                                          'assets/lottie/feed_end.json',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill,
                                          repeat: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${widget.userName.length > 8 ? '${widget.userName.substring(0, 8)}...' : widget.userName}님의 팔로우를 끊을까요?",
                                              style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "내 팔로워 목록에서는 삭제되지만",
                                        style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                      ),
                                      Text(
                                        "${widget.userName.length > 8 ? '${widget.userName.substring(0, 8)}...' : widget.userName}님이 ${myInfo.nick!.length > 8 ? '${myInfo.nick?.substring(0, 8)}...' : myInfo.nick}님을 다시 팔로우할 수 있어요.",
                                        style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: 152,
                                              height: 36,
                                              decoration: const BoxDecoration(
                                                color: kBackgroundSecondary,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "닫기",
                                                  style: kButton14BoldStyle.copyWith(color: kTextSecondary),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              context.pop();
                                              await ref.watch(followStateProvider.notifier).deleteFollower(
                                                    followUuid: widget.followerUuid,
                                                  );
                                            },
                                            child: Container(
                                              width: 152,
                                              height: 36,
                                              decoration: const BoxDecoration(
                                                color: kBackgroundActionPrimary,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "팔로우 끊기",
                                                  style: kButton14BoldStyle.copyWith(color: kTextWhite),
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
                                color: kPreviousNeutralColor500,
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
