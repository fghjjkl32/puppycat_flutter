import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/feed_best_post_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_image_main_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_title_widget.dart';

class FeedMainWidget extends ConsumerWidget {
  const FeedMainWidget(
      {required this.feedData,
      required this.contentType,
      required this.userName,
      required this.profileImage,
      required this.oldMemberUuid,
      required this.firstTitle,
      required this.secondTitle,
      // required this.imageDomain,
      required this.index,
      required this.feedType,
      required this.isSpecialUser,
      required this.onTapHideButton,
      Key? key})
      : super(key: key);

  final FeedData feedData;
  final String contentType;
  final String oldMemberUuid;
  final String userName;
  final String profileImage;
  final String firstTitle;
  final String secondTitle;

  // final String imageDomain;
  final int index;
  final String feedType;
  final bool isSpecialUser;

  final Function onTapHideButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularUserList = ref.watch(popularUserListStateProvider).list;

    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> extraMap = {
          'firstTitle': firstTitle,
          'secondTitle': secondTitle,
          'memberUuid': feedData.memberUuid,
          'contentIdx': '${feedData.idx}',
          'contentType': contentType,
        };

        print("feedData.memberIdx ${feedData.memberUuid}");
        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(contentType, feedData.idx).then((value) {
          if (value == null) {
            return;
          }
          // context.push("/feed/detail/$firstTitle/$secondTitle/${feedData.memberIdx}/${feedData.idx}/$contentType");
          context.push('/feed/detail', extra: extraMap);
        });
      },
      child: Material(
        child: Container(
          color: kPreviousNeutralColor100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (index == 0 && feedType == "follow" && popularUserList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 10, bottom: 12, top: 24),
                      child: Text(
                        "요즘 인기 퍼플루언서",
                        style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                      ),
                    ),
                    FeedFollowWidget(
                      popularUserListData: popularUserList,
                      oldMemberUuid: oldMemberUuid,
                    ),
                  ],
                ),
              if (index == 0 && feedType == "popular")
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 10),
                  child: Text(
                    "베스트 댕냥 피드",
                    style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                  ),
                ),
              if (index == 4 && feedType == "recent")
                FeedFollowWidget(
                  popularUserListData: ref.watch(popularUserListStateProvider).list,
                  oldMemberUuid: oldMemberUuid,
                ),
              if (index != 0 && index % 10 == 0 && feedType == "recent")
                FeedBestPostWidget(
                  feedData: ref.watch(popularHourFeedStateProvider).list,
                ),
              index == 0
                  ? const SizedBox(
                      height: 20,
                    )
                  : Container(),
              FeedTitleWidget(
                profileImage: profileImage,
                userName: userName,
                address: feedData.location ?? "",
                time: feedData.regDate!,
                isEdit: feedData.modifyState == 1,
                memberUuid: feedData.memberUuid!,
                isKeep: feedData.keepState == 1,
                contentIdx: feedData.idx,
                contentType: contentType,
                feedData: feedData,
                oldMemberUuid: oldMemberUuid,
                isDetailWidget: false,
                feedType: feedType,
                isSpecialUser: isSpecialUser,
                onTapHideButton: () async {
                  onTapHideButton();
                },
              ),
              FeedImageMainWidget(
                imageList: feedData.imgList!,
                // imageDomain: imageDomain,
              ),
              // FeedWalkInfoWidget(
              //   walkData: feedData.walkResultList,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final style = kBody13RegularStyle.copyWith(color: kPreviousTextTitleColor);
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
                                    kBody13RegularStyle.copyWith(color: kPreviousSecondaryColor),
                                    ref,
                                    oldMemberUuid,
                                  ),
                                  style: style,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "...더보기",
                            style: kBody13RegularStyle.copyWith(
                              color: kPreviousTextBodyColor,
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
                              kBody13RegularStyle.copyWith(color: kPreviousSecondaryColor),
                              ref,
                              oldMemberUuid,
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
                oldMemberUuid: oldMemberUuid,
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
