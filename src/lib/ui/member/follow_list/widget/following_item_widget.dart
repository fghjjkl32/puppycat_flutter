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

class FollowingItemWidget extends ConsumerStatefulWidget {
  const FollowingItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.isNewUser,
    required this.followUuid,
    required this.memberUuid,
    required this.oldMemberUuid,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final bool isNewUser;
  final String followUuid;
  final String memberUuid;
  final String oldMemberUuid;

  @override
  FollowingItemWidgetState createState() => FollowingItemWidgetState();
}

class FollowingItemWidgetState extends ConsumerState<FollowingItemWidget> {
  @override
  void initState() {
    super.initState();

    Future(() {
      final currentFollowState = ref.read(followUserStateProvider)[widget.followUuid];
      if (currentFollowState == null) {
        ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followUuid, followState: widget.isFollow, isActionButton: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.followUuid] ?? false;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return InkWell(
      onTap: () {
        myInfo.uuid == widget.followUuid
            ? context.push("/member/myPage")
            : context.push("/member/userPage", extra: {"nick": widget.userName, "memberUuid": widget.followUuid, "oldMemberUuid": widget.oldMemberUuid});

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
                            const SizedBox(
                              width: 4,
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
            myInfo.uuid == widget.followUuid
                ? Container()
                : Consumer(builder: (context, ref, child) {
                    return isFollow
                        ? GestureDetector(
                            onTap: () async {
                              if (!isLogined) {
                                context.push("/home/login");
                              } else {
                                setState(() {
                                  ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followUuid, followState: false, isActionButton: true);
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
                                  "회원.팔로잉".tr(),
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
                                  ref.read(followUserStateProvider.notifier).setFollowState(memberUuid: widget.followUuid, followState: true, isActionButton: true);
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
                                  "회원.팔로우".tr(),
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
