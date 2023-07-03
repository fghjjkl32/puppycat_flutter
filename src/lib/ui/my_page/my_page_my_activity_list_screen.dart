import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/my_page_my_activity_provider.dart';

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

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
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
    final myPageMyActivityController =
        ref.watch(myPageMyActivityProvider.notifier);
    if (myPageMyActivityController.searchResult.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/feed_write/image/corgi-2 1.png',
            height: 68.h,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            "게시물이 없습니다.",
            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
          ),
          Text(
            "좋아요한 게시물이 여기에 표시됩니다.",
            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
          ),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
      child: GridView.builder(
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
        itemCount: myPageMyActivityController.searchResult.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              context.go("/test/myPage/myActivity/myActivityDetail/좋아요한 게시물");
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: (index == 0)
                        ? const BorderRadius.only(topLeft: Radius.circular(10))
                        : index == 1
                            ? const BorderRadius.only(
                                topRight: Radius.circular(10))
                            : BorderRadius.circular(0),
                    image: DecorationImage(
                        image: NetworkImage(
                            myPageMyActivityController.searchResult[index]),
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
                        "3",
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
  }

  Widget _secondTabBody() {
    final myPageMyActivityController =
        ref.watch(myPageMyActivityProvider.notifier);
    if (myPageMyActivityController.searchResult.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/feed_write/image/corgi-2 1.png',
            height: 68.h,
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            "게시물이 없습니다.",
            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
          ),
          Text(
            "저장한 게시물이 여기에 표시됩니다.",
            style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
          ),
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0.h, left: 12.w, right: 12.w),
      child: GridView.builder(
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
        itemCount: myPageMyActivityController.searchResult.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              context.go("/test/myPage/myActivity/myActivityDetail/보관한 게시물");
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: (index == 0)
                        ? const BorderRadius.only(topLeft: Radius.circular(10))
                        : index == 1
                            ? const BorderRadius.only(
                                topRight: Radius.circular(10))
                            : BorderRadius.circular(0),
                    image: DecorationImage(
                        image: NetworkImage(
                            myPageMyActivityController.searchResult[index]),
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
                        "3",
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
  }
}
