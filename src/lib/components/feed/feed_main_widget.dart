import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_best_post_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_walk_info_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';

class FeedMainWidget extends ConsumerWidget {
  const FeedMainWidget(
      {required this.feedData,
      required this.contentType,
      required this.userName,
      required this.profileImage,
      required this.oldMemberIdx,
      required this.firstTitle,
      required this.secondTitle,
      required this.imageDomain,
      required this.index,
      required this.feedType,
      required this.isSpecialUser,
      required this.onTapHideButton,
      Key? key})
      : super(key: key);

  final FeedData feedData;
  final String contentType;
  final int? oldMemberIdx;
  final String userName;
  final String profileImage;
  final String firstTitle;
  final String secondTitle;
  final String imageDomain;
  final int index;
  final String feedType;
  final bool isSpecialUser;

  final Function onTapHideButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> extraMap = {
          'firstTitle': firstTitle,
          'secondTitle': secondTitle,
          'memberIdx': '${feedData.memberIdx}',
          'contentIdx': '${feedData.idx}',
          'contentType': contentType,
        };

        print("feedData.memberIdx ${feedData.memberIdx}");
        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(contentType, feedData.idx).then((value) {
          if (value == null) {
            return;
          }
          // context.push("/home/myPage/detail/$firstTitle/$secondTitle/${feedData.memberIdx}/${feedData.idx}/$contentType");
          context.push('/home/myPage/detail', extra: extraMap);
        });
      },
      child: Material(
        child: Container(
          color: kNeutralColor100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (index == 0 && feedType == "follow")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h, top: 24),
                      child: Text(
                        "요즘 인기 퍼플루언서",
                        style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                      ),
                    ),
                    FeedFollowWidget(
                      popularUserListData: ref.watch(popularUserListStateProvider).list,
                      oldMemberIdx: oldMemberIdx ?? 0,
                    ),
                  ],
                ),
              if (index == 0 && feedType == "popular")
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w, right: 10.w),
                  child: Text(
                    "베스트 댕냥 피드",
                    style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                  ),
                ),
              if (index == 4 && feedType == "recent")
                FeedFollowWidget(
                  popularUserListData: ref.watch(popularUserListStateProvider).list,
                  oldMemberIdx: oldMemberIdx ?? 0,
                ),
              if (index != 0 && index % 10 == 0 && feedType == "recent")
                FeedBestPostWidget(
                  feedData: ref.watch(popularHourFeedStateProvider).list,
                ),
              index == 0
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              FeedTitleWidget(
                profileImage: profileImage,
                userName: userName,
                address: feedData.location ?? "",
                time: feedData.regDate!,
                isEdit: feedData.modifyState == 1,
                memberIdx: feedData.memberIdx,
                isKeep: feedData.keepState == 1,
                contentIdx: feedData.idx,
                contentType: contentType,
                feedData: feedData,
                oldMemberIdx: oldMemberIdx ?? 0,
                isDetailWidget: false,
                feedType: feedType,
                isSpecialUser: isSpecialUser,
                onTapHideButton: () async {
                  onTapHideButton();
                },
              ),
              FeedImageMainWidget(
                imageList: feedData.imgList!,
                imageDomain: imageDomain,
              ),
              FeedWalkInfoWidget(
                walkData: feedData.walkResultList,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final style = kBody13RegularStyle.copyWith(color: kTextTitleColor);
                    final double maxWidth = constraints.maxWidth * 0.7;

                    final TextPainter textPainter = TextPainter(
                      text: TextSpan(
                        text: feedData.contents,
                        style: style,
                      ),
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: maxWidth);

                    if (textPainter.didExceedMaxLines) {
                      return Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: replaceMentionsWithNicknamesInContent(
                                    feedData.contents!,
                                    feedData.mentionList!,
                                    context,
                                    kBody13RegularStyle.copyWith(color: kSecondaryColor),
                                    ref,
                                    oldMemberIdx ?? 0,
                                  ),
                                  style: style,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0.w),
                          Text(
                            "...더보기",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextBodyColor,
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: replaceMentionsWithNicknamesInContent(
                              feedData.contents!,
                              feedData.mentionList!,
                              context,
                              kBody13RegularStyle.copyWith(color: kSecondaryColor),
                              ref,
                              oldMemberIdx ?? 0,
                            ),
                            style: style,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              FeedBottomIconWidget(
                likeCount: feedData.likeCnt!,
                commentCount: feedData.commentCnt!,
                contentIdx: feedData.idx,
                isLike: feedData.likeState == 1,
                isSave: feedData.saveState == 1,
                contentType: contentType,
                oldMemberIdx: oldMemberIdx ?? 0,
              ),
              Padding(
                padding: EdgeInsets.all(12.0.h),
                child: const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
