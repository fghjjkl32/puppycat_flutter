import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/feed_write_show_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_best_post_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/favorite_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_write_provider.dart';
import 'package:pet_mobile_social_flutter/ui/dialog/restriction_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/popupmenu_with_reddot_widget.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:thumbor/thumbor.dart';

class PuppyCatMain extends ConsumerStatefulWidget {
  const PuppyCatMain({Key? key}) : super(key: key);

  @override
  PuppyCatMainState createState() => PuppyCatMainState();
}

class PuppyCatMainState extends ConsumerState<PuppyCatMain> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  bool _showIcon = false;

  late final PagingController<int, FeedData> _myFeedListPagingController = ref.read(myFeedStateProvider);
  late final PagingController<int, FeedData> _recentFeedListPagingController = ref.read(recentFeedStateProvider);
  late final PagingController<int, FeedData> _followFeedListPagingController = ref.read(followFeedStateProvider);
  late final PagingController<int, FeedData> _popularWeekFeedListPagingController = ref.read(popularWeekFeedStateProvider);

  bool showLottieAnimation = false;

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

    ref.read(recentFeedStateProvider.notifier).loginMemberIdx = ref.read(userModelProvider)?.idx;

    tabController = TabController(vsync: this, length: getTabs().length);
    Future(() {
      final loginState = ref.watch(loginStateProvider);

      _recentFeedListPagingController.refresh();

      ref.read(popularUserListStateProvider.notifier).getInitUserList(
            ref.read(userModelProvider)?.idx,
          );

      ref.read(popularHourFeedStateProvider.notifier).initPosts(
            loginMemberIdx: ref.read(userModelProvider)?.idx,
          );

      scrollController.addListener(_myPostScrollListener);

      if (loginState == LoginStatus.success) {
        _myFeedListPagingController.refresh();

        _popularWeekFeedListPagingController.refresh();

        _followFeedListPagingController.refresh();

        ref.read(favoriteUserListStateProvider.notifier).getInitUserList(ref.read(userModelProvider)!.idx);
      }
    });
  }

  void _myPostScrollListener() {
    setState(() {
      ref.read(userModelProvider) == null ? _showIcon = false : _showIcon = scrollController.offset > 100.h;
    });
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

    return WillPopScope(
      onWillPop: () async {
        bool backResult = onBackPressed();
        return await Future.value(backResult);
      },
      child: Scaffold(
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
          child: RefreshIndicator(
            onRefresh: () {
              return Future(() {
                final loginState = ref.watch(loginStateProvider);

                _recentFeedListPagingController.refresh();

                ref.read(popularUserListStateProvider.notifier).getInitUserList(
                      ref.read(userModelProvider)?.idx,
                    );

                ref.read(popularHourFeedStateProvider.notifier).initPosts(
                      loginMemberIdx: ref.read(userModelProvider)?.idx,
                    );

                scrollController.addListener(_myPostScrollListener);

                if (loginState == LoginStatus.success) {
                  _myFeedListPagingController.refresh();

                  _popularWeekFeedListPagingController.refresh();

                  _followFeedListPagingController.refresh();

                  ref.read(favoriteUserListStateProvider.notifier).getInitUserList(ref.read(userModelProvider)!.idx);
                }
              });
            },
            child: Consumer(builder: (context, ref, _) {
              return DefaultTabController(
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
                      Container(
                        color: Colors.blue,
                      ),
                      if (loginState == LoginStatus.success) ...[
                        _thirdTab(),
                      ],
                      if (loginState == LoginStatus.success) ...[
                        _fourthTab(),
                      ],
                    ],
                  ),
                ),
              );
            }),
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
            await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userModelProvider)!.idx);

            if (ref.read(userModelProvider) == null) {
              context.pushReplacement("/loginScreen");
            } else if (ref.watch(restrainWriteStateProvider).restrain.state == null) {
              final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

              final ImagePicker picker = ImagePicker();

              final pickedFile = await picker.pickImage(source: ImageSource.camera);

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
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => RestrictionDialog(
                  isForever: false,
                  date: ref.watch(restrainWriteStateProvider).restrain.date,
                  restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
                  startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
                  endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
                ),
              );
            }
          },
          child: const Icon(
            Puppycat_social.icon_camera,
            size: 40,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await ref.watch(restrainWriteStateProvider.notifier).getWriteRestrain(ref.read(userModelProvider)!.idx);

            ref.read(userModelProvider) == null
                ? context.pushReplacement("/loginScreen")
                : ref.watch(restrainWriteStateProvider).restrain.state == null
                    ? feedWriteShowBottomSheet(
                        context: context,
                        onClose: () {
                          setState(() {
                            showLottieAnimation = false;
                          });
                        },
                      )
                    : showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => RestrictionDialog(
                          isForever: false,
                          date: ref.watch(restrainWriteStateProvider).restrain.date,
                          restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
                          startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
                          endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
                        ),
                      );

            setState(() {
              showLottieAnimation = true;
            });
          },
          child: showLottieAnimation
              ? Lottie.asset(
                  'assets/lottie/icon_feed.json',
                )
              : const Icon(
                  Puppycat_social.icon_feed,
                  size: 40,
                ),
        ),
        const PopupMenuWithReddot(),
        GestureDetector(
          onTap: () {
            context.go("/home/myPage");
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _showIcon ? 36.0 : 0.0,
            child: Opacity(
              opacity: _showIcon ? 1.0 : 0.0,
              child: ref.read(userInfoProvider).userModel?.profileImgUrl == null || ref.read(userInfoProvider).userModel?.profileImgUrl == ""
                  ? WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Icon(
                          Puppycat_social.icon_profile_small,
                          size: 22,
                          color: kNeutralColor400,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/image/feed/image/squircle.svg',
                        height: 22.h,
                      ),
                    )
                  : WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Center(
                        child: Image.network(
                          Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${ref.read(userInfoProvider).userModel!.profileImgUrl}").toUrl(),
                          height: 22.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
    return CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<int, FeedData>(
          // shrinkWrap: true,
          shrinkWrapFirstPageIndicators: true,
          pagingController: _recentFeedListPagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedData>(
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
            noItemsFoundIndicatorBuilder: (context) {
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
                          '등록된 게시물이 없습니다.',
                          textAlign: TextAlign.center,
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            itemBuilder: (context, item, index) {
              return FeedMainWidget(
                feedData: item,
                contentType: 'userContent',
                userName: item.memberInfoList![0].nick!,
                profileImage: item.memberInfoList?[0].profileImgUrl! ?? "",
                memberIdx: ref.read(userModelProvider)?.idx,
                firstTitle: item.memberInfoList![0].nick!,
                secondTitle: '게시물',
                imageDomain: ref.read(recentFeedStateProvider.notifier).imgDomain!,
                index: index,
                feedType: 'recent',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _thirdTab() {
    return CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<int, FeedData>(
          shrinkWrapFirstPageIndicators: true,
          pagingController: _followFeedListPagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedData>(
            noItemsFoundIndicatorBuilder: (context) {
              return const SizedBox.shrink();
            },
            newPageProgressIndicatorBuilder: (context) {
              return Container();
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
            itemBuilder: (context, item, index) {
              return FeedMainWidget(
                feedData: item,
                contentType: 'userContent',
                userName: ref.read(followFeedStateProvider.notifier).memberInfo?[0].nick ?? item.memberInfoList![0].nick!,
                profileImage: ref.read(followFeedStateProvider.notifier).memberInfo?[0].profileImgUrl ?? item.memberInfoList![0].profileImgUrl! ?? "",
                memberIdx: ref.read(userModelProvider)!.idx,
                firstTitle: ref.read(followFeedStateProvider.notifier).memberInfo?[0].nick ?? item.memberInfoList![0].nick!,
                secondTitle: '게시물',
                imageDomain: ref.read(followFeedStateProvider.notifier).imgDomain!,
                index: index,
                feedType: 'follow',
              );
            },
          ),
        ),
        PagedSliverList<int, FeedData>(
          shrinkWrapFirstPageIndicators: true,
          pagingController: _popularWeekFeedListPagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedData>(
            noItemsFoundIndicatorBuilder: (context) {
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
                          '등록된 게시물이 없습니다.',
                          textAlign: TextAlign.center,
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                        ),
                      ],
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
              return Container();
            },
            itemBuilder: (context, item, index) {
              return FeedMainWidget(
                feedData: item,
                // contentType: 'popularWeekContent',
                contentType: 'userContent',
                userName: item.memberInfoList![0].nick!,
                profileImage: item.memberInfoList![0].profileImgUrl! ?? "",
                memberIdx: ref.read(userModelProvider)?.idx,
                // firstTitle: "null",
                firstTitle: ref.read(followFeedStateProvider.notifier).memberInfo?[0].nick ?? item.memberInfoList![0].nick!,
                // secondTitle: '인기 급상승',
                secondTitle: '게시물',
                imageDomain: ref.read(popularWeekFeedStateProvider.notifier).imgDomain!,
                index: index,
                // feedType: 'popular',
                feedType: 'follow',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _fourthTab() {
    return CustomScrollView(
      slivers: <Widget>[
        PagedSliverList<int, FeedData>(
          // shrinkWrap: true,
          shrinkWrapFirstPageIndicators: true,
          pagingController: _myFeedListPagingController,
          builderDelegate: PagedChildBuilderDelegate<FeedData>(
            noItemsFoundIndicatorBuilder: (context) {
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
                          '등록된 작성 글이 없습니다.\n게시물을 등록해 주세요!',
                          textAlign: TextAlign.center,
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 320,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(userModelProvider) == null
                                ? context.pushReplacement("/loginScreen")
                                : ref.watch(restrainWriteStateProvider).restrain.state == null
                                    ? feedWriteShowBottomSheet(
                                        context: context,
                                        onClose: () {
                                          setState(() {
                                            showLottieAnimation = false;
                                          });
                                        },
                                      )
                                    : showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => RestrictionDialog(
                                          isForever: false,
                                          date: ref.watch(restrainWriteStateProvider).restrain.date,
                                          restrainName: ref.watch(restrainWriteStateProvider).restrain.restrainName,
                                          startDate: ref.watch(restrainWriteStateProvider).restrain.startDate,
                                          endDate: ref.watch(restrainWriteStateProvider).restrain.endDate,
                                        ),
                                      );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            disabledBackgroundColor: kNeutralColor400,
                            disabledForegroundColor: kTextBodyColor,
                            elevation: 0,
                          ),
                          child: Text(
                            '게시글 등록하기',
                            style: kButton14MediumStyle,
                          ),
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
            itemBuilder: (context, item, index) {
              return FeedMainWidget(
                feedData: item,
                contentType: 'myContent',
                userName: ref.read(myFeedStateProvider.notifier).memberInfo![0].nick!,
                profileImage: ref.read(myFeedStateProvider.notifier).memberInfo?[0].profileImgUrl ?? "",
                memberIdx: ref.read(userModelProvider)!.idx,
                firstTitle: ref.read(myFeedStateProvider.notifier).memberInfo![0].nick!,
                secondTitle: '게시물',
                imageDomain: ref.read(myFeedStateProvider.notifier).imgDomain!,
                index: index,
                feedType: 'my',
              );
            },
          ),
        ),
      ],
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
                          buildWidgetMask(ref.read(userInfoProvider).userModel?.profileImgUrl ?? "", ref.read(userInfoProvider).userModel?.isBadge),
                          const SizedBox(height: 4.0),
                          Text(
                            "my",
                            style: kBody12RegularStyle.copyWith(color: kTextTitleColor),
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
                              ref.read(userModelProvider)?.idx == userListLists[index].memberIdx
                                  ? context.push("/home/myPage")
                                  : context.push("/home/myPage/followList/${userListLists[index].memberIdx}/userPage/${userListLists[index].nick}/${userListLists[index].memberIdx}/0");
                            },
                            child: Column(
                              children: [
                                buildWidgetMask(userListLists[index].profileImgUrl, userListLists[index].isBadge),
                                const SizedBox(height: 4.0),
                                Text(
                                  userListLists[index].nick!,
                                  style: kBody12RegularStyle.copyWith(color: kTextTitleColor),
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
                    'assets/image/character/character_01_not_loginpage.png',
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: Text(
                      "로그인 하고 나랑 딱! 맞는 친구 보기",
                      style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
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
                  child: Icon(
                    Puppycat_social.icon_profile_small,
                    size: 46,
                    color: kNeutralColor400,
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
        : Stack(
            children: [
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Center(
                  child: Image.network(
                    Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain$profileImgUrl").toUrl(),
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
