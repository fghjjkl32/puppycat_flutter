import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_post/my_post_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/my_feed_delete_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/my_feed_keep_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class MyPageMyPostListScreen extends ConsumerStatefulWidget {
  const MyPageMyPostListScreen({super.key});

  @override
  MyPageMyPostListScreenState createState() => MyPageMyPostListScreenState();
}

class MyPageMyPostListScreenState extends ConsumerState<MyPageMyPostListScreen> with SingleTickerProviderStateMixin {
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

    ref.read(myPostStateProvider.notifier).initMyPosts(1);
    ref.read(myPostStateProvider.notifier).initMyKeeps(1);

    Future(() {
      ref.watch(myPostStateProvider.notifier).resetMyPostSelection();
      ref.watch(myPostStateProvider.notifier).resetMyKeepSelection();
    });

    super.initState();
  }

  void _myPostContentsScrollListener() {
    if (myPostContentController.position.pixels > myPostContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (myPostOldLength == ref.read(myPostStateProvider).myPostState.list.length) {
        ref.read(myPostStateProvider.notifier).loadMoreMyPost();
      }
    }
  }

  void _myKeepContentsScrollListener() {
    if (myKeepContentController.position.pixels > myKeepContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (myKeepOldLength == ref.read(myPostStateProvider).myKeepState.list.length) {
        ref.read(myPostStateProvider.notifier).loadMoreMyKeeps();
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
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "회원.내 글 관리".tr(),
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
                          "회원.일상글".tr(),
                          style: kTitle16BoldStyle,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${ref.watch(myPostStateProvider).myPostState.totalCount}",
                          style: kBody13RegularStyle.copyWith(color: kTextTertiary),
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
                          "회원.보관글".tr(),
                          style: kTitle16BoldStyle,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "${ref.watch(myPostStateProvider).myKeepState.totalCount}",
                          style: kBody13RegularStyle.copyWith(color: kTextTertiary),
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
    final myPageMyPostController = ref.watch(myPostStateProvider.notifier);
    final myPageMyPostState = ref.watch(myPostStateProvider);
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Consumer(
      builder: (ctx, ref, child) {
        final myPostState = ref.watch(myPostStateProvider);
        final isLoadMoreError = myPostState.myPostState.isLoadMoreError;
        final isLoadMoreDone = myPostState.myPostState.isLoadMoreDone;
        final isLoading = myPostState.myPostState.isLoading;
        final lists = myPostState.myPostState.list;

        myPostOldLength = lists.length ?? 0;

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
                        '회원.피드가 없어요'.tr(),
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12, bottom: 70),
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
                          onTap: () async {
                            Map<String, dynamic> extraMap = {
                              'firstTitle': 'null',
                              'secondTitle': '회원.일상글 피드'.tr(),
                              'memberUuid': myInfo.uuid,
                              'contentIdx': '${lists[index].idx}',
                              'contentType': 'myDetailContent',
                            };
                            // final result = await context.push("/feed/detail/null/일상글 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/myDetailContent");
                            final result = await context.push('/feed/detail', extra: extraMap);

                            if (result == null) {
                              await ref.watch(myPostStateProvider.notifier).refreshMyKeeps();
                              await ref.watch(myPostStateProvider.notifier).refreshMyPost();

                              ref.watch(myPostStateProvider.notifier).resetMyPostSelection();
                              ref.watch(myPostStateProvider.notifier).resetMyKeepSelection();
                            }
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
                                      '${lists[index].imageCnt}',
                                      style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
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
                                      onTap: () => myPageMyPostController.updateMyPostNumber(index),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300) * 0.75,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: myPageMyPostState.myPostState.selectOrder[index] != -1
                                              ? Border.all(color: kPreviousPrimaryColor.withOpacity(0.7), width: 2)
                                              : Border.all(color: kPreviousNeutralColor100.withOpacity(0.7), width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: myPageMyPostState.myPostState.selectOrder[index] != -1 ? kPreviousPrimaryColor : kPreviousNeutralColor100,
                                          ),
                                          child: FittedBox(
                                            child: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 300) * 0.75,
                                              reverseDuration: const Duration(milliseconds: 300) * 0.75,
                                              child: myPageMyPostState.myPostState.selectOrder[index] != -1
                                                  ? Center(
                                                      child: Text(
                                                        (myPageMyPostState.myPostState.selectOrder[index]).toString(),
                                                        style: kBadge10MediumStyle.copyWith(color: kPreviousNeutralColor100),
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
                        ).throttle();
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
                            kPreviousNeutralColor100.withOpacity(0.0),
                            kPreviousNeutralColor100.withOpacity(0.7),
                            kPreviousNeutralColor100.withOpacity(1.0),
                            kPreviousNeutralColor100.withOpacity(1.0),
                            kPreviousNeutralColor100.withOpacity(1.0),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       child: Container(
                            //         width: 152,
                            //         height: 36,
                            //         decoration: BoxDecoration(
                            //           color: myPageMyPostController.hasMyPostSelectedImage() ? kPreviousPrimaryLightColor : kPreviousNeutralColor400,
                            //           borderRadius: const BorderRadius.all(
                            //             Radius.circular(8.0),
                            //           ),
                            //         ),
                            //         child: Center(
                            //           child: Text(
                            //             '보관하기',
                            //             style: kButton14BoldStyle.copyWith(
                            //               color: myPageMyPostController.hasMyPostSelectedImage() ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       onTap: () {
                            //         myPageMyPostController.hasMyPostSelectedImage()
                            //             ? myFeedKeepBottomSheet(
                            //                 context: context,
                            //                 onTap: () async {
                            //                   context.pop();
                            //
                            //                   final result = await myPageMyPostController.postKeepContents(
                            //                     idxList: myPageMyPostController.getSelectedMyPostImageIdx(),
                            //                   );
                            //
                            //                   if (result.result && mounted) {
                            //                     toast(
                            //                       context: context,
                            //                       text: '피드 보관 완료!',
                            //                       type: ToastType.purple,
                            //                     );
                            //                   }
                            //                 },
                            //               )
                            //             : null;
                            //       },
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //     GestureDetector(
                            //       child: Container(
                            //         width: 152,
                            //         height: 36,
                            //         decoration: BoxDecoration(
                            //           color: myPageMyPostController.hasMyPostSelectedImage() ? kPreviousErrorColor : kPreviousNeutralColor400,
                            //           borderRadius: const BorderRadius.all(
                            //             Radius.circular(8.0),
                            //           ),
                            //         ),
                            //         child: Center(
                            //           child: Text(
                            //             '삭제하기',
                            //             style: kButton14BoldStyle.copyWith(
                            //               color: myPageMyPostController.hasMyPostSelectedImage() ? kPreviousNeutralColor100 : kPreviousTextBodyColor,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       onTap: () {
                            //         myPageMyPostController.hasMyPostSelectedImage()
                            //             ? myFeedDeleteBottomSheet(
                            //                 context: context,
                            //                 onTap: () async {
                            //                   context.pop();
                            //
                            //                   final result = await myPageMyPostController.deleteContents(
                            //                     idx: myPageMyPostController.getSelectedImageIndices(isKeepSelect: false),
                            //                   );
                            //
                            //                   if (result.result && mounted) {
                            //                     toast(
                            //                       context: context,
                            //                       text: '피드 삭제 완료!',
                            //                       type: ToastType.purple,
                            //                     );
                            //                   }
                            //                 },
                            //               )
                            //             : null;
                            //       },
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPreviousPrimaryLightColor,
                                        foregroundColor: kPreviousPrimaryColor,
                                        textStyle: kBody16MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5),
                                        disabledBackgroundColor: kPreviousNeutralColor400,
                                        disabledForegroundColor: kPreviousTextBodyColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: myPageMyPostController.hasMyPostSelectedImage()
                                          ? () {
                                              myFeedKeepBottomSheet(
                                                context: context,
                                                onTap: () async {
                                                  context.pop();

                                                  final result = await myPageMyPostController.postKeepContents(
                                                    idxList: myPageMyPostController.getSelectedMyPostImageIdx(),
                                                  );

                                                  if (result.result && mounted) {
                                                    toast(
                                                      context: context,
                                                      text: '회원.피드 보관 완료!'.tr(),
                                                      type: ToastType.purple,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          : null,
                                      child: Text('회원.보관하기'.tr()),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPreviousErrorColor,
                                        // foregroundColor: kPreviousPrimaryColor,
                                        textStyle: kBody16MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5),
                                        disabledBackgroundColor: kPreviousNeutralColor400,
                                        disabledForegroundColor: kPreviousTextBodyColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: myPageMyPostController.hasMyPostSelectedImage()
                                          ? () {
                                              myFeedDeleteBottomSheet(
                                                context: context,
                                                onTap: () async {
                                                  context.pop();

                                                  final result = await myPageMyPostController.deleteContents(
                                                    idx: myPageMyPostController.getSelectedImageIndices(isKeepSelect: false),
                                                  );

                                                  if (result.result && mounted) {
                                                    toast(
                                                      context: context,
                                                      text: '회원.피드 삭제 완료!'.tr(),
                                                      type: ToastType.purple,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          : null,
                                      child: Text('회원.삭제하기'.tr()),
                                    ),
                                  ),
                                ),
                              ],
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
    //         "피드가 없습니다.",
    //         style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
    //       ),
    //       Text(
    //         "보관한 피드가 여기에 표시됩니다.",
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
                        '회원.보관한 피드 없음'.tr(),
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 12, right: 12, bottom: 70),
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
                          onTap: () async {
                            Map<String, dynamic> extraMap = {
                              'firstTitle': 'null',
                              'secondTitle': '회원.보관한 피드'.tr(),
                              'memberUuid': myInfo.uuid,
                              'contentIdx': '${lists[index].idx}',
                              'contentType': 'myKeepContent',
                            };
                            await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('myKeepContent', lists[index].idx).then((value) async {
                              if (value == null) {
                                return;
                              }
                              // final result = await context.push("/feed/detail/null/보관한 피드/${ref.read(userInfoProvider).userModel!.idx}/${lists[index].idx}/myKeepContent");
                              final result = await context.push('/feed/detail', extra: extraMap);

                              if (result == null) {
                                await ref.watch(myPostStateProvider.notifier).refreshMyKeeps();
                                await ref.watch(myPostStateProvider.notifier).refreshMyPost();

                                ref.watch(myPostStateProvider.notifier).resetMyPostSelection();
                                ref.watch(myPostStateProvider.notifier).resetMyKeepSelection();
                              }
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
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  child: Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => myKeepController.updateMyKeepNumber(index),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300) * 0.75,
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: myKeepState.myKeepState.selectOrder[index] != -1
                                              ? Border.all(color: kPreviousPrimaryColor.withOpacity(0.7), width: 2)
                                              : Border.all(color: kPreviousNeutralColor100.withOpacity(0.7), width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: myKeepState.myKeepState.selectOrder[index] != -1 ? kPreviousPrimaryColor : kPreviousNeutralColor100,
                                          ),
                                          child: FittedBox(
                                            child: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 300) * 0.75,
                                              reverseDuration: const Duration(milliseconds: 300) * 0.75,
                                              child: myKeepState.myKeepState.selectOrder[index] != -1
                                                  ? Center(
                                                      child: Text(
                                                        (myKeepState.myKeepState.selectOrder[index]).toString(),
                                                        style: kBadge10MediumStyle.copyWith(color: kPreviousNeutralColor100),
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
                        ).throttle();
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
                            kPreviousNeutralColor100.withOpacity(0.0),
                            kPreviousNeutralColor100.withOpacity(0.7),
                            kPreviousNeutralColor100.withOpacity(1.0),
                            kPreviousNeutralColor100.withOpacity(1.0),
                            kPreviousNeutralColor100.withOpacity(1.0),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       child: Container(
                            //         width: 152,
                            //         height: 36,
                            //         decoration: BoxDecoration(
                            //           color: myKeepController.hasMyKeepSelectedImage() ? kPreviousPrimaryLightColor : kPreviousNeutralColor400,
                            //           borderRadius: const BorderRadius.all(
                            //             Radius.circular(8.0),
                            //           ),
                            //         ),
                            //         child: Center(
                            //           child: Text(
                            //             '전체 공개',
                            //             style: kButton14BoldStyle.copyWith(
                            //               color: myKeepController.hasMyKeepSelectedImage() ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       onTap: () async {
                            //         print('aaa?');
                            //         final result = await myKeepController.deleteKeepContents(
                            //           idx: myKeepController.getSelectedImageIndices(isKeepSelect: true),
                            //         );
                            //
                            //         if (result.result) {
                            //           toast(
                            //             context: context,
                            //             text: '전체 공개가 완료되었어요.',
                            //             type: ToastType.purple,
                            //           );
                            //         }
                            //       },
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //     GestureDetector(
                            //       child: Container(
                            //         width: 152,
                            //         height: 36,
                            //         decoration: BoxDecoration(
                            //           color: myKeepController.hasMyKeepSelectedImage() ? kPreviousErrorColor : kPreviousNeutralColor400,
                            //           borderRadius: const BorderRadius.all(
                            //             Radius.circular(8.0),
                            //           ),
                            //         ),
                            //         child: Center(
                            //           child: Text(
                            //             '삭제하기',
                            //             style: kButton14BoldStyle.copyWith(
                            //               color: myKeepController.hasMyKeepSelectedImage() ? kPreviousNeutralColor100 : kPreviousTextBodyColor,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       onTap: () {
                            //         myKeepController.hasMyKeepSelectedImage()
                            //             ? myFeedDeleteBottomSheet(
                            //                 context: context,
                            //                 onTap: () async {
                            //                   context.pop();
                            //
                            //                   final result = await myKeepController.deleteContents(
                            //                     idx: myKeepController.getSelectedImageIndices(isKeepSelect: true),
                            //                   );
                            //
                            //                   if (result.result && mounted) {
                            //                     toast(
                            //                       context: context,
                            //                       text: '피드 삭제 완료!',
                            //                       type: ToastType.purple,
                            //                     );
                            //                   }
                            //                 },
                            //               )
                            //             : null;
                            //       },
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPreviousPrimaryLightColor,
                                        foregroundColor: kPreviousPrimaryColor,
                                        textStyle: kBody16MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5),
                                        disabledBackgroundColor: kPreviousNeutralColor400,
                                        disabledForegroundColor: kPreviousTextBodyColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: myKeepController.hasMyKeepSelectedImage()
                                          ? () async {
                                              final result = await myKeepController.deleteKeepContents(
                                                idx: myKeepController.getSelectedImageIndices(isKeepSelect: true),
                                              );

                                              if (result.result) {
                                                toast(
                                                  context: context,
                                                  text: '회원.전체 공개가 완료되었어요'.tr(),
                                                  type: ToastType.purple,
                                                );
                                              }
                                            }
                                          : null,
                                      child: Text(
                                        '회원.전체 공개'.tr(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kPreviousErrorColor,
                                        // foregroundColor: kPreviousPrimaryColor,
                                        textStyle: kBody16MediumStyle.copyWith(height: 1.4, letterSpacing: -0.5),
                                        disabledBackgroundColor: kPreviousNeutralColor400,
                                        disabledForegroundColor: kPreviousTextBodyColor,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: myKeepController.hasMyKeepSelectedImage()
                                          ? () {
                                              myFeedDeleteBottomSheet(
                                                context: context,
                                                onTap: () async {
                                                  context.pop();

                                                  final result = await myKeepController.deleteContents(
                                                    idx: myKeepController.getSelectedImageIndices(isKeepSelect: true),
                                                  );

                                                  if (result.result && mounted) {
                                                    toast(
                                                      context: context,
                                                      text: '회원.피드 삭제 완료!'.tr(),
                                                      type: ToastType.purple,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          : null,
                                      child: Text('회원.삭제하기'.tr()),
                                    ),
                                  ),
                                ),
                              ],
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
