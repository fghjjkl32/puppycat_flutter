import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationFollowItem extends StatelessWidget {
  const NotificationFollowItem({
    Key? key,
    required this.name,
    required this.time,
    required this.isRead,
  }) : super(key: key);

  final String name;
  final DateTime time;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: 8.0.w,
            height: 8.0.h,
            decoration: BoxDecoration(
              color: isRead ? kPrimaryLightColor : kBadgeColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        WidgetMask(
          blendMode: BlendMode.srcATop,
          childSaveLayer: true,
          mask: Center(
            child: Image.asset(
              'assets/image/feed/icon/large_size/icon_taguser.png',
              height: 28.h,
              fit: BoxFit.fill,
            ),
          ),
          child: SvgPicture.asset(
            'assets/image/feed/image/squircle.svg',
            height: 28.h,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12.h, left: 10.0.w, right: 12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "새로운 팔로우",
                        style: kBody11SemiBoldStyle.copyWith(
                            color: kTextBodyColor),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd a h:mm', 'ko_KR')
                            .format(DateTime.now()),
                        style:
                            kBadge10MediumStyle.copyWith(color: kTextBodyColor),
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
                          style: kBody13RegularStyle.copyWith(
                              color: kTextTitleColor),
                          children: <TextSpan>[
                            TextSpan(
                              text: name.length > 13
                                  ? '${name.substring(0, 13)}...'
                                  : name,
                              style: kBody13BoldStyle.copyWith(
                                  color: kTextTitleColor),
                            ),
                            const TextSpan(text: '님이 나를 팔로우하기 시작했습니다.'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 4.w),
                      child: Container(
                        width: 52.w,
                        height: 26.h,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
