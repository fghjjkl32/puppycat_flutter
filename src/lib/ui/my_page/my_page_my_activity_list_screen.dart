import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_activity_state_provider.dart';

class MyPageMyActivityListScreen extends ConsumerStatefulWidget {
  const MyPageMyActivityListScreen({super.key});

  @override
  MyPageMyActivityListScreenState createState() =>
      MyPageMyActivityListScreenState();
}

class MyPageMyActivityListScreenState
    extends ConsumerState<MyPageMyActivityListScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController myActivityContentController = ScrollController();

  int myActivityOldLength = 0;

  @override
  void initState() {
    myActivityContentController.addListener(_myActivityContentsScrollListener);
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    ref
        .read(myActivityStateProvider.notifier)
        .initPosts(ref.read(userModelProvider)!.idx, 1);
    super.initState();
  }

  void _myActivityContentsScrollListener() {
    if (myActivityContentController.position.pixels >
        myActivityContentController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (myActivityOldLength ==
          ref.read(myActivityStateProvider).list.length) {
        ref
            .read(myActivityStateProvider.notifier)
            .loadMorePost(ref.read(userModelProvider)!.idx);
      }
    }
  }

  @override
  void dispose() {
    myActivityContentController
        .removeListener(_myActivityContentsScrollListener);
    myActivityContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
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
                icon: const Icon(Icons.arrow_back),
              ),
              bottom: TabBar(
                  controller: tabController,
                  indicatorWeight: 3,
                  labelColor: kPrimaryColor,
                  indicatorColor: kPrimaryColor,
                  unselectedLabelColor: kNeutralColor500,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.only(
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  tabs: [
                    Text(
                      "좋아요",
                      style: kBody14BoldStyle,
                    ),
                    Text(
                      "저장",
                      style: kBody14BoldStyle,
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
    //         "게시물이 없습니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //       Text(
    //         "좋아요한 게시물이 여기에 표시됩니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //     ],
    //   );
    // }
    return Consumer(
      builder: (ctx, ref, child) {
        final myActivityContentState = ref.watch(myActivityStateProvider);
        final isLoadMoreError = myActivityContentState.isLoadMoreError;
        final isLoadMoreDone = myActivityContentState.isLoadMoreDone;
        final isLoading = myActivityContentState.isLoading;
        final lists = myActivityContentState.list;

        myActivityOldLength = lists.length ?? 0;

        return RefreshIndicator(
          onRefresh: () {
            return ref.read(myActivityStateProvider.notifier).refresh(
                  ref.read(userModelProvider)!.idx,
                );
          },
          child: GridView.builder(
            controller: myActivityContentController,
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
                onTap: () {
                  context
                      .go("/home/myPage/myActivity/myActivityDetail/좋아요한 게시물");
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: (index == 0)
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10))
                            : index == 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(10))
                                : BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://dev-imgs.devlabs.co.kr${lists[index].imgUrl}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 4.w,
                      top: 4.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff414348).withOpacity(0.75),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        width: 18.w,
                        height: 14.w,
                        child: Center(
                          child: Text(
                            "${lists[index].imageCnt}",
                            style: kBadge9RegularStyle.copyWith(
                                color: kNeutralColor100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _secondTabBody() {
    return Consumer(
      builder: (ctx, ref, child) {
        final myActivityContentState = ref.watch(myActivityStateProvider);
        final isLoadMoreError = myActivityContentState.isLoadMoreError;
        final isLoadMoreDone = myActivityContentState.isLoadMoreDone;
        final isLoading = myActivityContentState.isLoading;
        final lists = myActivityContentState.list;

        myActivityOldLength = lists.length ?? 0;

        return RefreshIndicator(
          onRefresh: () {
            return ref.read(myActivityStateProvider.notifier).refresh(
                  ref.read(userModelProvider)!.idx,
                );
          },
          child: GridView.builder(
            controller: myActivityContentController,
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
                onTap: () {
                  context
                      .go("/home/myPage/myActivity/myActivityDetail/좋아요한 게시물");
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: (index == 0)
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10))
                            : index == 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(10))
                                : BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://dev-imgs.devlabs.co.kr${lists[index].imgUrl}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      right: 4.w,
                      top: 4.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff414348).withOpacity(0.75),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        width: 18.w,
                        height: 14.w,
                        child: Center(
                          child: Text(
                            "${lists[index].imageCnt}",
                            style: kBadge9RegularStyle.copyWith(
                                color: kNeutralColor100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
