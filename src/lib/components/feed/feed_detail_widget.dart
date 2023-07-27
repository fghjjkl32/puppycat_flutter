import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_comment_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';
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
        ),
        //feed detail image
        FeedImageDetailWidget(
          imageList: feedData.imgList!,
        ),
        //feed content
        FeedContentDetailWidget(
          content: '''${feedData.contents}''',
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
