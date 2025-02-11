import 'package:easy_localization/easy_localization.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
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

        ref.read(feedDetailParameterProvider.notifier).state = extraMap;

        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(contentType, feedData.idx).then((value) {
          if (value == null) {
            return;
          }
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
              SizedBox(
                height: 12,
              ),
              if (index == 0 && feedType == "follow" && popularUserList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 10, bottom: 12, top: 12),
                      child: Text(
                        "피드.요즘 인기 퍼플루언서".tr(),
                        style: kTitle16BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
                  padding: const EdgeInsets.only(left: 16.0, right: 10, bottom: 16),
                  child: Text(
                    "피드.베스트 댕냥 피드".tr(),
                    style: kTitle16BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final style = kBody14RegularStyle.copyWith(color: kTextPrimary);
                    final maxWidth = constraints.maxWidth;

                    final List<InlineSpan> originalSpans = replaceMentionsWithNicknamesInContent(
                      feedData.contents!,
                      feedData.mentionList!,
                      context,
                      kBody14RegularStyle.copyWith(color: kTextTagSecondary),
                      ref,
                      oldMemberUuid,
                    );

                    final textPainter = TextPainter(
                      text: TextSpan(
                        children: originalSpans,
                        style: style,
                      ),
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: maxWidth);

                    if (textPainter.didExceedMaxLines) {
                      // "더보기" 텍스트와 함께 텍스트가 어떻게 보일지 예측하기 위해 미리 계산
                      final endingTextPainter = TextPainter(
                        text: TextSpan(text: "...더보기  ", style: style),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      )..layout();

                      List<InlineSpan> spansToShow;

                      // 끝에서 "더보기"를 포함하기 위해 필요한 길이를 계산
                      int endIndex = textPainter
                          .getPositionForOffset(
                            Offset(maxWidth - endingTextPainter.width, textPainter.height),
                          )
                          .offset;

                      spansToShow = truncateInlineSpans(originalSpans, endIndex);

                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              children: spansToShow,
                              style: style,
                            ),
                            TextSpan(
                              text: "피드.더보기".tr(),
                              style: kBody13RegularStyle.copyWith(
                                color: kPreviousTextBodyColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return RichText(
                        text: TextSpan(
                          children: replaceMentionsWithNicknamesInContent(
                            feedData.contents!,
                            feedData.mentionList!,
                            context,
                            kBody14RegularStyle.copyWith(color: kTextTagSecondary),
                            ref,
                            oldMemberUuid,
                          ),
                          style: style,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    ).throttle();
  }
}
