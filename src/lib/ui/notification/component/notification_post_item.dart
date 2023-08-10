import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class NotificationPostItem extends StatelessWidget {
  const NotificationPostItem({
    Key? key,
    required this.name,
    required this.regDate,
    required this.isRead,
    required this.notificationType,
    required this.content,
    required this.profileImgUrl,
    required this.imgUrl,
    this.onLikeTap,
    this.onCommentTap,
    required this.isLiked,
  }) : super(key: key);

  final String name;
  final String regDate;
  final bool isRead;
  final String notificationType;
  final String content;
  final String profileImgUrl;
  final String imgUrl;
  final Function? onLikeTap;
  final Function? onCommentTap;
  final bool isLiked;

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
          getProfileAvatar(profileImgUrl, 'assets/image/chat/icon_profile_small.png'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notificationType,
                          style: kBody11SemiBoldStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                        Text(
                          regDate,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print('isLiked 1 $isLiked');
                                      if(onLikeTap != null) {
                                        onLikeTap!(isLiked);
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                                      height: 20,
                                      color: isLiked ? kPrimaryColor : kTextBodyColor,
                                    ),
                                  ),
                                  Text(
                                    '좋아요',
                                    style: kBadge10MediumStyle.copyWith(
                                        color: kTextBodyColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if(onCommentTap != null) {
                                        onCommentTap!();
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/image/feed/icon/small_size/icon_comment_comment.png',
                                      height: 20,
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
                            imgUrl,
                            fit: BoxFit.cover,
                            height: 52,
                            width: 52,
                            errorBuilder: (context, e, stackTrace) {
                              print('error imgUrl $imgUrl');
                              return const SizedBox(height: 52, width: 52,);
                            },
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
      ),
    );
  }
}
