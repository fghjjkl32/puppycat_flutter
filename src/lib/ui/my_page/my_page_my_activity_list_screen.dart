import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_like_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_save_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class MyPageMyActivityListScreen extends ConsumerStatefulWidget {
  const MyPageMyActivityListScreen({super.key});

  @override
  MyPageMyActivityListScreenState createState() => MyPageMyActivityListScreenState();
}

class MyPageMyActivityListScreenState extends ConsumerState<MyPageMyActivityListScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController myLikeContentController = ScrollController();
  ScrollController mySaveContentController = ScrollController();

  int myLikeOldLength = 0;
  int mySaveOldLength = 0;

  @override
  void initState() {
    myLikeContentController.addListener(_myLikeContentsScrollListener);
    mySaveContentController.addListener(_mySaveContentsScrollListener);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    ref.read(myLikeStateProvider.notifier).initPosts(1);
    ref.read(mySaveStateProvider.notifier).initPosts(1);
    super.initState();
  }

  void _myLikeContentsScrollListener() {
    if (myLikeContentController.position.pixels > myLikeContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (myLikeOldLength == ref.read(myLikeStateProvider).list.length) {
        ref.read(myLikeStateProvider.notifier).loadMorePost();
      }
    }
  }

  void _mySaveContentsScrollListener() {
    if (mySaveContentController.position.pixels > mySaveContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (mySaveOldLength == ref.read(mySaveStateProvider).list.length) {
        ref.read(mySaveStateProvider.notifier).loadMorePost();
      }
    }
  }

  @override
  void dispose() {
    myLikeContentController.removeListener(_myLikeContentsScrollListener);
    myLikeContentController.dispose();
    mySaveContentController.removeListener(_mySaveContentsScrollListener);
    mySaveContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "내 활동",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          bottom: TabBar(
              controller: tabController,
              indicatorWeight: 2.4,
              labelColor: kPreviousNeutralColor600,
              indicatorColor: kPreviousNeutralColor600,
              unselectedLabelColor: kPreviousNeutralColor500,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Consumer(builder: (context, ref, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "좋아요",
                          style: kBody14BoldStyle,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${ref.watch(myLikeStateProvider).totalCount}",
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
                          "저장",
                          style: kBody14BoldStyle,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${ref.watch(mySaveStateProvider).totalCount}",
                          style: kBadge10MediumStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ],
                    );
                  }),
                ),
              ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _firstTabBody(),
            _secondTabBody(),
          ],
        ),
      ),
    );
  }

  Widget _firstTabBody() {
    // if (myPageMyActivityController.searchResult.isEmpty) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Image.asset(
    //         'assets/image/feed_write/image/corgi-2 1.png',
    //         height: 68.h,
    //       ),
    //       SizedBox(
    //         height: 12.h,
    //       ),
    //       Text(
    //         "피드가 없습니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //       Text(
    //         "좋아요한 피드가 여기에 표시됩니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //     ],
    //   );
    // }
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Consumer(
      builder: (ctx, ref, child) {
        final myLikeContentState = ref.watch(myLikeStateProvider);
        final isLoadMoreError = myLikeContentState.isLoadMoreError;
        final isLoadMoreDone = myLikeContentState.isLoadMoreDone;
        final isLoading = myLikeContentState.isLoading;
        final lists = myLikeContentState.list;

        myLikeOldLength = lists.length ?? 0;

        return lists.isEmpty
            ? Container(
                color: kPreviousNeutralColor100,
                child: Center(
                  child: Column(
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
                        '아직 ‘좋아요’한 피드가 없어요.\n피드를 ‘좋아요’해 보세요.',
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return ref.read(myLikeStateProvider.notifier).refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12),
                  child: GridView.builder(
                    controller: myLikeContentController,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.same,
                      pattern: [
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                      ],
                    ),
                    itemCount: lists.length + 1,
                    itemBuilder: (context, index) {
                      if (index == lists.length) {
                        if (isLoadMoreError) {
                          return const Center(
                            child: Text('Error'),
                          );
                        }
                        if (isLoadMoreDone) {
                          return Container();
                        }
                        return Container();
                      }

                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> extraMap = {
                            'firstTitle': 'null',
                            'secondTitle': '좋아요한 피드',
                            'memberUuid': myInfo.uuid,
                            'contentIdx': '${lists[index].idx}',
                            'contentType': 'myLikeContent',
                          };
                          await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('myLikeContent', lists[index].idx).then((value) {
                            if (value == null) {
                              return;
                            }
                            // context.push("/feed/detail/null/좋아요한 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/myLikeContent");
                            context.push('/feed/detail', extra: extraMap);
                          });
                        },
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: thumborUrl(lists[index].imgUrl ?? ''),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: (index == 0)
                                      ? const BorderRadius.only(topLeft: Radius.circular(10))
                                      : index == 1
                                          ? const BorderRadius.only(topRight: Radius.circular(10))
                                          : BorderRadius.circular(0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                color: kPreviousNeutralColor300,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    "${lists[index].imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }

  Widget _secondTabBody() {
    return Consumer(
      builder: (ctx, ref, child) {
        final mySaveContentState = ref.watch(mySaveStateProvider);
        final isLoadMoreError = mySaveContentState.isLoadMoreError;
        final isLoadMoreDone = mySaveContentState.isLoadMoreDone;
        final isLoading = mySaveContentState.isLoading;
        final lists = mySaveContentState.list;

        mySaveOldLength = lists.length ?? 0;

        final myInfo = ref.read(myInfoStateProvider);

        return lists.isEmpty
            ? Container(
                color: kPreviousNeutralColor100,
                child: Center(
                  child: Column(
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
                        '아직 저장한 피드가 없어요.\n피드를 저장해 보세요.',
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return ref.read(mySaveStateProvider.notifier).refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12),
                  child: GridView.builder(
                    controller: mySaveContentController,
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.same,
                      pattern: [
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(2, 2),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                        const QuiltedGridTile(1, 1),
                      ],
                    ),
                    itemCount: lists.length + 1,
                    itemBuilder: (context, index) {
                      if (index == lists.length) {
                        if (isLoadMoreError) {
                          return const Center(
                            child: Text('Error'),
                          );
                        }
                        if (isLoadMoreDone) {
                          return Container();
                        }
                        return Container();
                      }

                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> extraMap = {
                            'firstTitle': 'null',
                            'secondTitle': '저장한 피드',
                            'memberUuid': myInfo.uuid,
                            'contentIdx': '${lists[index].idx}',
                            'contentType': 'mySaveContent',
                          };
                          await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('mySaveContent', lists[index].idx).then((value) {
                            if (value == null) {
                              return;
                            }
                            // context.push("/feed/detail/null/저장한 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/mySaveContent");
                            context.push('/feed/detail', extra: extraMap);
                          });
                        },
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: thumborUrl(lists[index].imgUrl ?? ''),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: (index == 0)
                                      ? const BorderRadius.only(topLeft: Radius.circular(10))
                                      : index == 1
                                          ? const BorderRadius.only(topRight: Radius.circular(10))
                                          : BorderRadius.circular(0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                color: kPreviousNeutralColor300,
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    "${lists[index].imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
