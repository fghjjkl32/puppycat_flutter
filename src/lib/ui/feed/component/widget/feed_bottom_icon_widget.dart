import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user_list/content_like_user_list/content_like_user_list_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/favorite_item_widget.dart';

class FeedBottomIconWidget extends ConsumerStatefulWidget {
  const FeedBottomIconWidget({
    super.key,
    required this.contentIdx,
    required this.likeCount,
    required this.commentCount,
    required this.isLike,
    required this.isSave,
    required this.contentType,
    required this.oldMemberUuid,
  });

  final int contentIdx;
  final int likeCount;
  final int commentCount;
  final bool isLike;
  final bool isSave;
  final String contentType;
  final String oldMemberUuid;

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
    // final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                                  color: kPreviousPrimaryColor,
                                  size: 32,
                                ),
                          InkWell(
                            onTap: () async {
                              ref.read(contentLikeUserListStateProvider.notifier).contentsIdx = widget.contentIdx;

                              _contentLikeUserPagingController.refresh();

                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    height: 500,
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
                                                      "아직 ‘좋아요'가 없어요.",
                                                      textAlign: TextAlign.center,
                                                      style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                                            followerUuid: contentLikeUserItem.uuid!,
                                            contentsIdx: widget.contentIdx,
                                            oldMemberUuid: '',
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
                              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (!ref.watch(likeApiIsLoadingStateProvider)) {
                          isLogined == false
                              ? context.push("/home/login")
                              : await ref.watch(feedListStateProvider.notifier).postLike(
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
                            color: kPreviousTextBodyColor,
                            size: 32,
                          ),
                          InkWell(
                            onTap: () async {
                              ref.read(contentLikeUserListStateProvider.notifier).contentsIdx = widget.contentIdx;

                              _contentLikeUserPagingController.refresh();

                              showCustomModalBottomSheet(
                                context: context,
                                widget: Consumer(builder: (context, ref, child) {
                                  return SizedBox(
                                    height: 500,
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
                                                      "아직 ‘좋아요'가 없어요.",
                                                      textAlign: TextAlign.center,
                                                      style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                                            followerUuid: contentLikeUserItem.uuid!,
                                            contentsIdx: widget.contentIdx,
                                            oldMemberUuid: '',
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
                              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  context.push("/feed/comment/${widget.contentIdx}/${widget.oldMemberUuid == "" ? null : widget.oldMemberUuid}");
                },
                child: Row(
                  children: [
                    const Icon(
                      Puppycat_social.icon_comment,
                      color: kPreviousTextBodyColor,
                      size: 32,
                    ),
                    Text(
                      '${widget.commentCount}',
                      style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                      isLogined == false
                          ? context.push("/home/login")
                          : ref.watch(feedListStateProvider.notifier).deleteSave(
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
                      isLogined == false
                          ? context.push("/home/login")
                          : await ref.watch(feedListStateProvider.notifier).postSave(
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
                    color: kPreviousTextBodyColor,
                  ),
                ),
        ],
      ),
    );
  }
}
