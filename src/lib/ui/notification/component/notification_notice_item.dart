import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationNoticeItem extends StatelessWidget {
  const NotificationNoticeItem({
    Key? key,
    required this.content,
    required this.time,
    required this.isRead,
  }) : super(key: key);

  final String content;
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
                        "공지",
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
                Text(
                  content,
                  style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
