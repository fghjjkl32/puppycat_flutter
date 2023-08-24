import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/feed_write_show_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_best_post_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/favorite_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:thumbor/thumbor.dart';

class PuppyCatMain extends ConsumerStatefulWidget {
  const PuppyCatMain({Key? key}) : super(key: key);

  @override
  PuppyCatMainState createState() => PuppyCatMainState();
}

class PuppyCatMainState extends ConsumerState<PuppyCatMain>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  bool _showIcon = false;

  int myFeedOldLength = 0;
  int recentOldLength = 0;
  int followOldLength = 0;
  int popularWeekOldLength = 0;

  List<Widget> getTabs() {
    final loginState = ref.read(loginStateProvider);

    List<Widget> tabs = [
      Text(
        "최신",
        style: kBody16MediumStyle,
      ),
      Text(
        "산책",
        style: kBody16MediumStyle,
      ),
    ];

    if (loginState == LoginStatus.success) {
      tabs.addAll([
        Text(
          "팔로잉",
          style: kBody16MediumStyle,
        ),
        Text(
          "작성글",
          style: kBody16MediumStyle,
        ),
      ]);
    }

    return tabs;
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: getTabs().length);
    Future(() {
      final loginState = ref.watch(loginStateProvider);

      ref.read(recentFeedStateProvider.notifier).initPosts(
            loginMemberIdx: ref.read(userModelProvider)?.idx,
            initPage: 1,
          );

      if (loginState == LoginStatus.success) {
        scrollController.addListener(_myPostScrollListener);

        ref.read(myFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );

        ref.read(followFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );

        ref.read(popularWeekFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );

        ref.read(popularHourFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
            );

        ref.read(popularUserListStateProvider.notifier).getInitUserList(
              ref.read(userModelProvider)!.idx,
            );

        ref
            .read(favoriteUserListStateProvider.notifier)
            .getInitUserList(ref.read(userModelProvider)!.idx);
      }
    });
  }

  void _myPostScrollListener() {
    setState(() {
      _showIcon = scrollController.offset > 100.h;
    });

    final loginState = ref.watch(loginStateProvider);

    if (tabController.index == 0) {
      if (recentOldLength == ref.read(recentFeedStateProvider).list.length) {
        ref.read(recentFeedStateProvider.notifier).loadMorePost(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
            );
      }
    }

    if (loginState == LoginStatus.success) {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent -
              MediaQuery.of(context).size.height) {
        switch (tabController.index) {
          case 2: // Second Tab
            if (followOldLength ==
                ref.read(followFeedStateProvider).list.length) {
              ref.read(followFeedStateProvider.notifier).loadMorePost(
                    loginMemberIdx: ref.read(userModelProvider)!.idx,
                  );
            }
            if (popularWeekOldLength ==
                ref.read(popularWeekFeedStateProvider).list.length) {
              ref.read(popularWeekFeedStateProvider.notifier).loadMorePost(
                    loginMemberIdx: ref.read(userModelProvider)!.idx,
                  );
            }
            break;
          case 3: // Fourth Tab
            if (myFeedOldLength == ref.read(myFeedStateProvider).list.length) {
              ref.read(myFeedStateProvider.notifier).loadMorePost(
                    loginMemberIdx: ref.read(userModelProvider)!.idx,
                  );
            }
            break;
          default:
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_myPostScrollListener);
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;
    final loginState = ref.watch(loginStateProvider);

    return Scaffold(
      appBar: isBigDevice
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(30.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PUPPYCAT",
                      style: kTitle18BoldStyle,
                    ),
                    _buttonWidget(),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
      body: SafeArea(
        child: DefaultTabController(
          length: loginState == LoginStatus.success ? 4 : 2,
          child: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                isBigDevice
                    ? SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: true,
                        expandedHeight: 220.0,
                        centerTitle: false,
                        leading: null,
                        titleSpacing: 0,
                        backgroundColor: kNeutralColor100,
                        automaticallyImplyLeading: false,
                        title: Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _buttonWidget(),
                            ),
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.zero,
                          expandedTitleScale: 1.0,
                          centerTitle: false,
                          collapseMode: CollapseMode.pin,
                          title: _buildTabbar(innerBoxIsScrolled),
                          background: Container(
                            color: kNeutralColor100,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 16.0.h,
                                    left: 10.w,
                                  ),
                                  child: Text(
                                    "PUPPYCAT",
                                    style: kTitle18BoldStyle,
                                  ),
                                ),
                                _buildBackGround(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverAppBar(
                        pinned: true,
                        snap: false,
                        floating: true,
                        expandedHeight: 180.0,
                        centerTitle: false,
                        leading: null,
                        titleSpacing: 0,
                        backgroundColor: kNeutralColor100,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.zero,
                          expandedTitleScale: 1.0,
                          centerTitle: false,
                          collapseMode: CollapseMode.pin,
                          title: _buildTabbar(innerBoxIsScrolled),
                          background: Container(
                            color: kNeutralColor100,
                            child: Stack(
                              children: [
                                _buildBackGround(),
                              ],
                            ),
                          ),
                        ),
                      ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: [
                _firstTab(),
                if (loginState == LoginStatus.success) ...[
                  Container(
                    color: Colors.blue,
                  ),
                ],
                _thirdTab(),
                if (loginState == LoginStatus.success) ...[
                  _fourthTab(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            final theme =
                InstaAssetPicker.themeData(Theme.of(context).primaryColor);

            final ImagePicker picker = ImagePicker();

            final pickedFile =
                await picker.pickImage(source: ImageSource.camera);

            if (pickedFile != null) {
              await ImageGallerySaver.saveFile(pickedFile.path);

              // ignore: use_build_context_synchronously
              InstaAssetPicker.pickAssets(
                context,
                maxAssets: 12,
                // ignore: use_build_context_synchronously
                pickerTheme: themeData(context).copyWith(
                  canvasColor: kNeutralColor100,
                  colorScheme: theme.colorScheme.copyWith(
                    background: kNeutralColor100,
                  ),
                  appBarTheme: theme.appBarTheme.copyWith(
                    backgroundColor: kNeutralColor100,
                  ),
                ),
                onCompleted: (cropStream) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeedWriteScreen(
                        cropStream: cropStream,
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: Image.asset(
            'assets/image/header/icon/large_size/icon_camera.png',
            height: 26.h,
          ),
        ),
        GestureDetector(
          onTap: () {
            feedWriteShowBottomSheet(
              context: context,
            );
          },
          child: Image.asset(
            'assets/image/header/icon/large_size/icon_feed.png',
            height: 26.h,
          ),
        ),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          icon: Image.asset(
            'assets/image/header/icon/large_size/icon_more_h.png',
            height: 26.h,
          ),
          onSelected: (id) {
            if (id == 'notification') {
              context.go("/home/notification");
            }
            if (id == 'search') {
              context.go("/home/search");
            }
            if (id == 'message') {
              context.push('/chatMain');
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
            final list = <PopupMenuEntry>[];
            list.add(
              diaryPopUpMenuItem(
                'notification',
                '알림',
                const Icon(Icons.notifications),
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
                'search',
                '검색',
                const Icon(Icons.search),
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
                'message',
                '메시지',
                const Icon(Icons.message),
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
                const Icon(Icons.settings),
                context,
              ),
            );
            return list;
          },
        ),
        GestureDetector(
          onTap: () {
            context.go("/home/myPage");
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _showIcon ? 36.0 : 0.0,
            child: Opacity(
              opacity: _showIcon ? 1.0 : 0.0,
              child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.asset(
                    'assets/image/feed/icon/large_size/icon_taguser.png',
                    height: 22.h,
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 22.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _firstTab() {
    return RefreshIndicator(
      onRefresh: () {
        ref.read(popularWeekFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );

        return ref.read(recentFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: ref.watch(recentFeedStateProvider).list.length,
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Consumer(builder: (ctx, ref, child) {
                    final recentFeedState = ref.watch(recentFeedStateProvider);
                    final popularHourFeedState =
                        ref.watch(popularHourFeedStateProvider);
                    final popularUserState =
                        ref.watch(popularUserListStateProvider);
                    final isLoadMoreError = recentFeedState.isLoadMoreError;
                    final isLoadMoreDone = recentFeedState.isLoadMoreDone;
                    final isLoading = recentFeedState.isLoading;
                    final lists = recentFeedState.list;

                    recentOldLength = lists.length ?? 0;

                    if (index == 4) {
                      return FeedFollowWidget(
                        popularUserListData: popularUserState.list,
                      );
                    }

                    if (index != 0 && index % 10 == 0) {
                      return FeedBestPostWidget(
                        feedData: popularHourFeedState.list,
                      );
                    }

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

                    return FeedMainWidget(
                      feedData: lists[index],
                      contentType: 'userContent',
                      userName:
                          recentFeedState.list[index].memberInfoList![0].nick!,
                      profileImage: recentFeedState
                              .list[index].memberInfoList?[0].profileImgUrl! ??
                          "",
                      memberIdx: ref.read(userModelProvider)?.idx,
                      firstTitle:
                          recentFeedState.list[index].memberInfoList![0].nick!,
                      secondTitle: '게시물',
                      imageDomain: recentFeedState.imgDomain!,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
    // Padding(
    //   padding: EdgeInsets.only(top: 16.0.h),
    //   child: const FeedMainWidget(),
    // ),
    // const FeedMainWidget(),
    // const FeedMainWidget(),
    // const FeedMainWidget(),
    // const FeedBestPostWidget(),
    // const FeedMainWidget(),
    // const FeedMainWidget(),
    // const FeedMainWidget(),
    // const FeedMainWidget(),
  }

  Widget _thirdTab() {
    return RefreshIndicator(
      onRefresh: () {
        return ref.read(followFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: ref.watch(followFeedStateProvider).list.length,
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Consumer(builder: (ctx, ref, child) {
                    final followFeedState = ref.watch(followFeedStateProvider);
                    final isLoadMoreError = followFeedState.isLoadMoreError;
                    final isLoadMoreDone = followFeedState.isLoadMoreDone;
                    final isLoading = followFeedState.isLoading;
                    final lists = followFeedState.list;

                    followOldLength = lists.length ?? 0;

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

                    return FeedMainWidget(
                      feedData: lists[index],
                      contentType: 'userContent',
                      userName: followFeedState.memberInfo?[0].nick ??
                          followFeedState.list[index].memberInfoList![0].nick!,
                      profileImage:
                          followFeedState.memberInfo?[0].profileImgUrl ??
                              followFeedState.list[index].memberInfoList![0]
                                  .profileImgUrl! ??
                              "",
                      memberIdx: ref.read(userModelProvider)!.idx,
                      firstTitle: followFeedState.memberInfo?[0].nick ??
                          followFeedState.list[index].memberInfoList![0].nick!,
                      secondTitle: '게시물',
                      imageDomain: followFeedState.imgDomain!,
                    );
                  }),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: ref.watch(popularWeekFeedStateProvider).list.length,
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Consumer(builder: (ctx, ref, child) {
                    final bestFeedState =
                        ref.watch(popularWeekFeedStateProvider);
                    final popularHourFeedState =
                        ref.watch(popularHourFeedStateProvider);
                    final popularUserState =
                        ref.watch(popularUserListStateProvider);
                    final isLoadMoreError = bestFeedState.isLoadMoreError;
                    final isLoadMoreDone = bestFeedState.isLoadMoreDone;
                    final isLoading = bestFeedState.isLoading;
                    final lists = bestFeedState.list;

                    popularWeekOldLength = lists.length ?? 0;

                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0.w, right: 10.w, bottom: 12.h),
                            child: Text(
                              "인기있는 펫 집사들",
                              style: kTitle16ExtraBoldStyle.copyWith(
                                  color: kTextTitleColor),
                            ),
                          ),
                          FeedFollowWidget(
                            popularUserListData: popularUserState.list,
                          ),
                        ],
                      );
                    }

                    if (index != 0 && index % 10 == 0) {
                      return FeedBestPostWidget(
                          feedData: popularHourFeedState.list);
                    }

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

                    return Column(
                      children: [
                        index == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0.h),
                                    child: const Divider(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0.w,
                                        right: 10.w,
                                        bottom: 12.h),
                                    child: Text(
                                      "인기 게시글",
                                      style: kTitle16ExtraBoldStyle.copyWith(
                                          color: kTextTitleColor),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        FeedMainWidget(
                          feedData: lists[index],
                          contentType: 'popularWeekContent',
                          userName: bestFeedState
                              .list[index].memberInfoList![0].nick!,
                          profileImage: bestFeedState.list[index]
                                  .memberInfoList![0].profileImgUrl! ??
                              "",
                          memberIdx: ref.read(userModelProvider)!.idx,
                          firstTitle: "null",
                          secondTitle: '인기 급상승',
                          imageDomain: bestFeedState.imgDomain!,
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _fourthTab() {
    return RefreshIndicator(
      onRefresh: () {
        return ref.read(myFeedStateProvider.notifier).initPosts(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              initPage: 1,
            );
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: ref.watch(myFeedStateProvider).list.length,
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Consumer(builder: (ctx, ref, child) {
                    final myFeedState = ref.watch(myFeedStateProvider);
                    final isLoadMoreError = myFeedState.isLoadMoreError;
                    final isLoadMoreDone = myFeedState.isLoadMoreDone;
                    final isLoading = myFeedState.isLoading;
                    final lists = myFeedState.list;

                    myFeedOldLength = lists.length ?? 0;

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

                    return FeedMainWidget(
                      feedData: lists[index],
                      contentType: 'myContent',
                      userName: myFeedState.memberInfo![0].nick!,
                      profileImage:
                          myFeedState.memberInfo?[0].profileImgUrl ?? "",
                      memberIdx: ref.read(userModelProvider)!.idx,
                      firstTitle: myFeedState.memberInfo![0].nick!,
                      secondTitle: '게시물',
                      imageDomain: myFeedState.imgDomain!,
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackGround() {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;

    final loginState = ref.watch(loginStateProvider);

    return Padding(
      padding: EdgeInsets.only(
        top: isBigDevice ? 50 : 5,
      ),
      child: loginState == LoginStatus.success
          ? Consumer(builder: (context, ref, child) {
              final userListState = ref.watch(favoriteUserListStateProvider);
              final userListLists = userListState.memberList;

              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.go("/home/myPage");
                      },
                      child: Column(
                        children: [
                          buildWidgetMask(
                              ref.read(userModelProvider)!.profileImgUrl ?? "",
                              ref.read(userModelProvider)!.isBadge),
                          const SizedBox(height: 4.0),
                          Text(
                            "my",
                            style: kBody12RegularStyle.copyWith(
                                color: kTextTitleColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userListLists.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              ref.read(userModelProvider)!.idx ==
                                      userListLists[index].memberIdx
                                  ? context.push("/home/myPage")
                                  : context.push(
                                      "/home/myPage/followList/${userListLists[index].memberIdx}/userPage/${userListLists[index].nick}/${userListLists[index].memberIdx}");
                            },
                            child: Column(
                              children: [
                                buildWidgetMask(
                                    userListLists[index].profileImgUrl,
                                    userListLists[index].isBadge),
                                const SizedBox(height: 4.0),
                                Text(
                                  userListLists[index].nick!,
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextTitleColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            })
          : GestureDetector(
              onTap: () {
                context.pushReplacement("/loginScreen");
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Image.asset(
                    'assets/image/feed_write/image/corgi-2 1.png',
                    height: 36.h,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: Text(
                      "로그인 하고 나랑 딱! 맞는 친구 보기",
                      style:
                          kBody13RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildWidgetMask(String? profileImgUrl, int? isBadge) {
    return profileImgUrl == null || profileImgUrl == ""
        ? Stack(
            children: [
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.asset(
                    'assets/image/feed/icon/large_size/icon_taguser.png',
                    height: 46.h,
                    fit: BoxFit.fill,
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/image/feed/image/squircle.svg',
                  height: 46.h,
                  fit: BoxFit.fill,
                ),
              ),
              isBadge == 1
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Image.asset(
                        'assets/image/feed/icon/small_size/icon_special.png',
                        height: 13.h,
                      ),
                    )
                  : Container(),
            ],
          )
        : WidgetMask(
            blendMode: BlendMode.srcATop,
            childSaveLayer: true,
            mask: Center(
              child: Image.network(
                Thumbor(host: thumborHostUrl, key: thumborKey)
                    .buildImage("$imgDomain$profileImgUrl")
                    .toUrl(),
                height: 46.h,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            child: SvgPicture.asset(
              'assets/image/feed/image/squircle.svg',
              height: 46.h,
              fit: BoxFit.fill,
            ),
          );
  }

  Widget _buildTabbar(bool innerBoxIsScrolled) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 320;

    return Container(
      decoration: innerBoxIsScrolled
          ? const BoxDecoration(
              color: Colors.white,
            )
          : BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: -5,
                  blurRadius: 7,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
      child: Row(
        children: [
          Flexible(
            flex: isBigDevice ? 1 : 2,
            child: TabBar(
              controller: tabController,
              indicatorWeight: 3,
              labelColor: kNeutralColor600,
              indicatorColor: kNeutralColor600,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(
                top: 10.h,
                bottom: 6.h,
              ),
              tabs: getTabs(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
