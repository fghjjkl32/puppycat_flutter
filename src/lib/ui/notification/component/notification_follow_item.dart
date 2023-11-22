import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationFollowItem extends StatelessWidget {
  const NotificationFollowItem({
    Key? key,
    required this.name,
    required this.isRead,
    required this.regDate,
    required this.profileImgUrl,
    required this.isFollowed,
    this.onTapProfileButton,
    this.onTapFollowButton,
  }) : super(key: key);

  final String name;
  final String regDate;
  final bool isRead;
  final String profileImgUrl;
  final bool isFollowed;
  final Function? onTapProfileButton;
  final Function? onTapFollowButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: isRead ? kPrimaryLightColor : kBadgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (onTapProfileButton != null) {
                onTapProfileButton!();
              }
            },
            child: getProfileAvatar(
              profileImgUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "새로운 팔로우",
                          style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                        ),
                        Text(
                          regDate,
                          style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: name.length > 13 ? '${name.substring(0, 13)}...' : name,
                                style: kBody13BoldStyle.copyWith(color: kTextTitleColor),
                              ),
                              const TextSpan(text: '님이 나를 팔로우하기 시작했습니다.'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 4.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: isFollowed ? kTextBodyColor : kNeutralColor100,
                            backgroundColor: isFollowed ? kNeutralColor300 : kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (onTapFollowButton != null) {
                              onTapFollowButton!(isFollowed);
                            }
                          },
                          child: isFollowed
                              ? Text(
                                  '팔로잉'.tr(),
                                  style: kButton12BoldStyle,
                                )
                              : Text(
                                  '팔로우'.tr(),
                                  style: kButton12BoldStyle,
                                ),
                        ),
                        // Container(
                        //   width: 52,
                        //   height: 26,
                        //   decoration: const BoxDecoration(
                        //     color: kPrimaryColor,
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(8.0),
                        //     ),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       "팔로우",
                        //       style: kButton12BoldStyle.copyWith(color: kNeutralColor100),
                        //     ),
                        //   ),
                        // ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
