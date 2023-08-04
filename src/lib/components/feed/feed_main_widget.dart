import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_content_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

class FeedMainWidget extends StatelessWidget {
  const FeedMainWidget(
      {required this.feedData,
      required this.contentType,
      required this.userName,
      required this.profileImage,
      required this.memberIdx,
      required this.firstTitle,
      required this.secondTitle,
      Key? key})
      : super(key: key);

  final FeedData feedData;
  final String contentType;
  final int? memberIdx;
  final String userName;
  final String profileImage;
  final String firstTitle;
  final String secondTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
            "/home/myPage/detail/$firstTitle/$secondTitle/${feedData.memberIdx}/${feedData.idx}/$contentType");
      },
      child: Column(
        children: [
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
          ),
          FeedImageMainWidget(
            imageList: feedData.imgList!,
          ),
          //feed content
          FeedContentMainWidget(
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
          Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const Divider(),
          ),
        ],
      ),
    );
  }
}
