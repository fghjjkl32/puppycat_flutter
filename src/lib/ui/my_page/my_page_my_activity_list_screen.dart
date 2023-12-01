import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_like_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_save_state_provider.dart';
import 'package:thumbor/thumbor.dart';

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
    ref.read(myLikeStateProvider.notifier).initPosts(ref.read(userInfoProvider).userModel!.idx, 1);
    ref.read(mySaveStateProvider.notifier).initPosts(ref.read(userInfoProvider).userModel!.idx, 1);
    super.initState();
  }

  void _myLikeContentsScrollListener() {
    if (myLikeContentController.position.pixels > myLikeContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (myLikeOldLength == ref.read(myLikeStateProvider).list.length) {
        ref.read(myLikeStateProvider.notifier).loadMorePost(ref.read(userInfoProvider).userModel!.idx);
      }
    }
  }

  void _mySaveContentsScrollListener() {
    if (mySaveContentController.position.pixels > mySaveContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (mySaveOldLength == ref.read(mySaveStateProvider).list.length) {
        ref.read(mySaveStateProvider.notifier).loadMorePost(ref.read(userInfoProvider).userModel!.idx);
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
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
          bottom: TabBar(
              controller: tabController,
              indicatorWeight: 2.4,
              labelColor: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 10.h,
              ),
              tabs: [
                Consumer(builder: (context, ref, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "좋아요",
                        style: kBody14BoldStyle,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        "${ref.watch(myLikeStateProvider).totalCount}",
                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                      ),
                    ],
                  );
                }),
                Consumer(builder: (context, ref, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "저장",
                        style: kBody14BoldStyle,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        "${ref.watch(mySaveStateProvider).totalCount}",
                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                      ),
                    ],
                  );
                }),
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
                color: kNeutralColor100,
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
                        '피드가 없습니다.\n좋아요한 피드가 여기에 표시됩니다.',
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return ref.read(myLikeStateProvider.notifier).refresh(
                        ref.read(userInfoProvider).userModel!.idx,
                      );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
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
                            'memberIdx': '${ref.read(userInfoProvider).userModel!.idx}',
                            'contentIdx': '${lists[index].idx}',
                            'contentType': 'myLikeContent',
                          };
                          await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('myLikeContent', lists[index].idx).then((value) {
                            if (value == null) {
                              return;
                            }
                            // context.push("/home/myPage/detail/null/좋아요한 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/myLikeContent");
                            context.push('/home/myPage/detail', extra: extraMap);
                          });
                        },
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${lists[index].imgUrl}").toUrl(),
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
                                color: kNeutralColor300,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            Positioned(
                              right: 4.w,
                              top: 4.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18.w,
                                height: 14.w,
                                child: Center(
                                  child: Text(
                                    "${lists[index].imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
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

        return lists.isEmpty
            ? Container(
                color: kNeutralColor100,
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
                        '피드가 없습니다.\n저장한 피드가 여기에 표시됩니다.',
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return ref.read(mySaveStateProvider.notifier).refresh(
                        ref.read(userInfoProvider).userModel!.idx,
                      );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
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
                            'memberIdx': '${ref.read(userInfoProvider).userModel!.idx}',
                            'contentIdx': '${lists[index].idx}',
                            'contentType': 'mySaveContent',
                          };
                          await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('mySaveContent', lists[index].idx).then((value) {
                            if (value == null) {
                              return;
                            }
                            // context.push("/home/myPage/detail/null/저장한 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/mySaveContent");
                            context.push('/home/myPage/detail', extra: extraMap);
                          });
                        },
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${lists[index].imgUrl}").toUrl(),
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
                                color: kNeutralColor300,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            Positioned(
                              right: 4.w,
                              top: 4.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18.w,
                                height: 14.w,
                                child: Center(
                                  child: Text(
                                    "${lists[index].imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
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
