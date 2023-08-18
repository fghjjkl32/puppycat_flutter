import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedCommentWidget extends ConsumerWidget {
  const FeedCommentWidget({
    required this.profileImage,
    required this.name,
    required this.comment,
    required this.isSpecialUser,
    required this.mentionListData,
    required this.contentIdx,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String name;
  final String comment;
  final bool isSpecialUser;
  final List<MentionListData> mentionListData;
  final int contentIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push("/home/commentDetail/$contentIdx");
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getProfileAvatar(profileImage ?? "", 30.w, 30.h),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: Bubble(
                isComment: true,
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
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: replaceMentionsWithNicknamesInContent(
                            comment,
                            mentionListData,
                            context,
                            kBody11RegularStyle.copyWith(
                                color: kSecondaryColor),
                            ref,
                          ),
                          style: kBody11RegularStyle.copyWith(
                              color: kTextTitleColor),
                        ),
                      ),
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
