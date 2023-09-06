import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationNoticeItem extends StatelessWidget {
  const NotificationNoticeItem({
    Key? key,
    required this.content,
    required this.regDate,
    required this.isRead,
    required this.profileImgUrl,
    this.onTap,
  }) : super(key: key);

  final String content;
  final String regDate;
  final bool isRead;
  final String profileImgUrl;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(onTap != null) {
          onTap!();
        }
      },
      child: Padding(
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
            getProfileAvatar(profileImgUrl),
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
                            "공지",
                            style: kBody11SemiBoldStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                          Text(
                            regDate,
                            style: kBadge10MediumStyle.copyWith(
                                color: kTextBodyColor),
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
        ),
      ),
    );
  }
}
