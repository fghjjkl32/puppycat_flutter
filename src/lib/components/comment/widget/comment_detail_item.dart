import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class CommentDetailItem extends StatelessWidget {
  const CommentDetailItem({
    required this.profileImage,
    required this.name,
    required this.comment,
    required this.isSpecialUser,
    required this.time,
    required this.isReply,
    required this.likeCount,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String name;
  final String comment;
  final bool isSpecialUser;
  final DateTime time;
  final bool isReply;
  final int likeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isReply
              ? SizedBox(
                  width: 60.w,
                )
              : Container(),
          profileImage == null
              ? WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Center(
                    child: Image.asset(
                      'assets/image/feed/icon/large_size/icon_taguser.png',
                      height: 30.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/feed/image/squircle.svg',
                    height: 30.h,
                  ),
                )
              : WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Center(
                    child: Image.asset(
                      profileImage!,
                      height: 30.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/image/feed/image/squircle.svg',
                    height: 30.h,
                    fit: BoxFit.fill,
                  ),
                ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bubble(
                  radius: Radius.circular(10.w),
                  elevation: 0,
                  alignment: Alignment.topLeft,
                  nip: BubbleNip.leftTop,
                  nipOffset: 15.h,
                  color: kNeutralColor200,
                  padding: BubbleEdges.only(
                      left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                name,
                                style: kBody12SemiBoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                displayedAt(time),
                                style: kBody11RegularStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                              Image.asset(
                                'assets/image/feed/icon/small_size/icon_more.png',
                                height: 26.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      LinkifyText(
                        comment,
                        textStyle: kBody11RegularStyle.copyWith(
                            color: kTextSubTitleColor),
                        linkStyle: kBody11RegularStyle.copyWith(
                            color: kSecondaryColor),
                        linkTypes: const [LinkType.hashTag, LinkType.userTag],
                        onTap: (link) {},
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 12.0.w, top: 2.h, right: 2.w),
                      child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/image/feed/icon/small_size/icon_comment_like_off.png',
                          height: 26.w,
                        ),
                      ),
                    ),
                    Text(
                      '$likeCount',
                      style:
                          kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 12.0.w, top: 2.h, right: 2.w),
                      child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'assets/image/feed/icon/small_size/icon_comment_comment.png',
                          height: 24.w,
                        ),
                      ),
                    ),
                    Text(
                      '답글쓰기',
                      style:
                          kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
