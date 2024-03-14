import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class NotificationNoticeItem extends StatelessWidget {
  const NotificationNoticeItem({
    Key? key,
    required this.content,
    required this.regDate,
    required this.isRead,
    required this.profileImgUrl,
    this.onTap,
    this.onTapProfileButton,
  }) : super(key: key);

  final String content;
  final String regDate;
  final bool isRead;
  final String profileImgUrl;
  final Function? onTap;
  final Function? onTapProfileButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
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
                  color: isRead ? kPreviousPrimaryLightColor : kPreviousErrorColor,
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
                            "알림함.공지".tr(),
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                          Text(
                            regDate,
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      content,
                      style: kBody13RegularStyle.copyWith(color: kPreviousTextTitleColor),
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
