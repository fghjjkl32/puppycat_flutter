import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/follow_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/my_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/popular_hour_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/popular_week_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/recent_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/firebase/firebase_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/favorite_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/refresh_loading_animation_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/feed_main_widget.dart';
import 'package:pet_mobile_social_flutter/ui/home/component/popupmenu_with_reddot_widget.dart';
import 'package:widget_mask/widget_mask.dart';

class PuppyCatMain extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const PuppyCatMain({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  PuppyCatMainState createState() => PuppyCatMainState();
}

class PuppyCatMainState extends ConsumerState<PuppyCatMain> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController tabController;

  late final PagingController<int, FeedData> _myFeedListPagingController = ref.watch(myFeedStateProvider);
  late final PagingController<int, FeedData> _recentFeedListPagingController = ref.watch(recentFeedStateProvider);
  late final PagingController<int, FeedData> _followFeedListPagingController = ref.watch(followFeedStateProvider);

  late final PagingController<int, FeedData> _popularWeekFeedListPagingController = ref.watch(popularWeekFeedStateProvider);

  bool _showIcon = false;

  List<Widget> getTabs() {
    final isLogined = ref.read(loginStatementProvider);

    List<Widget> tabs = [
      Text(
        "피드.전체".tr(),
        style: kTitle16BoldStyle,
      ),
    ];

    if (isLogined) {
      tabs.addAll([
        Text(
          "피드.팔로잉".tr(),
          style: kTitle16BoldStyle,
        ),
        Text(
          "피드.내 피드".tr(),
          style: kTitle16BoldStyle,
        ),
      ]);
    }

    return tabs;
  }

  List<Widget> getTabSpacer() {
    final isLogined = ref.read(loginStatementProvider);

    if (isLogined) {
      return [const SizedBox.shrink()];
    } else {
      return [
        const Spacer(),
        const Spacer(),
        const Spacer(),
      ];
    }
  }

  void _handleStatusBarTap() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linearToEaseOut,
    );
  }

  void openAssetPicker(BuildContext context, dynamic Function(Stream<InstaAssetsExportDetails>) onCompleted) {
    final theme = themeData(context);

    InstaAssetPicker.pickAssets(
      context,
      maxAssets: 12,
      pickerTheme: theme.copyWith(
        canvasColor: kPreviousNeutralColor100,
        colorScheme: theme.colorScheme.copyWith(
          background: kPreviousNeutralColor100,
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: kPreviousNeutralColor100,
        ),
      ),
      useRootNavigator: false,
      onCompleted: onCompleted,
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: getTabs().length, initialIndex: widget.initialTabIndex);

    ref.read(firebaseStateProvider.notifier).checkNotificationAppLaunch();

    Future(() async {
      scrollController.addListener(_myPostScrollListener);

      refreshFeedList();
    });
  }

  void _myPostScrollListener() {
    setState(() {
      ref.read(loginStatementProvider) == false ? _showIcon = false : _showIcon = scrollController.offset > 100;
    });
  }

  Future<TabController> _initTabController() async {
    if (getTabs().length != tabController.length) {
      refreshFeedList();

      tabController.dispose();
      tabController = TabController(
        length: getTabs().length,
        initialIndex: 0,
        vsync: this,
      );
    }
    return tabController;
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void refreshFeedList() {
    Future(() {
      ref.read(followUserStateProvider.notifier).resetState();
    });
    ref.read(popularUserListStateProvider.notifier).getInitUserList();
    ref.read(popularHourFeedStateProvider.notifier).initPosts();

    final isLogined = ref.read(loginStatementProvider);

    _recentFeedListPagingController.refresh();

    if (isLogined) {
      _myFeedListPagingController.refresh();

      _popularWeekFeedListPagingController.refresh();

      _followFeedListPagingController.refresh();

      ref.read(favoriteUserListStateProvider.notifier).getInitUserList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;
    final isLogined = ref.watch(loginStatementProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: isBigDevice
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(30.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/image/logo/logo.png',
                          width: 107,
                          height: 39,
                        ),
                        _buttonWidget(),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
          body: SafeArea(
            child: Consumer(builder: (context, ref, _) {
              return FutureBuilder(
                  future: _initTabController(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return DefaultTabController(
                      length: isLogined ? 3 : 1,
                      child: NestedScrollView(
                        controller: scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            isBigDevice
                                ? SliverAppBar(
                                    pinned: true,
                                    snap: false,
                                    floating: true,
                                    expandedHeight: 180.0,
                                    centerTitle: false,
                                    leading: null,
                                    titleSpacing: 0,
                                    backgroundColor: kPreviousNeutralColor100,
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
                                        color: kPreviousNeutralColor100,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                left: 16,
                                              ),
                                              child: Image.asset(
                                                'assets/image/logo/logo.png',
                                                width: 107,
                                                height: 39,
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
                                    expandedHeight: 135.0,
                                    centerTitle: false,
                                    leading: null,
                                    titleSpacing: 0,
                                    backgroundColor: kPreviousNeutralColor100,
                                    automaticallyImplyLeading: false,
                                    flexibleSpace: FlexibleSpaceBar(
                                      titlePadding: EdgeInsets.zero,
                                      expandedTitleScale: 1.0,
                                      centerTitle: false,
                                      collapseMode: CollapseMode.pin,
                                      title: _buildTabbar(innerBoxIsScrolled),
                                      background: Container(
                                        color: kPreviousNeutralColor100,
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
                        body: Stack(
                          children: [
                            TabBarView(
                              controller: tabController,
                              children: [
                                _tab(_recentFeedListPagingController),
                                if (isLogined) ...[
                                  _tab(_followFeedListPagingController),
                                  _tab(_myFeedListPagingController),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).padding.top,
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: _handleStatusBarTap,
          ),
        ),
      ],
    );
  }

  Widget _buttonWidget() {
    final myInfo = ref.watch(myInfoStateProvider);
    final isLogined = ref.watch(loginStatementProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (!isLogined) {
              if (mounted) {
                context.push('/home/login');
              }
            } else {
              if (await Permissions.getCameraPermissionState()) {
                if (!isLogined) {
                  context.push('/home/login');
                }

                final ImagePicker picker = ImagePicker();

                final pickedFile = await picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  await ImageGallerySaver.saveFile(pickedFile.path);

                  openAssetPicker(
                    context,
                    (cropStream) {
                      context.push('/feed/write', extra: cropStream);
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            children: [
                              Text(
                                "피드.사진 권한".tr(),
                                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                "피드.언제든지 설정을 바꿀 수 있어요".tr(),
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        confirmTap: () {
                          context.pop();
                          openAppSettings();
                        },
                        cancelTap: () {
                          context.pop();
                        },
                        confirmWidget: Text(
                          "피드.설정 열기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                        ),
                        cancelWidget: Text(
                          "피드.닫기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ));
                  },
                );
              }
            }
          },
          child: Consumer(builder: (context, ref, _) {
            return const Icon(
              Puppycat_social.icon_camera,
              color: kPreviousNeutralColor600,
              size: 40,
            );
          }),
        ),
        GestureDetector(
          onTap: () async {
            if (mounted) {
              if (!isLogined) {
                context.push("/home/login");
              } else {
                final restrain = await ref.read(restrainStateProvider.notifier).checkRestrainStatus(RestrainCheckType.writeFeed);

                if (restrain) {
                  if (mounted) {
                    openAssetPicker(
                      context,
                      (cropStream) {
                        context.push('/feed/write', extra: cropStream);
                      },
                    );
                  }
                }
              }
            }
          },
          child: Consumer(builder: (context, ref, _) {
            return const Icon(
              Puppycat_social.icon_feed,
              color: kPreviousNeutralColor600,
              size: 40,
            );
          }),
        ),
        const PopupMenuWithReddot(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 4.0),
          child: GestureDetector(
            onTap: () {
              context.push("/member/myPage");
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _showIcon ? 36.0 : 0.0,
              child: Opacity(
                opacity: _showIcon ? 1.0 : 0.0,
                child: myInfo.profileImgUrl == null || myInfo.profileImgUrl!.isEmpty
                    ? WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: const Center(
                          child: Icon(
                            Puppycat_social.icon_profile_small,
                            size: 22,
                            color: kPreviousNeutralColor400,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 22,
                        ),
                      )
                    : WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Center(
                          child: Image.network(
                            thumborUrl(myInfo.profileImgUrl ?? ''),
                            height: 22,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/image/feed/image/squircle.svg',
                          height: 22,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tab(PagingController<int, FeedData> pagingController) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    final isRecentFeedList = pagingController == _recentFeedListPagingController;
    final isFollowFeedList = pagingController == _followFeedListPagingController;
    final isMyFeedList = pagingController == _myFeedListPagingController;

    return CustomRefreshIndicator(
      onRefresh: () {
        return Future(() {
          refreshFeedList();
        });
      },
      builder: (context, child, controller) {
        return RefreshLoadingAnimationWidget(controller: controller, child: child);
      },
      child: CustomScrollView(
        slivers: <Widget>[
          PagedSliverList<int, FeedData>(
            shrinkWrapFirstPageIndicators: true,
            pagingController: pagingController,
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
                return Container();
              },
              noItemsFoundIndicatorBuilder: (context) {
                return isMyFeedList
                    ? Column(
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
                                  '피드.내 피드 없음'.tr(),
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
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
                                    !isLogined
                                        ? context.push("/home/login")
                                        : openAssetPicker(
                                            context,
                                            (cropStream) {
                                              context.push('/feed/write', extra: cropStream);
                                            },
                                          );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPreviousPrimaryColor,
                                    disabledBackgroundColor: kPreviousNeutralColor400,
                                    disabledForegroundColor: kPreviousTextBodyColor,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    '피드.피드 올리기'.tr(),
                                    style: kButton14MediumStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
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
                                  '피드.피드가 없어요'.tr(),
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
              },
              itemBuilder: (context, item, index) {
                //게시글을 수정하고 나면 FeedData 형태가 memberInfo로 들어오기 때문에 ref.read(recentFeedStateProvider.notifier).memberInfo 사용
                if (isMyFeedList) {
                  return FeedMainWidget(
                    feedData: item,
                    contentType: 'myContent',
                    userName: ref.read(myFeedStateProvider.notifier).memberInfo!.nick!,
                    profileImage: ref.read(myFeedStateProvider.notifier).memberInfo!.profileImgUrl ?? "",
                    oldMemberUuid: myInfo.uuid ?? '',
                    firstTitle: ref.read(myFeedStateProvider.notifier).memberInfo!.nick!,
                    secondTitle: '피드',
                    index: index,
                    feedType: 'my',
                    isSpecialUser: ref.read(myFeedStateProvider.notifier).memberInfo!.isBadge == 1,
                    onTapHideButton: () async {
                      onTapHide(
                        context: context,
                        ref: ref,
                        contentType: 'myContent',
                        contentIdx: item.idx,
                        memberUuid: item.memberUuid!,
                      );
                    },
                  );
                }
                return FeedMainWidget(
                  feedData: item,
                  contentType: 'userContent',
                  userName: item.memberInfo?.nick ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                  profileImage: item.memberInfo?.profileImgUrl ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.profileImgUrl ?? "",
                  oldMemberUuid: myInfo.uuid ?? '',
                  firstTitle: item.memberInfo?.nick ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? 'unknown',
                  secondTitle: '피드.피드'.tr(),
                  index: index,
                  feedType: isFollowFeedList
                      ? 'follow'
                      : isRecentFeedList
                          ? 'recent'
                          : "",
                  isSpecialUser: item.memberInfo?.isBadge == 1 ? true : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.isBadge == 1,
                  onTapHideButton: () async {
                    onTapHide(
                      context: context,
                      ref: ref,
                      contentType: 'userContent',
                      contentIdx: item.idx,
                      memberUuid: item.memberUuid ?? "",
                    );
                  },
                );
              },
            ),
          ),
          isFollowFeedList
              ? PagedSliverList<int, FeedData>(
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
                                  '피드.피드가 없어요'.tr(),
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                        contentType: 'userContent',
                        userName: item.memberInfo?.nick ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                        profileImage: item.memberInfo?.profileImgUrl ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.profileImgUrl ?? '',
                        oldMemberUuid: myInfo.uuid ?? '',
                        firstTitle: item.memberInfo?.nick ?? ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                        secondTitle: '피드.피드'.tr(),
                        index: index,
                        feedType: 'popular',
                        isSpecialUser: item.memberInfo?.isBadge == 1 ? true : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.isBadge == 1,
                        onTapHideButton: () async {
                          onTapHide(
                            context: context,
                            ref: ref,
                            contentType: 'userContent',
                            contentIdx: item.idx,
                            memberUuid: item.memberUuid!,
                          );
                        },
                        // feedType: 'follow',
                      );
                    },
                  ),
                )
              : const SliverToBoxAdapter(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildBackGround() {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;

    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.watch(loginStatementProvider);

    return isLogined
        ? Padding(
            padding: EdgeInsets.only(
              top: isBigDevice ? 50 : 5,
            ),
            child: Consumer(builder: (context, ref, child) {
              final userListState = ref.watch(favoriteUserListStateProvider);
              final userListLists = userListState.memberList;

              return Row(
                children: [
                  Padding(
                    key: ValueKey(myInfo.profileImgUrl),
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push("/member/myPage");
                      },
                      child: Column(
                        children: [
                          getProfileAvatarWithBadge(myInfo.profileImgUrl ?? '', myInfo.isBadge == 1, 54, 54),
                          const SizedBox(height: 4.0),
                          Text(
                            "my",
                            style: kBody12ExtraBoldStyle.copyWith(color: kTextPrimary),
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
                              myInfo.uuid == userListLists[index].uuid
                                  ? context.push("/member/myPage")
                                  : context.push("/member/userPage", extra: {"nick": userListLists[index].nick, "memberUuid": userListLists[index].uuid, "oldMemberUuid": userListLists[index].uuid});
                            },
                            child: Column(
                              children: [
                                getProfileAvatarWithBadge(userListLists[index].profileImgUrl ?? '', userListLists[index].isBadge == 1, 54, 54),
                                const SizedBox(height: 4.0),
                                Stack(
                                  children: [
                                    userListLists[index].redDotState == 1
                                        ? const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                              size: 6,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        userListLists[index].nick!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: kBody12RegularStyle.copyWith(color: kTextPrimary),
                                      ),
                                    ),
                                  ],
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
            }),
          )
        : Center(
            child: GestureDetector(
              onTap: () {
                context.push("/home/login");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/character/character_01_not_loginpage.png',
                    width: 56,
                    height: 56,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "피드.로그인하고 일상 공유하기".tr(),
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildTabbar(bool innerBoxIsScrolled) {
    bool isBigDevice = MediaQuery.of(context).size.width >= 345;

    return Container(
      decoration: innerBoxIsScrolled
          ? const BoxDecoration(
              color: Colors.white,
            )
          : const BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, -6),
                  blurRadius: 10.0,
                ),
              ],
            ),
      child: Row(
        children: [
          Flexible(
            flex: isBigDevice ? 1 : 2,
            child: TabBar(
              controller: tabController,
              indicatorWeight: 2.4,
              labelColor: kPreviousNeutralColor600,
              indicatorColor: kPreviousNeutralColor600,
              unselectedLabelColor: kPreviousNeutralColor500,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: const EdgeInsets.only(
                top: 10,
                bottom: 6,
              ),
              tabs: getTabs(),
            ),
          ),
          const Spacer(),
          ...getTabSpacer(),
        ],
      ),
    );
  }
}
