import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/popular_user_list_state_provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_comment_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_image_detail_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/feed_title_widget.dart';

class FeedDetailWidget extends ConsumerWidget {
  final String? profileImage;
  final String? nick;
  final FeedData feedData;
  final String memberUuid;
  final String contentType;
  final bool isSpecialUser;
  final int index;

  final Function onTapHideButton;

  const FeedDetailWidget({
    required this.profileImage,
    required this.feedData,
    required this.nick,
    required this.memberUuid,
    required this.contentType,
    required this.isSpecialUser,
    required this.index,
    required this.onTapHideButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('memberUuidmemberUuid $memberUuid');
    return Column(
      children: [
        //feed title
        FeedTitleWidget(
          isSpecialUser: isSpecialUser,
          feedData: feedData,
          profileImage: profileImage,
          userName: nick,
          address: feedData.location ?? "",
          time: feedData.regDate!,
          isEdit: feedData.modifyState == 1,
          memberUuid: memberUuid,
          isKeep: feedData.keepState == 1,
          contentType: contentType,
          contentIdx: feedData.idx,
          oldMemberUuid: memberUuid,
          isDetailWidget: true,
          onTapHideButton: () async {
            onTapHideButton();
          },
        ),
        //feed detail image
        FeedImageDetailWidget(
          imageList: feedData.imgList!,
          contentIdx: feedData.idx,
          contentType: contentType,
          memberUuid: memberUuid,
          isLike: feedData.likeState == 1,
        ),
        // FeedWalkInfoWidget(
        //   walkData: feedData.walkResultList,
        // ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: replaceMentionsWithNicknamesInContent(
                  feedData.contents!,
                  feedData.mentionList!,
                  context,
                  kBody14RegularStyle.copyWith(color: kTextTagSecondary),
                  ref,
                  memberUuid,
                ),
                style: kBody14RegularStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ),
          ),
        ),
        FeedBottomIconWidget(
          likeCount: feedData.likeCnt!,
          commentCount: feedData.commentCnt!,
          contentIdx: feedData.idx,
          isLike: feedData.likeState == 1,
          isSave: feedData.saveState == 1,
          contentType: contentType,
          oldMemberUuid: memberUuid,
        ),
        feedData.comment == null
            ? Container()
            : FeedCommentWidget(
          memberUuid: feedData.comment!.memberUuid!,
          profileImage: feedData.comment!.profileImgUrl,
          name: feedData.comment!.nick!,
          comment: feedData.comment!.contents!,
          isSpecialUser: feedData.comment!.isBadge! == 1,
          mentionListData: feedData.comment!.mentionList ?? [],
          contentIdx: feedData.idx,
          oldMemberUuid: memberUuid,
        ),
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Divider(),
        ),
        if (index != 0 && index == 4)
          FeedFollowWidget(
            popularUserListData: ref
                .watch(popularUserListStateProvider)
                .list,
            oldMemberUuid: memberUuid,
          ),
      ],
    );
  }
}
