import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/my_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/my_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/my_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/write_walk_log_screen.dart';
///산책하기 보류로 주석 처리 완료
import 'package:screenshot/screenshot.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MyPageMainScreen extends ConsumerStatefulWidget {
  const MyPageMainScreen({
    super.key,
    required this.oldMemberUuid,
  });

  final String oldMemberUuid;

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<MyPageMainScreen> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late final PagingController<int, ContentImageData> _myContentsListPagingController = ref.read(myContentsStateProvider);
  late final PagingController<int, ContentImageData> _myTagContentsListPagingController = ref.read(myTagContentsStateProvider);
  late final PagingController<int, CommentData> _commentPagingController = ref.read(commentListStateProvider);
  late final PagingController<int, ContentLikeUserListData> _contentLikeUserPagingController = ref.read(contentLikeUserListStateProvider);

  final AutoScrollController _autoScrollController = AutoScrollController();

  late TabController tabController;
  Color appBarColor = Colors.transparent;
  int userOldLength = 0;
  int tagOldLength = 0;
  int commentOldLength = 0;
  bool showLottieAnimation = false;

  int _counter = 0;
  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  late final feedListStateNotifier;
  late final firstFeedStateNotifier;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    feedListStateNotifier = ref.read(feedListStateProvider.notifier);
    firstFeedStateNotifier = ref.read(firstFeedDetailStateProvider.notifier);

    ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);
    ref.read(firstFeedDetailStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    _myContentsListPagingController.refresh();
    _myTagContentsListPagingController.refresh();

    ref.read(myInformationStateProvider.notifier).getInitUserInformation(memberUuid: ref.read(myInfoStateProvider).uuid ?? '');
    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= 128 && appBarColor != kPreviousNeutralColor100) {
      setState(() {
        appBarColor = kPreviousNeutralColor100;
      });
    } else if (scrollController.offset < 128 && appBarColor != Colors.transparent) {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> handleFocusLost() {
    feedListStateNotifier.getStateForUser(widget.oldMemberUuid);
    firstFeedStateNotifier.getStateForUser(widget.oldMemberUuid);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;

    return DefaultOnWillPopScope(
      onWillPop: handleFocusLost,
      child: Material(
        child: SafeArea(
            child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: appBarColor,
                    title: const Text('마이페이지'),
                    leading: IconButton(
                      onPressed: () {
                        ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Puppycat_social.icon_back,
                        size: 40,
                      ),
                    ),
                    forceElevated: innerBoxIsScrolled,
                    actions: [
                      PopupMenuButton(
                        padding: EdgeInsets.zero,
                        offset: const Offset(0, 42),
                        child: showLottieAnimation
                            ? Lottie.asset(
                                'assets/lottie/icon_more_header.json',
                                repeat: false,
                              )
                            : const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Puppycat_social.icon_more_header,
                                  size: 40,
                                ),
                              ),
                        onCanceled: () {
                          setState(() {
                            showLottieAnimation = false;
                          });
                        },
                        onSelected: (id) {
                          setState(() {
                            showLottieAnimation = false;
                          });
                          if (id == 'myActivity') {
                            context.push("/home/myPage/myActivity");
                          }
                          if (id == 'postsManagement') {
                            context.push("/home/myPage/myPost");
                          }
                          if (id == 'setting') {
                            context.push("/home/myPage/setting");
                          }
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        itemBuilder: (context) {
                          Future.delayed(Duration.zero, () {
                            setState(() {
                              showLottieAnimation = true;
                            });
                          });

                          final list = <PopupMenuEntry>[];
                          list.add(
                            diaryPopUpMenuItem(
                              'myActivity',
                              '내 활동',
                              const Icon(
                                Puppycat_social.icon_myactive,
                                size: 22,
                              ),
                              context,
                            ),
                          );
                          list.add(
                            const PopupMenuDivider(
                              height: 5,
                            ),
                          );
                          list.add(
                            diaryPopUpMenuItem(
                              'postsManagement',
                              '내 글 관리',
                              const Icon(
                                Puppycat_social.icon_mywrite,
                                size: 22,
                              ),
                              context,
                            ),
                          );
                          list.add(
                            const PopupMenuDivider(
                              height: 5,
                            ),
                          );
                          list.add(
                            diaryPopUpMenuItem(
                              'setting',
                              '설정',
                              const Icon(
                                Puppycat_social.icon_set_small,
                                size: 22,
                              ),
                              context,
                            ),
                          );
                          return list;
                        },
                      ),
                    ],
                    expandedHeight: 140,
                    flexibleSpace: Consumer(builder: (context, ref, _) {
                      final userInformationItemModel = ref.watch(myInformationStateProvider);

                      return _myPageSuccessProfile(userInformationItemModel);
                    })),
                const SliverPersistentHeader(
                  delegate: TabBarDelegate(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _firstTabBody(),
                _secondTabBody(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _firstTabBody() {
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          _myContentsListPagingController.refresh();
        });
      },
      child: Container(
        color: kPreviousNeutralColor100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            PagedSliverGrid<int, ContentImageData>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrapFirstPageIndicators: true,
              pagingController: _myContentsListPagingController,
              builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: kPreviousNeutralColor100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  '피드가 없어요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                newPageProgressIndicatorBuilder: (context) {
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/icon_loading.json',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 80,
                      ),
                    ],
                  );
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/icon_loading.json',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 80,
                      ),
                    ],
                  );
                },
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> extraMap = {
                          'firstTitle': '${ref.watch(myInformationStateProvider).nick}',
                          'secondTitle': '피드',
                          'memberUuid': ref.read(myInformationStateProvider).uuid ?? '',
                          'contentIdx': '${item.idx}',
                          'contentType': 'myContent',
                        };

                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('myContent', item.idx).then((value) {
                          if (value == null) {
                            return;
                          }
                          // context.push("/home/myPage/detail/${ref.watch(myInformationStateProvider).list[0].nick}/피드/${ref.read(userInfoProvider).userModel!.idx}/${item.idx}/myContent");
                          context.push('/home/myPage/detail', extra: extraMap);
                        });
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kPreviousNeutralColor300,
                                  ),
                                  imageUrl: thumborUrl(item.imgUrl ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0, right: 2),
                                    child: InkWell(
                                      onTap: () async {
                                        ref.read(contentLikeUserListStateProvider.notifier).contentsIdx = item.idx;

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
                                                                "아직 '좋아요'가 없어요.",
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
                                                      contentsIdx: item.idx,
                                                      oldMemberUuid: '',
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                      child: item.selfLike == 1
                                          ? const Icon(
                                              Puppycat_social.icon_comment_like_ac,
                                              size: 24,
                                              color: kPreviousPrimaryColor,
                                            )
                                          : const Icon(
                                              Puppycat_social.icon_comment_like_de,
                                              size: 24,
                                              color: kPreviousNeutralColor100,
                                            ),
                                    ),
                                  ),
                                  Text(
                                    '${item.likeCnt}',
                                    style: kBadge10MediumStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0, right: 2),
                                    child: Builder(builder: (context) {
                                      return InkWell(
                                        onTap: () async {
                                          ref.read(commentListStateProvider.notifier).getComments(item.idx);

                                          // ignore: use_build_context_synchronously
                                          showCustomModalBottomSheet(
                                            context: context,
                                            widget: Consumer(builder: (context, ref, child) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                },
                                                child: SizedBox(
                                                  height: 500,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: PagedListView<int, CommentData>(
                                                          pagingController: _commentPagingController,
                                                          builderDelegate: PagedChildBuilderDelegate<CommentData>(
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
                                                                          '아직 댓글이 없어요.\n피드에 댓글을 남겨 보세요.',
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
                                                            itemBuilder: (context, item, index) {
                                                              return AutoScrollTag(
                                                                key: UniqueKey(),
                                                                controller: _autoScrollController,
                                                                index: index,
                                                                child: CommentDetailItemWidget(
                                                                  key: UniqueKey(),
                                                                  parentIdx: item.parentIdx,
                                                                  commentIdx: item.idx,
                                                                  profileImage: item.profileImgUrl ?? 'assets/image/feed/image/sample_image1.png',
                                                                  name: item.nick,
                                                                  comment: item.contents,
                                                                  isSpecialUser: item.isBadge == 1,
                                                                  time: DateTime.parse(item.regDate),
                                                                  isReply: item.isReply,
                                                                  likeCount: item.commentLikeCnt ?? 0,
                                                                  // replies: item.childCommentData,
                                                                  contentIdx: item.contentsIdx,
                                                                  isLike: item.likeState == 1,
                                                                  memberUuid: item.memberUuid,
                                                                  mentionListData: item.mentionList ?? [],
                                                                  oldMemberUuid: widget.oldMemberUuid,
                                                                  isLastDisPlayChild: item.isLastDisPlayChild,
                                                                  // remainChildCount: item.remainChildCount,
                                                                  onMoreChildComment: (page) {
                                                                    print('load more child comment');
                                                                    ref.read(commentListStateProvider.notifier).getChildComments(
                                                                          item.contentsIdx,
                                                                          item.parentIdx,
                                                                          item.idx,
                                                                          page,
                                                                          true,
                                                                        );
                                                                  },
                                                                  pageNumber: item.pageNumber,
                                                                  isDisplayPreviousMore: item.isDisplayPreviousMore,
                                                                  onPrevMoreChildComment: (page) {
                                                                    print('load prev more child comment');
                                                                    ref.read(commentListStateProvider.notifier).getChildComments(
                                                                          item.contentsIdx,
                                                                          item.parentIdx,
                                                                          item.idx,
                                                                          page,
                                                                          false,
                                                                        );
                                                                  },
                                                                  onTapRemoveButton: () async {
                                                                    final result = await ref.read(commentListStateProvider.notifier).deleteContents(
                                                                          contentsIdx: item.contentsIdx,
                                                                          commentIdx: item.idx,
                                                                          parentIdx: item.parentIdx,
                                                                        );

                                                                    if (result.result) {
                                                                      context.pop();
                                                                    }
                                                                  },
                                                                  onTapEditButton: () {
                                                                    final commentHeaderState = ref.watch(commentHeaderProvider.notifier);

                                                                    // context.pop();

                                                                    commentHeaderState.addEditCommentHeader(item.contents, item.idx);

                                                                    commentHeaderState.setHasInput(true);

                                                                    ref.read(hashtagListProvider.notifier).state = getHashtagList(item.contents);
                                                                    ref.read(mentionListProvider.notifier).state = item.mentionList ?? [];

                                                                    commentHeaderState.setControllerValue(replaceMentionsWithNicknamesInContentAsString(item.contents, item.mentionList ?? []));
                                                                    context.pop();
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      CommentCustomTextField(
                                                        contentIdx: item.idx,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                        child: const Icon(
                                          Puppycat_social.icon_comment_comment,
                                          size: 24,
                                          color: kPreviousNeutralColor100,
                                        ),
                                      );
                                    }),
                                  ),
                                  Text(
                                    '${item.commentCnt}',
                                    style: kBadge10MediumStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    '${item.imageCnt}',
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTabBody() {
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          _myTagContentsListPagingController.refresh();
        });
      },
      child: Container(
        color: kPreviousNeutralColor100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            PagedSliverGrid<int, ContentImageData>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrapFirstPageIndicators: true,
              pagingController: _myTagContentsListPagingController,
              builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: kPreviousNeutralColor100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  '피드가 없어요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                newPageProgressIndicatorBuilder: (context) {
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/icon_loading.json',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 80,
                      ),
                    ],
                  );
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/icon_loading.json',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 80,
                      ),
                    ],
                  );
                },
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> extraMap = {
                          'firstTitle': ref.read(myInformationStateProvider).nick ?? 'unknown',
                          'secondTitle': '태그됨',
                          'memberUuid': ref.read(myInfoStateProvider).uuid,
                          'contentIdx': '${item.idx}',
                          'contentType': 'myTagContent',
                        };
                        await ref
                            .read(firstFeedDetailStateProvider.notifier)
                            .getFirstFeedState(
                              'myTagContent',
                              item.idx,
                            )
                            .then((value) {
                          if (value == null) {
                            return;
                          }
                          // context.push("/home/myPage/detail/${ref.watch(myInformationStateProvider).list[0].nick}/태그됨/${ref.read(userInfoProvider).userModel!.idx}/${item.idx}/myTagContent");
                          context.push('/home/myPage/detail', extra: extraMap);
                        });
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kPreviousNeutralColor300,
                                  ),
                                  imageUrl: thumborUrl(item.imgUrl ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    "${item.imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myPageSuccessProfile(UserInformationItemModel data) {
    // final myInfo = ref.read(myInfoStateProvider);

    return FlexibleSpaceBar(
      centerTitle: true,
      expandedTitleScale: 1.0,
      background: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: getProfileAvatar(data.profileImgUrl ?? "", 48, 48),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          data.isBadge == 1
                              ? Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/feed/icon/small_size/icon_special.png',
                                      height: 13,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                )
                              : Container(),
                          Flexible(
                            child: Text(
                              "${data.nick}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final restrain = await ref.read(restrainStateProvider.notifier).checkRestrainStatus(RestrainCheckType.editMyInfo);

                              if (restrain) {
                                context.push("/home/myPage/profileEdit");
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: const Icon(
                                Puppycat_social.icon_modify_small,
                                color: kPreviousNeutralColor500,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: data.intro != "",
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "${data.intro}",
                              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO
                          //Route 다시
                          context.push("/home/myPage/followList/${data.uuid}").then((value) async {
                            await ref.read(myInformationStateProvider.notifier).getInitUserInformation(memberUuid: data.uuid ?? '');
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "팔로워 ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "${data.followerCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "  ·  ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "팔로잉 ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "${data.followCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            ///NOTE
            ///2023.11.14.
            ///산책하기 보류로 주석 처리
            // InkWell(
            //   onTap: () {
            //     context.push("/home/myPage/myPetList");
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "우리집 아이들",
            //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // InkWell(
            //   onTap: () async {
            //     context.push("/home/myPage/walkLogCalendar");
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "산책 일지",
            //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // InkWell(
            //   onTap: () async {
            //     showDialog(
            //       context: context,
            //       barrierDismissible: false,
            //       builder: (BuildContext context) {
            //         return WillPopScope(
            //           onWillPop: () async => false,
            //           child: Container(
            //             alignment: Alignment.center,
            //             decoration: BoxDecoration(
            //               color: Colors.black.withOpacity(0.6),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Lottie.asset(
            //                   'assets/lottie/icon_loading.json',
            //                   fit: BoxFit.fill,
            //                   width: 80,
            //                   height: 80,
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //
            //     final screenShotImage = await screenshotController.captureFromWidget(
            //       Container(
            //         padding: const EdgeInsets.all(30.0),
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.blueAccent, width: 5.0),
            //           color: Colors.redAccent,
            //         ),
            //         child: Text("This is an invisible widget"),
            //       ),
            //     );
            //
            //     final tempDir = await getTemporaryDirectory();
            //     File firstImageFile = await File('${tempDir.path}/image.png').create();
            //     firstImageFile.writeAsBytesSync(screenShotImage);
            //     ref.read(walkPathImgStateProvider.notifier).state = firstImageFile;
            //
            //     if (mounted) {
            //       context.pop();
            //
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => WriteWalkLogScreen(
            //               // walkPathImageFile: firstImageFile,
            //               // walkUuid: "walkkoae25df7867d24855aad17ec97ed4acad1698407055",
            //               ),
            //         ),
            //       );
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "산책 일지 생성",
            //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 20,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            ///산책하기 보류로 주석 처리 완료
          ],
        ),
      ),
    );
  }
}

PopupMenuItem diaryPopUpMenuItem(
  String title,
  String value,
  Widget icon,
  BuildContext context,
) {
  return PopupMenuItem(
    value: title,
    child: Center(
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            value,
            style: kButton12BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
          ),
        ],
      ),
    ),
  );
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final double tabBarHeight;

  const TabBarDelegate({this.tabBarHeight = 48});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: tabBarHeight,
      decoration: shrinkOffset == 0
          ? const BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, -6),
                  blurRadius: 10.0,
                ),
              ],
            )
          : const BoxDecoration(
              color: Colors.white,
            ),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
                indicatorWeight: 2.4,
                labelColor: kPreviousNeutralColor600,
                indicatorColor: kPreviousNeutralColor600,
                unselectedLabelColor: kPreviousNeutralColor500,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                tabs: [
                  Tab(
                    child: Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "일상글",
                            style: kBody14BoldStyle,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${ref.watch(myContentsFeedTotalCountProvider)}",
                            style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ],
                      );
                    }),
                  ),
                  Tab(
                    child: Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "태그됨",
                            style: kBody14BoldStyle,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "${ref.watch(myTagContentsFeedTotalCountProvider)}",
                            style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ],
                      );
                    }),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent {
    return tabBarHeight;
  }

  @override
  double get minExtent {
    return tabBarHeight;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:cached_network_image/cached_network_image.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:focus_detector/focus_detector.dart';
// import 'package:go_router/go_router.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pet_mobile_social_flutter/common/common.dart';
// import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
// import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
// import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
// import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
// import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
// import 'package:pet_mobile_social_flutter/config/constanst.dart';
// import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
// import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
// import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/my_tag_contents_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/my_contents_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/my_contents_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/user_contents_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/user_information/my_information_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
//
// ///NOTE
// ///2023.11.14.
// ///산책하기 보류로 주석 처리
// // import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
// // import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/write_walk_log_screen.dart';
// ///산책하기 보류로 주석 처리 완료
// import 'package:screenshot/screenshot.dart';
// import 'package:thumbor/thumbor.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:widget_mask/widget_mask.dart';
//
// class MyPageMainScreen extends ConsumerStatefulWidget {
//   const MyPageMainScreen({
//     super.key,
//     required this.oldMemberIdx,
//   });
//
//   final int oldMemberIdx;
//
//   @override
//   MyPageMainState createState() => MyPageMainState();
// }
//
// class MyPageMainState extends ConsumerState<MyPageMainScreen> with SingleTickerProviderStateMixin {
//   ScrollController scrollController = ScrollController();
//   ScrollController commentController = ScrollController();
//   late final PagingController<int, ContentImageData> _myContentsListPagingController = ref.read(myContentsStateProvider);
//   late final PagingController<int, ContentImageData> _myTagContentsListPagingController = ref.read(myTagContentsStateProvider);
//
//   late TabController tabController;
//   Color appBarColor = Colors.transparent;
//   int userOldLength = 0;
//   int tagOldLength = 0;
//   int commentOldLength = 0;
//   bool showLottieAnimation = false;
//
//   int _counter = 0;
//   Uint8List? _imageFile;
//
//   //Create an instance of ScreenshotController
//   ScreenshotController screenshotController = ScreenshotController();
//
//   late final feedListStateNotifier;
//   late final firstFeedStateNotifier;
//
//   @override
//   void initState() {
//     scrollController = ScrollController();
//     scrollController.addListener(_scrollListener);
//
//     feedListStateNotifier = ref.read(feedListStateProvider.notifier);
//     firstFeedStateNotifier = ref.read(firstFeedStateProvider.notifier);
//
//     ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);
//     ref.read(firstFeedStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);
//
//     commentController.addListener(_commentScrollListener);
//
//     tabController = TabController(
//       initialIndex: 0,
//       length: 2,
//       vsync: this,
//     );
//
//     _myContentsListPagingController.refresh();
//     _myTagContentsListPagingController.refresh();
//
//     ref.read(myInformationStateProvider.notifier).getInitUserInformation(ref.read(userInfoProvider).userModel!.idx);
//     super.initState();
//   }
//
//   void _scrollListener() {
//     if (scrollController.offset >= 128.h && appBarColor != kNeutralColor100) {
//       setState(() {
//         appBarColor = kNeutralColor100;
//       });
//     } else if (scrollController.offset < 128.h && appBarColor != Colors.transparent) {
//       setState(() {
//         appBarColor = Colors.transparent;
//       });
//     }
//   }
//
//   void _commentScrollListener() {
//     if (commentController.position.extentAfter < 200) {
//       if (commentOldLength == ref.read(commentStateProvider).list.length) {
//         ref.read(commentStateProvider.notifier).loadMoreComment(ref.watch(commentStateProvider).list[0].contentsIdx, ref.read(userInfoProvider).userModel?.idx);
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     scrollController.removeListener(_scrollListener);
//     scrollController.dispose();
//     commentController.removeListener(_commentScrollListener);
//     commentController.dispose();
//     super.dispose();
//   }
//
//   Future<bool> handleFocusLost() {
//     feedListStateNotifier.getStateForUser(widget.oldMemberIdx ?? 0);
//     firstFeedStateNotifier.getStateForUser(widget.oldMemberIdx ?? 0);
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultOnWillPopScope(
//       onWillPop: handleFocusLost,
//       child: Material(
//         child: SafeArea(
//             child: DefaultTabController(
//           length: 2,
//           child: NestedScrollView(
//             controller: scrollController,
//             physics: const ClampingScrollPhysics(),
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverAppBar(
//                     pinned: true,
//                     floating: false,
//                     backgroundColor: appBarColor,
//                     title: const Text('마이페이지'),
//                     leading: IconButton(
//                       onPressed: () {
//                         ref.read(firstFeedStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
//                         ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(
//                         Puppycat_social.icon_back,
//                         size: 40,
//                       ),
//                     ),
//                     forceElevated: innerBoxIsScrolled,
//                     actions: [
//                       PopupMenuButton(
//                         padding: EdgeInsets.zero,
//                         offset: Offset(0, 42),
//                         child: showLottieAnimation
//                             ? Lottie.asset(
//                                 'assets/lottie/icon_more_header.json',
//                                 repeat: false,
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: const Icon(
//                                   Puppycat_social.icon_more_header,
//                                   size: 40,
//                                 ),
//                               ),
//                         onCanceled: () {
//                           setState(() {
//                             showLottieAnimation = false;
//                           });
//                         },
//                         onSelected: (id) {
//                           setState(() {
//                             showLottieAnimation = false;
//                           });
//                           if (id == 'myActivity') {
//                             context.go("/home/myPage/myActivity");
//                           }
//                           if (id == 'postsManagement') {
//                             context.go("/home/myPage/myPost");
//                           }
//                           if (id == 'setting') {
//                             context.go("/home/myPage/setting");
//                           }
//                         },
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(16.0),
//                             bottomRight: Radius.circular(16.0),
//                             topLeft: Radius.circular(16.0),
//                             topRight: Radius.circular(16.0),
//                           ),
//                         ),
//                         itemBuilder: (context) {
//                           Future.delayed(Duration.zero, () {
//                             setState(() {
//                               showLottieAnimation = true;
//                             });
//                           });
//
//                           final list = <PopupMenuEntry>[];
//                           list.add(
//                             diaryPopUpMenuItem(
//                               'myActivity',
//                               '내 활동',
//                               const Icon(
//                                 Puppycat_social.icon_myactive,
//                                 size: 22,
//                               ),
//                               context,
//                             ),
//                           );
//                           list.add(
//                             const PopupMenuDivider(
//                               height: 5,
//                             ),
//                           );
//                           list.add(
//                             diaryPopUpMenuItem(
//                               'postsManagement',
//                               '내 글 관리',
//                               const Icon(
//                                 Puppycat_social.icon_mywrite,
//                                 size: 22,
//                               ),
//                               context,
//                             ),
//                           );
//                           list.add(
//                             const PopupMenuDivider(
//                               height: 5,
//                             ),
//                           );
//                           list.add(
//                             diaryPopUpMenuItem(
//                               'setting',
//                               '설정',
//                               const Icon(
//                                 Puppycat_social.icon_set_small,
//                                 size: 22,
//                               ),
//                               context,
//                             ),
//                           );
//                           return list;
//                         },
//                       ),
//                     ],
//                     expandedHeight: 200.h,
//                     flexibleSpace: Consumer(builder: (context, ref, _) {
//                       final userInformationState = ref.watch(myInformationStateProvider);
//                       final lists = userInformationState.list;
//
//                       return lists.isEmpty ? Container() : _myPageSuccessProfile(lists[0]);
//                     })),
//                 SliverPersistentHeader(
//                   delegate: TabBarDelegate(),
//                   pinned: true,
//                 ),
//               ];
//             },
//             body: TabBarView(
//               children: [
//                 _firstTabBody(),
//                 _secondTabBody(),
//               ],
//             ),
//           ),
//         )),
//       ),
//     );
//   }
//
//   Widget _firstTabBody() {
//     return RefreshIndicator(
//       onRefresh: () {
//         return Future(() {
//           _myContentsListPagingController.refresh();
//         });
//       },
//       child: Container(
//         color: kNeutralColor100,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: <Widget>[
//             PagedSliverGrid<int, ContentImageData>(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//               ),
//               shrinkWrapFirstPageIndicators: true,
//               pagingController: _myContentsListPagingController,
//               builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
//                 noItemsFoundIndicatorBuilder: (context) {
//                   return Stack(
//                     children: [
//                       Container(
//                         height: 400,
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             color: kNeutralColor100,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/image/chat/empty_character_01_nopost_88_x2.png',
//                                   width: 88,
//                                   height: 88,
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 Text(
//                                   '피드가 없습니다.',
//                                   textAlign: TextAlign.center,
//                                   style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//                 newPageProgressIndicatorBuilder: (context) {
//                   return Column(
//                     children: [
//                       Lottie.asset(
//                         'assets/lottie/icon_loading.json',
//                         fit: BoxFit.fill,
//                         width: 80,
//                         height: 80,
//                       ),
//                     ],
//                   );
//                 },
//                 firstPageProgressIndicatorBuilder: (context) {
//                   return Column(
//                     children: [
//                       Lottie.asset(
//                         'assets/lottie/icon_loading.json',
//                         fit: BoxFit.fill,
//                         width: 80,
//                         height: 80,
//                       ),
//                     ],
//                   );
//                 },
//                 itemBuilder: (context, item, itemBuilderIndex) {
//                   return Container(
//                     margin: const EdgeInsets.all(10.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         context.push("/home/myPage/detail/${ref.watch(myInformationStateProvider).list[0].nick}/피드/${ref.read(userInfoProvider).userModel!.idx}/${item.idx}/myContent");
//                       },
//                       child: Center(
//                         child: Stack(
//                           children: [
//                             Positioned.fill(
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: CachedNetworkImage(
//                                   placeholder: (context, url) => Container(
//                                     color: kNeutralColor300,
//                                   ),
//                                   imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.imgUrl}").toUrl(),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                     colors: [
//                                       Colors.black.withOpacity(0.5),
//                                       Colors.transparent,
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 6.0.w, right: 2.w),
//                                     child: InkWell(
//                                       onTap: () async {
//                                         await ref.read(contentLikeUserListStateProvider.notifier).initContentLikeUserList(
//                                               item.idx,
//                                               ref.read(userInfoProvider).userModel!.idx,
//                                               1,
//                                             );
//
//                                         // ignore: use_build_context_synchronously
//                                         showCustomModalBottomSheet(
//                                           context: context,
//                                           widget: Consumer(builder: (context, ref, child) {
//                                             final contentLikeUserListContentState = ref.watch(contentLikeUserListStateProvider);
//                                             final contentLikeUserList = contentLikeUserListContentState.list;
//
//                                             commentOldLength = contentLikeUserList.length ?? 0;
//                                             return SizedBox(
//                                               height: 500.h,
//                                               child: Stack(
//                                                 children: [
//                                                   Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding: EdgeInsets.only(
//                                                           top: 8.0.h,
//                                                           bottom: 10.0.h,
//                                                         ),
//                                                         child: Text(
//                                                           "좋아요",
//                                                           style: kTitle16ExtraBoldStyle.copyWith(color: kTextSubTitleColor),
//                                                         ),
//                                                       ),
//                                                       contentLikeUserList.isEmpty
//                                                           ? Expanded(
//                                                               child: Container(
//                                                                 color: kNeutralColor100,
//                                                                 child: Center(
//                                                                   child: Column(
//                                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                                     children: [
//                                                                       Image.asset(
//                                                                         'assets/image/chat/empty_character_01_nopost_88_x2.png',
//                                                                         width: 88,
//                                                                         height: 88,
//                                                                       ),
//                                                                       const SizedBox(
//                                                                         height: 12,
//                                                                       ),
//                                                                       Text(
//                                                                         '좋아요 한 유저가 없습니다.',
//                                                                         textAlign: TextAlign.center,
//                                                                         style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           : Expanded(
//                                                               child: ListView.builder(
//                                                                 controller: commentController,
//                                                                 itemCount: contentLikeUserList.length,
//                                                                 padding: EdgeInsets.only(bottom: 80.h),
//                                                                 itemBuilder: (BuildContext context, int commentIndex) {
//                                                                   return FavoriteItemWidget(
//                                                                     profileImage: contentLikeUserList[commentIndex].profileImgUrl,
//                                                                     userName: contentLikeUserList[commentIndex].nick!,
//                                                                     content: contentLikeUserList[commentIndex].intro!,
//                                                                     isSpecialUser: contentLikeUserList[commentIndex].isBadge == 1,
//                                                                     isFollow: contentLikeUserList[commentIndex].followState == 1,
//                                                                     followerIdx: contentLikeUserList[commentIndex].memberIdx!,
//                                                                     contentsIdx: item.idx,
//                                                                     oldMemberIdx: 0,
//                                                                   );
//                                                                 },
//                                                               ),
//                                                             ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           }),
//                                         );
//                                       },
//                                       child: item.selfLike == 1
//                                           ? const Icon(
//                                               Puppycat_social.icon_comment_like_ac,
//                                               size: 24,
//                                               color: kPrimaryColor,
//                                             )
//                                           : const Icon(
//                                               Puppycat_social.icon_comment_like_de,
//                                               size: 24,
//                                               color: kNeutralColor100,
//                                             ),
//                                     ),
//                                   ),
//                                   Text(
//                                     '${item.likeCnt}',
//                                     style: kBadge10MediumStyle.copyWith(color: kNeutralColor100),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 6.0.w, right: 2.w),
//                                     child: Builder(builder: (context) {
//                                       return InkWell(
//                                         onTap: () async {
//                                           await ref.read(commentStateProvider.notifier).getInitComment(item.idx, ref.read(userInfoProvider).userModel!.idx, 1);
//
//                                           // ignore: use_build_context_synchronously
//                                           showCustomModalBottomSheet(
//                                             context: context,
//                                             widget: Consumer(builder: (context, ref, child) {
//                                               final commentContentState = ref.watch(commentStateProvider);
//                                               final commentLists = commentContentState.list;
//
//                                               commentOldLength = commentLists.length ?? 0;
//                                               return SizedBox(
//                                                 height: 500.h,
//                                                 child: Stack(
//                                                   children: [
//                                                     Column(
//                                                       children: [
//                                                         Padding(
//                                                           padding: EdgeInsets.only(
//                                                             top: 8.0.h,
//                                                             bottom: 10.0.h,
//                                                           ),
//                                                           child: Text(
//                                                             "댓글",
//                                                             style: kTitle16ExtraBoldStyle.copyWith(color: kTextSubTitleColor),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                           child: ListView.builder(
//                                                             controller: commentController,
//                                                             itemCount: commentLists.length,
//                                                             padding: EdgeInsets.only(bottom: 80.h),
//                                                             itemBuilder: (BuildContext context, int index) {
//                                                               return CommentDetailItemWidget(
//                                                                 key: UniqueKey(),
//                                                                 parentIdx: commentLists[index].parentIdx,
//                                                                 commentIdx: commentLists[index].idx,
//                                                                 profileImage: commentLists[index].url ?? 'assets/image/feed/image/sample_image1.png',
//                                                                 name: commentLists[index].nick,
//                                                                 comment: commentLists[index].contents,
//                                                                 isSpecialUser: commentLists[index].isBadge == 1,
//                                                                 time: DateTime.parse(commentLists[index].regDate),
//                                                                 isReply: commentLists[index].isReply,
//                                                                 likeCount: commentLists[index].commentLikeCnt ?? 0,
//                                                                 // replies: commentLists[index].childCommentData, // TODO 댓글 위젯 수정하면서 영향이 있음
//                                                                 contentIdx: commentLists[index].contentsIdx,
//                                                                 isLike: commentLists[index].likeState == 1,
//                                                                 memberIdx: commentLists[index].memberIdx,
//                                                                 mentionListData: commentLists[index].mentionList ?? [],
//                                                                 isLastDisPlayChild: false,
//                                                                 pageNumber: commentLists[index].pageNumber,
//                                                                 isDisplayPreviousMore: false,
//                                                                 oldMemberIdx: commentLists[index].memberIdx,
//                                                               );
//                                                             },
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Positioned(
//                                                       left: 0,
//                                                       right: 0,
//                                                       bottom: 0,
//                                                       child: CommentCustomTextField(
//                                                         contentIdx: item.idx,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             }),
//                                           );
//                                         },
//                                         child: const Icon(
//                                           Puppycat_social.icon_comment_comment,
//                                           size: 24,
//                                           color: kNeutralColor100,
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                   Text(
//                                     '${item.commentCnt}',
//                                     style: kBadge10MediumStyle.copyWith(color: kNeutralColor100),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Positioned(
//                               right: 6.w,
//                               top: 6.w,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xff414348).withOpacity(0.75),
//                                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                                 ),
//                                 width: 18.w,
//                                 height: 14.w,
//                                 child: Center(
//                                   child: Text(
//                                     '${item.imageCnt}',
//                                     style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _secondTabBody() {
//     return RefreshIndicator(
//       onRefresh: () {
//         return Future(() {
//           _myTagContentsListPagingController.refresh();
//         });
//       },
//       child: Container(
//         color: kNeutralColor100,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: <Widget>[
//             PagedSliverGrid<int, ContentImageData>(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//               ),
//               shrinkWrapFirstPageIndicators: true,
//               pagingController: _myTagContentsListPagingController,
//               builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
//                 noItemsFoundIndicatorBuilder: (context) {
//                   return Stack(
//                     children: [
//                       Container(
//                         height: 400,
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             color: kNeutralColor100,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/image/chat/empty_character_01_nopost_88_x2.png',
//                                   width: 88,
//                                   height: 88,
//                                 ),
//                                 const SizedBox(
//                                   height: 12,
//                                 ),
//                                 Text(
//                                   '피드가 없습니다.',
//                                   textAlign: TextAlign.center,
//                                   style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//                 newPageProgressIndicatorBuilder: (context) {
//                   return Column(
//                     children: [
//                       Lottie.asset(
//                         'assets/lottie/icon_loading.json',
//                         fit: BoxFit.fill,
//                         width: 80,
//                         height: 80,
//                       ),
//                     ],
//                   );
//                 },
//                 firstPageProgressIndicatorBuilder: (context) {
//                   return Column(
//                     children: [
//                       Lottie.asset(
//                         'assets/lottie/icon_loading.json',
//                         fit: BoxFit.fill,
//                         width: 80,
//                         height: 80,
//                       ),
//                     ],
//                   );
//                 },
//                 itemBuilder: (context, item, itemBuilderIndex) {
//                   return Container(
//                     margin: const EdgeInsets.all(10.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         context.push("/home/myPage/detail/${ref.watch(myInformationStateProvider).list[0].nick}/태그됨/${ref.read(userInfoProvider).userModel!.idx}/${item.idx}/myTagContent");
//                       },
//                       child: Center(
//                         child: Stack(
//                           children: [
//                             Positioned.fill(
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: CachedNetworkImage(
//                                   placeholder: (context, url) => Container(
//                                     color: kNeutralColor300,
//                                   ),
//                                   imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.imgUrl}").toUrl(),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               right: 6.w,
//                               top: 6.w,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xff414348).withOpacity(0.75),
//                                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                                 ),
//                                 width: 18.w,
//                                 height: 14.w,
//                                 child: Center(
//                                   child: Text(
//                                     "${item.imageCnt}",
//                                     style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _myPageSuccessProfile(UserInformationItemModel data) {
//     return FlexibleSpaceBar(
//       centerTitle: true,
//       expandedTitleScale: 1.0,
//       background: Padding(
//         padding: const EdgeInsets.only(top: kToolbarHeight),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                   child: getProfileAvatar(data.profileImgUrl! ?? "", 48.w, 48.h),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         data.isBadge == 1
//                             ? Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/image/feed/icon/small_size/icon_special.png',
//                                     height: 13.h,
//                                   ),
//                                   SizedBox(
//                                     width: 4.w,
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         Text(
//                           "${data.nick}",
//                           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             context.go("/home/myPage/profileEdit");
//                           },
//                           child: const Padding(
//                             padding: EdgeInsets.all(5.0),
//                             child: const Icon(
//                               Puppycat_social.icon_modify_small,
//                               color: kNeutralColor500,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Visibility(
//                       visible: data.intro != "",
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 3,
//                           ),
//                           Text(
//                             "${data.intro}",
//                             style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         context.go("/home/myPage/followList/${ref.read(userInfoProvider).userModel!.idx}");
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 8.0.h),
//                         child: Row(
//                           children: [
//                             Text(
//                               "팔로워 ",
//                               style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
//                             ),
//                             Text(
//                               "${data.followerCnt}",
//                               style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//                             ),
//                             Text(
//                               "  ·  ",
//                               style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
//                             ),
//                             Text(
//                               "팔로잉 ",
//                               style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
//                             ),
//                             Text(
//                               "${data.followCnt}",
//                               style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             ///NOTE
//             ///2023.11.14.
//             ///산책하기 보류로 주석 처리
//             // InkWell(
//             //   onTap: () {
//             //     context.push("/home/myPage/myPetList");
//             //   },
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Text(
//             //           "우리집 아이들",
//             //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//             //         ),
//             //         Icon(
//             //           Icons.arrow_forward_ios,
//             //           size: 20,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//
//             // InkWell(
//             //   onTap: () async {
//             //     context.push("/home/myPage/walkLogCalendar");
//             //   },
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Text(
//             //           "산책 일지",
//             //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//             //         ),
//             //         Icon(
//             //           Icons.arrow_forward_ios,
//             //           size: 20,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//
//             // InkWell(
//             //   onTap: () async {
//             //     showDialog(
//             //       context: context,
//             //       barrierDismissible: false,
//             //       builder: (BuildContext context) {
//             //         return WillPopScope(
//             //           onWillPop: () async => false,
//             //           child: Container(
//             //             alignment: Alignment.center,
//             //             decoration: BoxDecoration(
//             //               color: Colors.black.withOpacity(0.6),
//             //             ),
//             //             child: Column(
//             //               crossAxisAlignment: CrossAxisAlignment.center,
//             //               mainAxisAlignment: MainAxisAlignment.center,
//             //               children: [
//             //                 Lottie.asset(
//             //                   'assets/lottie/icon_loading.json',
//             //                   fit: BoxFit.fill,
//             //                   width: 80,
//             //                   height: 80,
//             //                 ),
//             //               ],
//             //             ),
//             //           ),
//             //         );
//             //       },
//             //     );
//             //
//             //     final screenShotImage = await screenshotController.captureFromWidget(
//             //       Container(
//             //         padding: const EdgeInsets.all(30.0),
//             //         decoration: BoxDecoration(
//             //           border: Border.all(color: Colors.blueAccent, width: 5.0),
//             //           color: Colors.redAccent,
//             //         ),
//             //         child: Text("This is an invisible widget"),
//             //       ),
//             //     );
//             //
//             //     final tempDir = await getTemporaryDirectory();
//             //     File firstImageFile = await File('${tempDir.path}/image.png').create();
//             //     firstImageFile.writeAsBytesSync(screenShotImage);
//             //     ref.read(walkPathImgStateProvider.notifier).state = firstImageFile;
//             //
//             //     if (mounted) {
//             //       context.pop();
//             //
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (context) => WriteWalkLogScreen(
//             //               // walkPathImageFile: firstImageFile,
//             //               // walkUuid: "walkkoae25df7867d24855aad17ec97ed4acad1698407055",
//             //               ),
//             //         ),
//             //       );
//             //     }
//             //   },
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
//             //     child: Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         Text(
//             //           "산책 일지 생성",
//             //           style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
//             //         ),
//             //         Icon(
//             //           Icons.arrow_forward_ios,
//             //           size: 20,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             ///산책하기 보류로 주석 처리 완료
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// PopupMenuItem diaryPopUpMenuItem(
//   String title,
//   String value,
//   Widget icon,
//   BuildContext context,
// ) {
//   return PopupMenuItem(
//     value: title,
//     child: Center(
//       child: Row(
//         children: [
//           icon,
//           SizedBox(
//             width: 10.w,
//           ),
//           Text(
//             value,
//             style: kButton12BoldStyle.copyWith(color: kTextSubTitleColor),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// class TabBarDelegate extends SliverPersistentHeaderDelegate {
//   final double tabBarHeight;
//
//   const TabBarDelegate({this.tabBarHeight = 48});
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       height: tabBarHeight,
//       decoration: shrinkOffset == 0
//           ? BoxDecoration(
//               color: Colors.white,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.4),
//                   spreadRadius: -5,
//                   blurRadius: 7,
//                   offset: const Offset(0, -6),
//                 ),
//               ],
//             )
//           : const BoxDecoration(
//               color: Colors.white,
//             ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TabBar(
//                 indicatorWeight: 2.4,
//                 labelColor: kPrimaryColor,
//                 indicatorColor: kPrimaryColor,
//                 unselectedLabelColor: kNeutralColor500,
//                 indicatorSize: TabBarIndicatorSize.label,
//                 labelPadding: EdgeInsets.only(
//                   top: 10.h,
//                   bottom: 10.h,
//                 ),
//                 tabs: [
//                   Consumer(builder: (context, ref, child) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "일상글",
//                           style: kBody14BoldStyle,
//                         ),
//                         const SizedBox(
//                           width: 6,
//                         ),
//                         Text(
//                           "${ref.watch(myContentsFeedTotalCountProvider)}",
//                           style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                         ),
//                       ],
//                     );
//                   }),
//                   Consumer(builder: (context, ref, child) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "태그됨",
//                           style: kBody14BoldStyle,
//                         ),
//                         const SizedBox(
//                           width: 6,
//                         ),
//                         Text(
//                           "${ref.watch(myTagContentsFeedTotalCountProvider)}",
//                           style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
//                         ),
//                       ],
//                     );
//                   }),
//                 ]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent {
//     return tabBarHeight;
//   }
//
//   @override
//   double get minExtent {
//     return tabBarHeight;
//   }
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
