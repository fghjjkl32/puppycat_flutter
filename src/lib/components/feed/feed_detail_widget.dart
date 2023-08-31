import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_comment_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';

class FeedDetailWidget extends ConsumerWidget {
  final String? profileImage;
  final String? nick;
  final FeedData feedData;
  final int? memberIdx;
  final String contentType;
  final String imgDomain;
  final int index;

  const FeedDetailWidget({
    required this.profileImage,
    required this.feedData,
    required this.nick,
    required this.memberIdx,
    required this.contentType,
    required this.imgDomain,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //feed title
        FeedTitleWidget(
          feedData: feedData,
          profileImage: profileImage,
          userName: nick,
          address: feedData.location ?? "",
          time: feedData.regDate!,
          isEdit: feedData.modifyState == 1,
          memberIdx: memberIdx,
          isKeep: feedData.keepState == 1,
          contentType: contentType,
          contentIdx: feedData.idx,
          oldMemberIdx: memberIdx!,
        ),
        //feed detail image
        FeedImageDetailWidget(
          imageList: feedData.imgList!,
          contentIdx: feedData.idx,
          contentType: contentType,
          memberIdx: memberIdx,
          isLike: feedData.likeState == 1,
          imgDomain: imgDomain,
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
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
                  memberIdx!,
                ),
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
          oldMemberIdx: memberIdx!,
        ),
        feedData.commentList!.isEmpty
            ? Container()
            : FeedCommentWidget(
                profileImage: feedData.commentList![0].profileImgUrl,
                name: feedData.commentList![0].nick!,
                comment: feedData.commentList![0].contents!,
                isSpecialUser: feedData.commentList![0].isBadge! == 1,
                mentionListData: feedData.commentList![0].mentionList ?? [],
                contentIdx: feedData.idx,
                oldMemberIdx: memberIdx!,
              ),
        Padding(
          padding: EdgeInsets.all(12.0.h),
          child: const Divider(),
        ),
        if (index != 0 && index % 4 == 0)
          FeedFollowWidget(
            popularUserListData: ref.watch(popularUserListStateProvider).list,
            oldMemberIdx: memberIdx!,
          ),
      ],
    );
  }
}
