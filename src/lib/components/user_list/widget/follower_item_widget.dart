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

class FollowerItemWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(userModelProvider)!.idx == followerIdx
            ? context.push("/home/myPage")
            : context.push(
                "/home/myPage/followList/$followerIdx/userPage/$userName/$followerIdx/$oldMemberIdx");
      },
      child: Padding(
        padding:
            EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 8.h, top: 8.h),
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
                  child: getProfileAvatar(profileImage ?? "", 32.w, 32.h),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        isSpecialUser
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
                          userName,
                          style:
                              kBody13BoldStyle.copyWith(color: kTextTitleColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      content,
                      style:
                          kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
            ref.read(userModelProvider)!.idx == followerIdx
                ? Container()
                : Row(
                    children: [
                      isFollow
                          ? GestureDetector(
                              onTap: () async {
                                await ref
                                    .watch(followStateProvider.notifier)
                                    .postFollow(
                                      memberIdx:
                                          ref.read(userModelProvider)!.idx,
                                      followIdx: followerIdx,
                                    );
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
                                    style: kButton12BoldStyle.copyWith(
                                        color: kNeutralColor100),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await ref
                                    .watch(followStateProvider.notifier)
                                    .deleteFollow(
                                      memberIdx:
                                          ref.read(userModelProvider)!.idx,
                                      followIdx: followerIdx,
                                    );
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
                                    style: kButton12BoldStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        width: 10.w,
                      ),
                      memberIdx != ref.read(userModelProvider)!.idx
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.h, bottom: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userName,
                                              style: kBody16BoldStyle.copyWith(
                                                  color: kPrimaryColor),
                                            ),
                                            Text(
                                              " 님을 삭제하시겠어요?",
                                              style: kBody16BoldStyle.copyWith(
                                                  color: kTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "$userName 님은 팔로워 리스트에서 삭제되며",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      Text(
                                        "나중에 $userName 님을 다시 팔로우 할 수 있습니다.",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color: kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              context.pop();
                                              await ref
                                                  .watch(followStateProvider
                                                      .notifier)
                                                  .deleteFollower(
                                                    memberIdx: ref
                                                        .read(
                                                            userModelProvider)!
                                                        .idx,
                                                    followIdx: followerIdx,
                                                  );
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
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
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
