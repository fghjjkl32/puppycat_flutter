import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed_search/feed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_like_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_activity/my_save_state_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedSearchListScreen extends ConsumerStatefulWidget {
  const FeedSearchListScreen({
    required this.searchWord,
    required this.oldMemberIdx,
    super.key,
  });

  final String searchWord;
  final int oldMemberIdx;

  @override
  FeedSearchListScreenState createState() => FeedSearchListScreenState();
}

class FeedSearchListScreenState extends ConsumerState<FeedSearchListScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController searchContentController = ScrollController();

  int searchOldLength = 0;

  @override
  void initState() {
    searchContentController.addListener(_searchScrollListener);

    ref
        .read(feedSearchStateProvider.notifier)
        .initPosts(ref.read(userModelProvider)?.idx, 1, widget.searchWord);
    super.initState();
  }

  void _searchScrollListener() {
    if (searchContentController.position.pixels >
        searchContentController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (searchOldLength == ref.read(feedSearchStateProvider).list.length) {
        ref
            .read(feedSearchStateProvider.notifier)
            .loadMorePost(ref.read(userModelProvider)!.idx, widget.searchWord);
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
    return WillPopScope(
      onWillPop: () async {
        ref
            .read(feedDetailStateProvider.notifier)
            .getStateForUser(widget.oldMemberIdx ?? 0);
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
                "해시태그",
              ),
              leading: IconButton(
                onPressed: () {
                  ref
                      .read(feedDetailStateProvider.notifier)
                      .getStateForUser(widget.oldMemberIdx ?? 0);
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
              return Column(
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
                              style: kTitle14BoldStyle.copyWith(
                                  color: kTextSubTitleColor),
                            ),
                          ],
                        ),
                        Text(
                          feedSearchState.totalCnt,
                          style: kBody11RegularStyle.copyWith(
                              color: kTextBodyColor),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return ref
                              .read(feedSearchStateProvider.notifier)
                              .refresh(ref.read(userModelProvider)!.idx,
                                  widget.searchWord);
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
                              onTap: () {
                                context.push(
                                    "/home/myPage/detail/null/${widget.searchWord}/${ref.read(userModelProvider)!.idx}/${lists[index].idx}/searchContent");
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
                                            Thumbor(
                                                    host: thumborHostUrl,
                                                    key: thumborKey)
                                                .buildImage(
                                                    "$imgDomain${lists[index].imgUrl}")
                                                .toUrl(),
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    right: 4.w,
                                    top: 4.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff414348)
                                            .withOpacity(0.75),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
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
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
