import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:widget_mask/widget_mask.dart';

class FollowingItemWidget extends ConsumerWidget {
  const FollowingItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    required this.isFollow,
    required this.isNewUser,
    required this.followIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;
  final bool isFollow;
  final bool isNewUser;
  final int followIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 16.h),
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
                child: profileImage == null
                    ? WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Center(
                          child: Image.asset(
                            'assets/image/feed/icon/large_size/icon_taguser.png',
                            height: 32.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 32.h,
                        ),
                      )
                    : WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Center(
                          child: Image.asset(
                            profileImage!,
                            height: 32.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 32.h,
                          fit: BoxFit.fill,
                        ),
                      ),
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
                      SizedBox(
                        width: 4.w,
                      ),
                      isNewUser
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(color: kBadgeColor),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "NEW",
                                    style: kBadge9RegularStyle.copyWith(
                                        color: kBadgeColor),
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
                    content,
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                  ),
                ],
              ),
            ],
          ),
          isFollow
              ? GestureDetector(
                  onTap: () async {
                    await ref.watch(followStateProvider.notifier).postFollow(
                          memberIdx: ref.read(userModelProvider)!.idx,
                          followIdx: followIdx,
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
                    await ref.watch(followStateProvider.notifier).deleteFollow(
                          memberIdx: ref.read(userModelProvider)!.idx,
                          followIdx: followIdx,
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
                        style:
                            kButton12BoldStyle.copyWith(color: kTextBodyColor),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
