import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class NotificationPostItem extends StatefulWidget {
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
  State<NotificationPostItem> createState() => _NotificationPostItemState();
}

class _NotificationPostItemState extends State<NotificationPostItem> with TickerProviderStateMixin {
  bool showLikeLottieAnimation = false;

  late final AnimationController likeController;

  @override
  void initState() {
    likeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    super.initState();
  }

  @override
  void dispose() {
    likeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
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
                  color: widget.isRead ? kPreviousPrimaryLightColor : kPreviousErrorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.onTapProfileButton != null) {
                  widget.onTapProfileButton!();
                }
              },
              child: getProfileAvatar(
                widget.profileImgUrl,
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
                            widget.notificationType,
                            style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                          Text(
                            widget.regDate,
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
                                      text: widget.name.length > 13 ? '${widget.name.substring(0, 13)}...' : widget.name,
                                      style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    ),
                                    TextSpan(text: widget.content),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (!widget.isLiked) {
                                          setState(() {
                                            showLikeLottieAnimation = true;
                                          });

                                          likeController.forward(from: 0);
                                        }

                                        if (widget.onLikeTap != null) {
                                          widget.onLikeTap!(widget.isLiked);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          widget.isLiked
                                              ? showLikeLottieAnimation
                                                  ? Lottie.asset(
                                                      'assets/lottie/icon_like.json',
                                                      controller: likeController,
                                                      onLoaded: (composition) {
                                                        likeController.duration = composition.duration;
                                                        likeController.forward();
                                                      },
                                                    )
                                                  : const Icon(
                                                      Puppycat_social.icon_like_ac,
                                                      color: kPreviousPrimaryColor,
                                                      size: 32,
                                                    )
                                              : Icon(
                                                  Puppycat_social.icon_like_de,
                                                  color: kPreviousTextBodyColor,
                                                  size: 32,
                                                ),
                                          Text(
                                            '좋아요',
                                            style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (widget.onCommentTap != null) {
                                          widget.onCommentTap!();
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/image/feed/icon/small_size/icon_comment_comment.png',
                                            height: 20,
                                          ),
                                          Text(
                                            '댓글쓰기',
                                            style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                                          ),
                                        ],
                                      ),
                                    ).throttle(),
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
                              thumborUrl(widget.imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 52,
                              width: 52,
                              errorBuilder: (context, e, stackTrace) {
                                print('error imgUrl ${widget.imgUrl}');
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
