import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed_search/feed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedSearchListScreen extends ConsumerStatefulWidget {
  const FeedSearchListScreen({
    required this.searchWord,
    required this.oldMemberUuid,
    super.key,
  });

  final String searchWord;
  final String oldMemberUuid;

  @override
  FeedSearchListScreenState createState() => FeedSearchListScreenState();
}

class FeedSearchListScreenState extends ConsumerState<FeedSearchListScreen> with SingleTickerProviderStateMixin {
  ScrollController searchContentController = ScrollController();

  int searchOldLength = 0;

  @override
  void initState() {
    ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);
    ref.read(firstFeedDetailStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);

    searchContentController.addListener(_searchScrollListener);

    ref.read(feedSearchStateProvider.notifier).initPosts(1, widget.searchWord);
    super.initState();
  }

  void _searchScrollListener() {
    if (searchContentController.position.pixels > searchContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (searchOldLength == ref.read(feedSearchStateProvider).list.length) {
        ref.read(feedSearchStateProvider.notifier).loadMorePost(widget.searchWord);
      }
    }
  }

  @override
  void dispose() {
    searchContentController.removeListener(_searchScrollListener);
    searchContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);

    return DefaultOnWillPopScope(
      onWillPop: () async {
        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
        ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
        return Future.value(true);
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "해시태그",
            ),
            leading: IconButton(
              onPressed: () {
                ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Puppycat_social.icon_back,
                size: 40,
              ),
            ),
          ),
          body: Consumer(builder: (ctx, ref, child) {
            final feedSearchState = ref.watch(feedSearchStateProvider);
            final isLoadMoreError = feedSearchState.isLoadMoreError;
            final isLoadMoreDone = feedSearchState.isLoadMoreDone;
            final isLoading = feedSearchState.isLoading;
            final lists = feedSearchState.list;

            searchOldLength = lists.length ?? 0;
            return searchOldLength == 0
                ? Stack(
                    children: [
                      Container(
                        height: 400,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: kNeutralColor100,
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
                                  "'${widget.searchWord}'에 대한 피드가 없어요",
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                WidgetMask(
                                  blendMode: BlendMode.srcATop,
                                  childSaveLayer: true,
                                  mask: Center(
                                    child: Image.asset(
                                      'assets/image/search/icon/icon_tag_large.png',
                                      height: 20.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/image/feed/image/squircle.svg',
                                    height: 32.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  widget.searchWord,
                                  style: kTitle14BoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                            Text(
                              feedSearchState.totalCnt,
                              style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: RefreshIndicator(
                            onRefresh: () {
                              return ref.read(feedSearchStateProvider.notifier).refresh(widget.searchWord);
                            },
                            child: GridView.builder(
                              controller: searchContentController,
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
                                      'secondTitle': widget.searchWord,
                                      'memberUuid': myInfo.uuid,
                                      'contentIdx': '${lists[index].idx}',
                                      'contentType': 'searchContent',
                                    };

                                    await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('searchContent', lists[index].idx).then((value) {
                                      if (value == null) {
                                        return;
                                      }
                                      // context.push("/home/myPage/detail/null/${widget.searchWord}/${ref.read(userInfoProvider).userModel?.idx}/${lists[index].idx}/searchContent");
                                      context.push('/home/myPage/detail', extra: extraMap);
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: (index == 0)
                                              ? const BorderRadius.only(topLeft: Radius.circular(10))
                                              : index == 1
                                                  ? const BorderRadius.only(topRight: Radius.circular(10))
                                                  : BorderRadius.circular(0),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${lists[index].imgUrl}").toUrl(),
                                              ),
                                              fit: BoxFit.cover),
                                        ),
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
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
