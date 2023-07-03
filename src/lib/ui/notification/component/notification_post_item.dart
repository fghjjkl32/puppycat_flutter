import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationPostItem extends StatelessWidget {
  const NotificationPostItem({
    Key? key,
    required this.name,
    required this.time,
    required this.isRead,
    required this.notificationType,
    required this.content,
  }) : super(key: key);

  final String name;
  final DateTime time;
  final bool isRead;
  final String notificationType;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notificationType,
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
                      child: Column(
                        children: [
                          RichText(
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
                                TextSpan(text: content),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                                    height: 20.w,
                                  ),
                                ),
                                Text(
                                  '좋아요',
                                  style: kBadge10MediumStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/image/feed/icon/small_size/icon_comment_comment.png',
                                    height: 20.w,
                                  ),
                                ),
                                Text(
                                  '댓글쓰기',
                                  style: kBadge10MediumStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80",
                          fit: BoxFit.cover,
                          height: 40.h,
                          width: 52.w,
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
