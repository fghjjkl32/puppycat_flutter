import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data.dart';
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

class MyPageMainState extends ConsumerState<FeedBottomIconWidget> with TickerProviderStateMixin {
  bool showLikeLottieAnimation = false;
  bool showSaveLottieAnimation = false;
  late final PagingController<int, ContentLikeUserListData> _contentLikeUserPagingController = ref.read(contentLikeUserListStateProvider);

  late final AnimationController likeController;
  late final AnimationController saveController;

  @override
  void initState() {
    likeController = AnimationController(
      vsync: this,
    );
    saveController = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    likeController.dispose();
    saveController.dispose();
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
                        if (!ref.watch(likeApiIsLoadingStateProvider)) {
                          ref.watch(feedListStateProvider.notifier).deleteLike(
                                loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                memberIdx: widget.memberIdx,
                                contentIdx: widget.contentIdx,
                                contentType: widget.contentType,
                              );
                        }
                      },
                      child: Row(
                        children: [
                          showLikeLottieAnimation
                              ? Lottie.asset(
                                  'assets/lottie/icon_like.json',
                                  controller: likeController,
                                  onLoaded: (composition) {
                                    likeController.duration = composition.duration;
                                    likeController.forward();
                                  },
                                )
                              : const Icon(
                                  Puppycat_social.icon_like_ac,
                                  color: kPrimaryColor,
                                  size: 32,
                                ),
                          InkWell(
                            onTap: () async {
                              ref.read(contentLikeUserListStateProvider.notifier).memberIdx = ref.read(userInfoProvider).userModel?.idx;
                              ref.read(contentLikeUserListStateProvider.notifier).contentsIdx = widget.contentIdx;

                              _contentLikeUserPagingController.refresh();

                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    height: 500.h,
                                    child: PagedListView<int, ContentLikeUserListData>(
                                      pagingController: _contentLikeUserPagingController,
                                      builderDelegate: PagedChildBuilderDelegate<ContentLikeUserListData>(
                                        // animateTransitions: true,
                                        noItemsFoundIndicatorBuilder: (context) {
                                          // return const Text('No Comments');
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 100.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/image/chat/empty_character_01_nopost_88_x2.png',
                                                      width: 88,
                                                      height: 88,
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      '좋아요 한 유저가 없습니다.',
                                                      textAlign: TextAlign.center,
                                                      style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        firstPageProgressIndicatorBuilder: (context) {
                                          // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        itemBuilder: (context, contentLikeUserItem, index) {
                                          return FavoriteItemWidget(
                                            profileImage: contentLikeUserItem.profileImgUrl,
                                            userName: contentLikeUserItem.nick!,
                                            content: contentLikeUserItem.intro!,
                                            isSpecialUser: contentLikeUserItem.isBadge == 1,
                                            isFollow: contentLikeUserItem.followState == 1,
                                            followerIdx: contentLikeUserItem.memberIdx!,
                                            contentsIdx: widget.contentIdx,
                                            oldMemberIdx: 0,
                                          );
                                        },
                                      ),
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
                      onTap: () async {
                        if (!ref.watch(likeApiIsLoadingStateProvider)) {
                          ref.read(userInfoProvider).userModel == null
                              ? context.pushReplacement("/loginScreen")
                              : await ref.watch(feedListStateProvider.notifier).postLike(
                                    loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                    memberIdx: widget.memberIdx,
                                    contentIdx: widget.contentIdx,
                                    contentType: widget.contentType,
                                  );

                          setState(() {
                            showLikeLottieAnimation = true;
                          });

                          likeController.forward(from: 0);
                        }
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
                              ref.read(contentLikeUserListStateProvider.notifier).memberIdx = ref.read(userInfoProvider).userModel?.idx;
                              ref.read(contentLikeUserListStateProvider.notifier).contentsIdx = widget.contentIdx;

                              _contentLikeUserPagingController.refresh();

                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    height: 500.h,
                                    child: PagedListView<int, ContentLikeUserListData>(
                                      pagingController: _contentLikeUserPagingController,
                                      builderDelegate: PagedChildBuilderDelegate<ContentLikeUserListData>(
                                        // animateTransitions: true,
                                        noItemsFoundIndicatorBuilder: (context) {
                                          // return const Text('No Comments');
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 100.0),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/image/chat/empty_character_01_nopost_88_x2.png',
                                                      width: 88,
                                                      height: 88,
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      '좋아요 한 유저가 없습니다.',
                                                      textAlign: TextAlign.center,
                                                      style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        firstPageProgressIndicatorBuilder: (context) {
                                          // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        itemBuilder: (context, contentLikeUserItem, index) {
                                          return FavoriteItemWidget(
                                            profileImage: contentLikeUserItem.profileImgUrl,
                                            userName: contentLikeUserItem.nick!,
                                            content: contentLikeUserItem.intro!,
                                            isSpecialUser: contentLikeUserItem.isBadge == 1,
                                            isFollow: contentLikeUserItem.followState == 1,
                                            followerIdx: contentLikeUserItem.memberIdx!,
                                            contentsIdx: widget.contentIdx,
                                            oldMemberIdx: 0,
                                          );
                                        },
                                      ),
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
                    if (!ref.watch(likeApiIsLoadingStateProvider)) {
                      ref.read(userInfoProvider).userModel == null
                          ? context.pushReplacement("/loginScreen")
                          : ref.watch(feedListStateProvider.notifier).deleteSave(
                                loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                memberIdx: widget.memberIdx,
                                contentIdx: widget.contentIdx,
                                contentType: widget.contentType,
                              );
                    }
                  },
                  child: showSaveLottieAnimation
                      ? Lottie.asset(
                          'assets/lottie/icon_bookmark.json',
                          controller: saveController,
                          onLoaded: (composition) {
                            saveController.duration = composition.duration;
                            saveController.forward();
                          },
                        )
                      : Lottie.asset(
                          'assets/lottie/icon_bookmark.json',
                          controller: saveController,
                          onLoaded: (composition) {
                            saveController.duration = composition.duration;
                            saveController.value = 1.0;
                          },
                        ),
                )
              : GestureDetector(
                  onTap: () async {
                    if (!ref.watch(saveApiIsLoadingStateProvider)) {
                      ref.read(userInfoProvider).userModel == null
                          ? context.pushReplacement("/loginScreen")
                          : await ref.watch(feedListStateProvider.notifier).postSave(
                                loginMemberIdx: ref.read(userInfoProvider).userModel!.idx,
                                memberIdx: widget.memberIdx,
                                contentIdx: widget.contentIdx,
                                contentType: widget.contentType,
                              );

                      setState(() {
                        showSaveLottieAnimation = true;
                      });

                      saveController.forward(from: 0);
                    }
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
