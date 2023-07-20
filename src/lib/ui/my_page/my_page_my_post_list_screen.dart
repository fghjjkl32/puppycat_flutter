import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';

class MyPageMyPostListScreen extends ConsumerStatefulWidget {
  const MyPageMyPostListScreen({super.key});

  @override
  MyPageMyPostListScreenState createState() => MyPageMyPostListScreenState();
}

class MyPageMyPostListScreenState extends ConsumerState<MyPageMyPostListScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController myPostContentController = ScrollController();
  ScrollController myKeepContentController = ScrollController();

  int myPostOldLength = 0;
  int myKeepOldLength = 0;

  @override
  void initState() {
    myPostContentController.addListener(_myPostContentsScrollListener);
    myKeepContentController.addListener(_myKeepContentsScrollListener);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    ref
        .read(myPostStateProvider.notifier)
        .initMyPosts(ref.read(userModelProvider)!.idx, 1);
    ref
        .read(myPostStateProvider.notifier)
        .initMyKeeps(ref.read(userModelProvider)!.idx, 1);

    Future(() {
      ref.watch(myPostStateProvider.notifier).resetMyPostSelection();
      ref.watch(myPostStateProvider.notifier).resetMyKeepSelection();
    });

    super.initState();
  }

  void _myPostContentsScrollListener() {
    if (myPostContentController.position.pixels >
        myPostContentController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (myPostOldLength ==
          ref.read(myPostStateProvider).myPostState.list.length) {
        ref
            .read(myPostStateProvider.notifier)
            .loadMoreMyPost(ref.read(userModelProvider)!.idx);
      }
    }
  }

  void _myKeepContentsScrollListener() {
    if (myKeepContentController.position.pixels >
        myKeepContentController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (myKeepOldLength ==
          ref.read(myPostStateProvider).myKeepState.list.length) {
        ref
            .read(myPostStateProvider.notifier)
            .loadMoreMyKeeps(ref.read(userModelProvider)!.idx);
      }
    }
  }

  @override
  void dispose() {
    myPostContentController.removeListener(_myPostContentsScrollListener);
    myPostContentController.dispose();
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
                "내 글 관리",
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
                    Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "일상글",
                            style: kBody14BoldStyle,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            "${ref.watch(myPostStateProvider).myPostState.totalCount}",
                            style: kBadge10MediumStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      );
                    }),
                    Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "보관글",
                            style: kBody14BoldStyle,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            "${ref.watch(myPostStateProvider).myKeepState.totalCount}",
                            style: kBadge10MediumStyle.copyWith(
                                color: kTextBodyColor),
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
        ),
      ),
    );
  }

  Widget _firstTabBody() {
    final myPageMyPostController = ref.watch(myPostStateProvider.notifier);
    final myPageMyPostState = ref.watch(myPostStateProvider);
    return Consumer(
      builder: (ctx, ref, child) {
        final myPostState = ref.watch(myPostStateProvider);
        final isLoadMoreError = myPostState.myPostState.isLoadMoreError;
        final isLoadMoreDone = myPostState.myPostState.isLoadMoreDone;
        final isLoading = myPostState.myPostState.isLoading;
        final lists = myPostState.myPostState.list;

        myPostOldLength = lists.length ?? 0;

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
              child: GridView.builder(
                controller: myPostContentController,
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
                itemBuilder: (BuildContext context, int index) {
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
                      context.go("/home/myPage/myPost/myPostDetail/일상글 게시물");
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
                                '${lists[index].imageCnt}',
                                style: kBadge9RegularStyle.copyWith(
                                    color: kNeutralColor100),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => myPageMyPostController
                                    .updateMyPostNumber(index),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300) * 0.75,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: myPageMyPostState.myPostState
                                                .selectOrder[index] !=
                                            -1
                                        ? Border.all(
                                            color:
                                                kPrimaryColor.withOpacity(0.7),
                                            width: 2.w)
                                        : Border.all(
                                            color: kNeutralColor100
                                                .withOpacity(0.7),
                                            width: 2.w),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: myPageMyPostState.myPostState
                                                  .selectOrder[index] !=
                                              -1
                                          ? kPrimaryColor
                                          : kNeutralColor100,
                                    ),
                                    child: FittedBox(
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300) *
                                                0.75,
                                        reverseDuration:
                                            const Duration(milliseconds: 300) *
                                                0.75,
                                        child: myPageMyPostState.myPostState
                                                    .selectOrder[index] !=
                                                -1
                                            ? Center(
                                                child: Text(
                                                  (myPageMyPostState.myPostState
                                                          .selectOrder[index])
                                                      .toString(),
                                                  style: kBadge10MediumStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                ),
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
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      kNeutralColor100.withOpacity(0.0),
                      kNeutralColor100.withOpacity(0.7),
                      kNeutralColor100.withOpacity(1.0),
                      kNeutralColor100.withOpacity(1.0),
                      kNeutralColor100.withOpacity(1.0),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 152.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color:
                                myPageMyPostController.hasMyPostSelectedImage()
                                    ? kPrimaryLightColor
                                    : kNeutralColor400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '보관하기',
                              style: kButton14BoldStyle.copyWith(
                                color: myPageMyPostController
                                        .hasMyPostSelectedImage()
                                    ? kPrimaryColor
                                    : kTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          myPageMyPostController.hasMyPostSelectedImage()
                              ? showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.h, bottom: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "게시물을 보관하시겠어요?",
                                              style: kBody16BoldStyle.copyWith(
                                                  color: kTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "보관된 게시물은 언제든지 프로필에",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      Text(
                                        "다시 표시 가능합니다.",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "취소",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color: kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              context.pop();

                                              // final result =
                                              //     await contentManager
                                              //         .postKeepContents(
                                              //   memberIdx: ref
                                              //       .read(userModelProvider)!
                                              //       .idx,
                                              //   idxList: myPageMyPostController
                                              //       .getSelectedImageIdx(),
                                              // );

                                              final result =
                                                  await myPageMyPostController
                                                      .postKeepContents(
                                                memberIdx: ref
                                                    .read(userModelProvider)!
                                                    .idx,
                                                idxList: myPageMyPostController
                                                    .getSelectedMyPostImageIdx(),
                                              );

                                              if (result.result) {
                                                toast(
                                                  context: context,
                                                  text: '게시물 보관이 완료되었습니다.',
                                                  type: ToastType.purple,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "보관",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : null;
                        },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 152.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color:
                                myPageMyPostController.hasMyPostSelectedImage()
                                    ? kBadgeColor
                                    : kNeutralColor400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '삭제하기',
                              style: kButton14BoldStyle.copyWith(
                                color: myPageMyPostController
                                        .hasMyPostSelectedImage()
                                    ? kNeutralColor100
                                    : kTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          myPageMyPostController.hasMyPostSelectedImage()
                              ? showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.h, bottom: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "게시물을 삭제하시겠어요?",
                                              style: kBody16BoldStyle.copyWith(
                                                  color: kTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "삭제한 게시물은",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      Text(
                                        "복구할 수 없습니다.",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "취소",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color: kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              context.pop();

                                              final result =
                                                  await myPageMyPostController
                                                      .deleteContents(
                                                memberIdx: ref
                                                    .read(userModelProvider)!
                                                    .idx,
                                                idx: myPageMyPostController
                                                    .getSelectedImageIndices(
                                                        isKeepSelect: false),
                                              );

                                              if (result.result) {
                                                toast(
                                                  context: context,
                                                  text: '게시물 삭제가 완료되었습니다.',
                                                  type: ToastType.purple,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kBadgeColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "삭제",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _secondTabBody() {
    final myKeepController = ref.watch(myPostStateProvider.notifier);
    final myKeepState = ref.watch(myPostStateProvider);
    // if (imageResult.isEmpty) {
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
    //         "보관한 게시물이 여기에 표시됩니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //     ],
    //   );
    // }
    return Consumer(
      builder: (ctx, ref, child) {
        final myKeepState = ref.watch(myPostStateProvider);
        final isLoadMoreError = myKeepState.myKeepState.isLoadMoreError;
        final isLoadMoreDone = myKeepState.myKeepState.isLoadMoreDone;
        final isLoading = myKeepState.myKeepState.isLoading;
        final lists = myKeepState.myKeepState.list;

        myKeepOldLength = lists.length ?? 0;

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
              child: GridView.builder(
                controller: myKeepContentController,
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
                itemBuilder: (BuildContext context, int index) {
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
                      context.go("/home/myPage/myPost/myPostDetail/저장한 게시물");
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
                        Positioned.fill(
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () =>
                                    myKeepController.updateMyKeepNumber(index),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300) * 0.75,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: myKeepState.myKeepState
                                                .selectOrder[index] !=
                                            -1
                                        ? Border.all(
                                            color:
                                                kPrimaryColor.withOpacity(0.7),
                                            width: 2.w)
                                        : Border.all(
                                            color: kNeutralColor100
                                                .withOpacity(0.7),
                                            width: 2.w),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: myKeepState.myKeepState
                                                  .selectOrder[index] !=
                                              -1
                                          ? kPrimaryColor
                                          : kNeutralColor100,
                                    ),
                                    child: FittedBox(
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300) *
                                                0.75,
                                        reverseDuration:
                                            const Duration(milliseconds: 300) *
                                                0.75,
                                        child: myKeepState.myKeepState
                                                    .selectOrder[index] !=
                                                -1
                                            ? Center(
                                                child: Text(
                                                  (myKeepState.myKeepState
                                                          .selectOrder[index])
                                                      .toString(),
                                                  style: kBadge10MediumStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ),
                                ),
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
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      kNeutralColor100.withOpacity(0.0),
                      kNeutralColor100.withOpacity(0.7),
                      kNeutralColor100.withOpacity(1.0),
                      kNeutralColor100.withOpacity(1.0),
                      kNeutralColor100.withOpacity(1.0),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 152.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: myKeepController.hasMyKeepSelectedImage()
                                ? kPrimaryLightColor
                                : kNeutralColor400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '프로필 표시',
                              style: kButton14BoldStyle.copyWith(
                                color: myKeepController.hasMyKeepSelectedImage()
                                    ? kPrimaryColor
                                    : kTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          final result =
                              await myKeepController.deleteKeepContents(
                            memberIdx: ref.read(userModelProvider)!.idx,
                            idx: myKeepController.getSelectedImageIndices(
                                isKeepSelect: true),
                          );

                          if (result.result) {
                            toast(
                              context: context,
                              text: '프로필 표시가 완료되었습니다.',
                              type: ToastType.purple,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 152.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: myKeepController.hasMyKeepSelectedImage()
                                ? kBadgeColor
                                : kNeutralColor400,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '삭제하기',
                              style: kButton14BoldStyle.copyWith(
                                color: myKeepController.hasMyKeepSelectedImage()
                                    ? kNeutralColor100
                                    : kTextBodyColor,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          myKeepController.hasMyKeepSelectedImage()
                              ? showCustomModalBottomSheet(
                                  context: context,
                                  widget: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.h, bottom: 10.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "게시물을 삭제하시겠어요?",
                                              style: kBody16BoldStyle.copyWith(
                                                  color: kTextTitleColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "삭제한 게시물은",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      Text(
                                        "복구할 수 없습니다.",
                                        style: kBody12RegularStyle.copyWith(
                                            color: kTextBodyColor),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pop();
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kPrimaryLightColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "취소",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color: kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              context.pop();

                                              final result =
                                                  await myKeepController
                                                      .deleteContents(
                                                memberIdx: ref
                                                    .read(userModelProvider)!
                                                    .idx,
                                                idx: myKeepController
                                                    .getSelectedImageIndices(
                                                        isKeepSelect: true),
                                              );

                                              if (result.result) {
                                                toast(
                                                  context: context,
                                                  text: '게시물 삭제가 완료되었습니다.',
                                                  type: ToastType.purple,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 152.w,
                                              height: 36.h,
                                              decoration: const BoxDecoration(
                                                color: kBadgeColor,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "삭제",
                                                  style: kButton14BoldStyle
                                                      .copyWith(
                                                          color:
                                                              kNeutralColor100),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
