import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';

class FeedBottomIconWidget extends ConsumerStatefulWidget {
  const FeedBottomIconWidget({
    super.key,
    required this.contentIdx,
    required this.memberIdx,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
    required this.isSave,
    required this.contentType,
    required this.oldMemberIdx,
  });

  final int contentIdx;
  final int? memberIdx;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final bool isSave;
  final String contentType;
  final int oldMemberIdx;

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<FeedBottomIconWidget> {
  @override
  void initState() {
    commentController.addListener(_commentScrollListener);

    super.initState();
  }

  void _commentScrollListener() {
    if (commentController.position.extentAfter < 200) {
      if (commentOldLength == ref.read(commentStateProvider).list.length) {
        ref.read(commentStateProvider.notifier).loadMoreComment(ref.watch(commentStateProvider).list[0].contentsIdx, ref.read(userModelProvider)!.idx);
      }
    }
  }

  int commentOldLength = 0;
  ScrollController commentController = ScrollController();

  @override
  void dispose() {
    commentController.removeListener(_commentScrollListener);
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.isLike
                  ? GestureDetector(
                      onTap: () {
                        ref.watch(feedListStateProvider.notifier).deleteLike(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: widget.memberIdx,
                              contentIdx: widget.contentIdx,
                              contentType: widget.contentType,
                            );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Puppycat_social.icon_like_ac,
                            color: kPrimaryColor,
                            size: 32,
                          ),
                          InkWell(
                            onTap: () async {
                              await ref.read(contentLikeUserListStateProvider.notifier).initContentLikeUserList(
                                    widget.contentIdx,
                                    ref.read(userModelProvider)?.idx,
                                    1,
                                  );

                              // ignore: use_build_context_synchronously
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  final contentLikeUserListContentState = ref.watch(contentLikeUserListStateProvider);
                                  final contentLikeUserList = contentLikeUserListContentState.list;

                                  commentOldLength = contentLikeUserList.length ?? 0;
                                  return SizedBox(
                                    height: 500.h,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 8.0.h,
                                                bottom: 10.0.h,
                                              ),
                                              child: Text(
                                                "좋아요",
                                                style: kTitle16ExtraBoldStyle.copyWith(color: kTextSubTitleColor),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: commentController,
                                                itemCount: contentLikeUserList.length,
                                                padding: EdgeInsets.only(bottom: 80.h),
                                                itemBuilder: (BuildContext context, int commentIndex) {
                                                  return FavoriteItemWidget(
                                                    profileImage: contentLikeUserList[commentIndex].profileImgUrl,
                                                    userName: contentLikeUserList[commentIndex].nick!,
                                                    content: contentLikeUserList[commentIndex].intro!,
                                                    isSpecialUser: contentLikeUserList[commentIndex].isBadge == 1,
                                                    isFollow: contentLikeUserList[commentIndex].followState == 1,
                                                    followerIdx: contentLikeUserList[commentIndex].memberIdx!,
                                                    contentsIdx: widget.contentIdx,
                                                    oldMemberIdx: 0,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Text(
                              '${widget.likeCount}',
                              style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref.read(userModelProvider) == null
                            ? context.pushReplacement("/loginScreen")
                            : ref.watch(feedListStateProvider.notifier).postLike(
                                  loginMemberIdx: ref.read(userModelProvider)!.idx,
                                  memberIdx: widget.memberIdx,
                                  contentIdx: widget.contentIdx,
                                  contentType: widget.contentType,
                                );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Puppycat_social.icon_like_de,
                            color: kTextBodyColor,
                            size: 32,
                          ),
                          InkWell(
                            onTap: () async {
                              await ref.read(contentLikeUserListStateProvider.notifier).initContentLikeUserList(
                                    widget.contentIdx,
                                    ref.read(userModelProvider)?.idx,
                                    1,
                                  );

                              // ignore: use_build_context_synchronously
                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  final contentLikeUserListContentState = ref.watch(contentLikeUserListStateProvider);
                                  final contentLikeUserList = contentLikeUserListContentState.list;

                                  commentOldLength = contentLikeUserList.length ?? 0;
                                  return SizedBox(
                                    height: 500.h,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 8.0.h,
                                                bottom: 10.0.h,
                                              ),
                                              child: Text(
                                                "좋아요",
                                                style: kTitle16ExtraBoldStyle.copyWith(color: kTextSubTitleColor),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: commentController,
                                                itemCount: contentLikeUserList.length,
                                                padding: EdgeInsets.only(bottom: 80.h),
                                                itemBuilder: (BuildContext context, int commentIndex) {
                                                  return FavoriteItemWidget(
                                                    profileImage: contentLikeUserList[commentIndex].profileImgUrl,
                                                    userName: contentLikeUserList[commentIndex].nick!,
                                                    content: contentLikeUserList[commentIndex].intro!,
                                                    isSpecialUser: contentLikeUserList[commentIndex].isBadge == 1,
                                                    isFollow: contentLikeUserList[commentIndex].followState == 1,
                                                    followerIdx: contentLikeUserList[commentIndex].memberIdx!,
                                                    contentsIdx: widget.contentIdx,
                                                    oldMemberIdx: 0,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              );
                            },
                            child: Text(
                              '${widget.likeCount}',
                              style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  context.push("/home/commentDetail/${widget.contentIdx}/${widget.oldMemberIdx}");
                },
                child: Row(
                  children: [
                    const Icon(
                      Puppycat_social.icon_comment,
                      color: kTextBodyColor,
                      size: 32,
                    ),
                    Text(
                      '${widget.commentCount}',
                      style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          widget.isSave
              ? GestureDetector(
                  onTap: () {
                    ref.read(userModelProvider) == null
                        ? context.pushReplacement("/loginScreen")
                        : ref.watch(feedListStateProvider.notifier).deleteSave(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: widget.memberIdx,
                              contentIdx: widget.contentIdx,
                              contentType: widget.contentType,
                            );
                  },
                  child: const Icon(
                    Puppycat_social.icon_bookmark,
                    size: 32,
                    color: kPrimaryColor,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    ref.read(userModelProvider) == null
                        ? context.pushReplacement("/loginScreen")
                        : ref.watch(feedListStateProvider.notifier).postSave(
                              loginMemberIdx: ref.read(userModelProvider)!.idx,
                              memberIdx: widget.memberIdx,
                              contentIdx: widget.contentIdx,
                              contentType: widget.contentType,
                            );
                  },
                  child: const Icon(
                    Puppycat_social.icon_bookmark,
                    size: 32,
                    color: kTextBodyColor,
                  ),
                ),
        ],
      ),
    );
  }
}
