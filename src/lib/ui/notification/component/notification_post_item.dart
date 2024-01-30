import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

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
    this.onTapProfileButton,
    required this.isLiked,
    this.onTap,
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
  final Function? onTapProfileButton;
  final bool isLiked;
  final Function? onTap;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notificationType,
                            style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                          Text(
                            regDate,
                            style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
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
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextTitleColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: name.length > 13 ? '${name.substring(0, 13)}...' : name,
                                      style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
                                        if (onLikeTap != null) {
                                          onLikeTap!(isLiked);
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                                        height: 20,
                                        color: isLiked ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                                      ),
                                    ),
                                    Text(
                                      '좋아요',
                                      style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (onCommentTap != null) {
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
                                      style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            child: Image.network(
                              thumborUrl(imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 52,
                              width: 52,
                              errorBuilder: (context, e, stackTrace) {
                                print('error imgUrl $imgUrl');
                                return const SizedBox(
                                  height: 52,
                                  width: 52,
                                );
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
      ),
    ).throttle();
  }
}
