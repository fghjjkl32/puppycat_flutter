import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_comment_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

import 'widget/feed_content_detail_widget.dart';

class FeedDetailWidget extends StatelessWidget {
  final String? profileImage;
  final String? nick;
  final FeedData feedData;
  final int? memberIdx;
  final String contentType;
  const FeedDetailWidget({
    required this.profileImage,
    required this.feedData,
    required this.nick,
    required this.memberIdx,
    required this.contentType,
    Key? key,
  }) : super(key: key);

  List<InlineSpan> replaceMentionsWithNicknamesInContent(String content,
      List<FeedMentionListData> mentionList, BuildContext context) {
    List<InlineSpan> spans = [];

    String remainingContent = content;

    for (var mention in mentionList) {
      String nick = mention.nick ?? '';
      String uuid = mention.uuid ?? '';
      int memberIdx = mention.memberIdx ?? 0;

      String pattern = '[@[' + uuid + ']]';
      int startIdx = remainingContent.indexOf(pattern);

      if (startIdx != -1) {
        if (startIdx > 0) {
          spans.add(TextSpan(text: remainingContent.substring(0, startIdx)));
        }

        spans.add(WidgetSpan(
          child: GestureDetector(
            onTap: () {
              context.push(
                  "/home/myPage/followList/$memberIdx/userPage/$nick/$memberIdx");
            },
            child: Text('@' + nick,
                style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
          ),
        ));

        remainingContent =
            remainingContent.substring(startIdx + pattern.length);
      }
    }

    // Process hashtags
    String remainingContentAfterMentions = remainingContent;
    while (true) {
      RegExp exp = new RegExp(r"\[#\[(.*?)\]\]");
      var match = exp.firstMatch(remainingContentAfterMentions);

      if (match == null) break;

      String beforeHashtag =
          remainingContentAfterMentions.substring(0, match.start);
      String hashtag = match.group(1) ?? '';

      spans.add(TextSpan(text: beforeHashtag));

      spans.add(WidgetSpan(
        child: GestureDetector(
          onTap: () {
            print(hashtag);
            context.push("/home/search/$hashtag");
          },
          child: Text('#' + hashtag,
              style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
        ),
      ));

      remainingContentAfterMentions =
          remainingContentAfterMentions.substring(match.end);
    }

    // Add the remaining content after the last pattern
    spans.add(TextSpan(text: remainingContentAfterMentions));

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //feed title
        FeedTitleWidget(
          profileImage: profileImage,
          userName: nick,
          address: feedData.location ?? "",
          time: feedData.regDate!,
          isEdit: feedData.modifyState == 1,
          memberIdx: memberIdx,
          isKeep: feedData.keepState == 1,
          contentType: contentType,
          contentIdx: feedData.idx,
        ),
        //feed detail image
        FeedImageDetailWidget(
          imageList: feedData.imgList!,
        ),
        // FeedContentDetailWidget(
        //   content: replaceMentionsWithNicknamesInContent(
        //       feedData.contents!, feedData.mentionList!),
        // ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: replaceMentionsWithNicknamesInContent(
                    feedData.contents!, feedData.mentionList!, context),
                style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
              ),
            ),
          ),
        ),
        FeedBottomIconWidget(
          likeCount: feedData.likeCnt!,
          commentCount: feedData.commentCnt!,
          contentIdx: feedData.idx,
          memberIdx: memberIdx,
          isLike: feedData.likeState == 1,
          isSave: feedData.saveState == 1,
          contentType: contentType,
        ),
        feedData.commentList!.isEmpty
            ? Container()
            : FeedCommentWidget(
                profileImage: feedData.commentList![0].profileImgUrl,
                name: feedData.commentList![0].nick!,
                comment: feedData.commentList![0].contents!,
                isSpecialUser: feedData.commentList![0].isBadge! == 1,
              ),
        Padding(
          padding: EdgeInsets.all(12.0.h),
          child: const Divider(),
        ),
      ],
    );
  }
}
