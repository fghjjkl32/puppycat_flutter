import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/block/block_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
///NOTE
///2023.11.16.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_list/my_pet_list_state_provider.dart';
///산책하기 보류로 주석 처리 완료
import 'package:pet_mobile_social_flutter/providers/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/loading_animation_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/refresh_loading_animation_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({
    super.key,
    required this.memberUuid,
    required this.nick,
    required this.oldMemberUuid,
  });

  final String memberUuid;
  final String nick;
  final String oldMemberUuid;

  @override
  UserMainScreenState createState() => UserMainScreenState();
}

class UserMainScreenState extends ConsumerState<UserMainScreen> with SingleTickerProviderStateMixin {
  ///NOTE
  ///2023.11.16.
  ///산책하기 보류로 주석 처리
  // late final PagingController<int, MyPetItemModel> _myPetListPagingController = ref.read(myPetListStateProvider);
  ///산책하기 보류로 주석 처리 완료
  late final PagingController<int, ContentImageData> _userContentsListPagingController = ref.read(userContentsStateProvider);
  late final PagingController<int, ContentImageData> _userTagContentsListPagingController = ref.read(userTagContentsStateProvider);

  ScrollController scrollController = ScrollController();
  late Future _fetchUserDataFuture;

  bool showLottieAnimation = false;

  late TabController tabController;
  Color appBarColor = Colors.transparent;
  int userOldLength = 0;
  int tagOldLength = 0;
  int commentOldLength = 0;

  @override
  void initState() {
    ///NOTE
    ///2023.11.16.
    ///산책하기 보류로 주석 처리
    // ref.read(myPetListStateProvider.notifier).memberIdx = widget.memberIdx;
    // _myPetListPagingController.refresh(); //이건 ref.read(userTagContentsStateProvider.notifier).memberIdx = widget.memberIdx; 아래에 있었음
    ///산책하기 보류로 주석 처리 완료
    ref.read(userContentsStateProvider.notifier).memberUuid = widget.memberUuid;
    ref.read(userTagContentsStateProvider.notifier).memberUuid = widget.memberUuid;

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);
    ref.read(firstFeedDetailStateProvider.notifier).saveStateForUser(widget.oldMemberUuid);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _fetchUserDataFuture = _fetchUserData();
  }

  Future<UserInformationItemModel?> _fetchUserData() {
    _userContentsListPagingController.refresh();
    _userTagContentsListPagingController.refresh();
    return ref.watch(userInformationStateProvider.notifier).getInitUserInformation(memberUuid: widget.memberUuid);
  }

  void _scrollListener() {
    if (scrollController.offset >= 128 && appBarColor != kPreviousNeutralColor100) {
      setState(() {
        appBarColor = kPreviousNeutralColor100;
      });
    } else if (scrollController.offset < 128 && appBarColor != Colors.transparent) {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return DefaultOnWillPopScope(
      onWillPop: () async {
        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
        ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
        return Future.value(true);
      },
      child: Material(
        child: SafeArea(
            child: FutureBuilder(
                future: _fetchUserDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('error');
                  }

                  if (!snapshot.hasData) {
                    return const LoadingAnimationWidget();
                  }
                  return DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          Consumer(builder: (context, ref, _) {
                            return SliverAppBar(
                                pinned: true,
                                floating: false,
                                backgroundColor: appBarColor,
                                title: Text(widget.nick),
                                leading: IconButton(
                                  onPressed: () {
                                    ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                                    ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                                    context.pop();
                                  },
                                  icon: const Icon(
                                    Puppycat_social.icon_back,
                                    size: 40,
                                  ),
                                ),
                                forceElevated: innerBoxIsScrolled,
                                actions: [
                                  Consumer(builder: (context, ref, _) {
                                    final userInformationItemModel = ref.watch(userInformationStateProvider);

                                    return userInformationItemModel.blockedState == 1 || userInformationItemModel.blockedMeState == 1
                                        ? Container()
                                        : PopupMenuButton(
                                            padding: EdgeInsets.zero,
                                            offset: const Offset(0, 42),
                                            child: showLottieAnimation
                                                ? Lottie.asset(
                                                    'assets/lottie/icon_more_header.json',
                                                    repeat: false,
                                                  )
                                                : const Padding(
                                                    padding: EdgeInsets.only(right: 8.0),
                                                    child: Icon(
                                                      Puppycat_social.icon_more_header,
                                                      size: 40,
                                                    ),
                                                  ),
                                            onCanceled: () {
                                              setState(() {
                                                showLottieAnimation = false;
                                              });
                                            },
                                            onSelected: (id) {
                                              setState(() {
                                                showLottieAnimation = false;
                                              });
                                              if (id == 'block') {
                                                if (!isLogined) {
                                                  context.push("/home/login");
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
                                                                "‘${widget.nick}’님을\n차단할까요?",
                                                                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                "차단하게 되면 더 이상 서로의 피드를 보거나\n메시지 등을 보낼 수 없어요.\n차단 여부는 상대방에게 알리지 않아요.\n차단 풀기는 [마이페이지→설정→차단 유저 관리]에서\n얼마든지 가능해요.",
                                                                style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        confirmTap: () async {
                                                          context.pop();
                                                          toast(
                                                            context: context,
                                                            text: "'${widget.nick.length > 8 ? '${widget.nick.substring(0, 8)}...' : widget.nick}'님을 차단했어요.",
                                                            type: ToastType.purple,
                                                          );
                                                          final result = await ref.read(userInformationStateProvider.notifier).postBlock(
                                                                blockUuid: widget.memberUuid,
                                                              );

                                                          if (result.result) {
                                                            ref.watch(userInformationStateProvider.notifier).updateBlockState();
                                                          }
                                                        },
                                                        cancelTap: () {
                                                          context.pop();
                                                        },
                                                        confirmWidget: Text(
                                                          "차단하기",
                                                          style: kButton14MediumStyle.copyWith(color: kTextActionPrimary),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
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
                                              Future.delayed(Duration.zero, () {
                                                setState(() {
                                                  showLottieAnimation = true;
                                                });
                                              });
                                              final list = <PopupMenuEntry>[];
                                              list.add(
                                                diaryPopUpMenuItem(
                                                  'block',
                                                  '차단하기',
                                                  const Icon(
                                                    Puppycat_social.icon_user_block_ac,
                                                  ),
                                                  context,
                                                ),
                                              );
                                              return list;
                                            },
                                          );
                                  }),
                                ],

                                ///NOTE
                                ///2023.11.16.
                                ///산책하기 보류로 주석 처리
                                // expandedHeight: ref.watch(expandedHeightProvider),
                                expandedHeight: 180,

                                ///산책하기 보류로 주석 처리 완료
                                flexibleSpace: Consumer(builder: (context, ref, _) {
                                  final userInformationItemModel = ref.watch(userInformationStateProvider);

                                  final isFollow = ref.watch(followUserStateProvider)[widget.memberUuid] ?? false;

                                  return _myPageSuccessProfile(userInformationItemModel, isFollow);
                                }));
                          }),
                          const SliverPersistentHeader(
                            delegate: TabBarDelegate(),
                            pinned: true,
                          ),
                        ];
                      },
                      body: Consumer(builder: (context, ref, _) {
                        final userInformationItemModel = ref.watch(userInformationStateProvider);

                        return userInformationItemModel.blockedState == 1
                            ? Container(
                                color: kPreviousNeutralColor100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/character/character_07_block_88 (1).png',
                                      height: 68,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "차단한 유저의 정보는 볼 수 없어요.\n정보를 보려면 차단을 풀어 주세요.",
                                      textAlign: TextAlign.center,
                                      style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                    ),
                                  ],
                                ),
                              )
                            : userInformationItemModel.blockedMeState == 1
                                ? Container(
                                    color: kPreviousNeutralColor100,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/image/character/character_07_block_me_88.png',
                                          height: 68,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "정보를 볼 수 없어요.",
                                          textAlign: TextAlign.center,
                                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                        ),
                                      ],
                                    ),
                                  )
                                : TabBarView(
                                    children: [
                                      _firstTabBody(),
                                      _secondTabBody(),
                                    ],
                                  );
                      }),
                    ),
                  );
                })),
      ),
    );
  }

  Widget _firstTabBody() {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return CustomRefreshIndicator(
      onRefresh: () {
        return Future(() {
          ref.read(userContentsStateProvider.notifier).memberUuid = ref.read(userContentsTempUuidProvider);

          _userContentsListPagingController.refresh();
        });
      },
      builder: (context, child, controller) {
        return RefreshLoadingAnimationWidget(controller: controller, child: child);
      },
      child: Container(
        color: kPreviousNeutralColor100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            PagedSliverGrid<int, ContentImageData>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrapFirstPageIndicators: true,
              pagingController: _userContentsListPagingController,
              builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: kPreviousNeutralColor100,
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
                                  '피드가 없어요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
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
                  return Container();
                  Column(
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
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> extraMap = {
                          'firstTitle': '${ref.watch(userInformationStateProvider).nick}',
                          'secondTitle': '피드',
                          'memberUuid': ref.watch(userInformationStateProvider).uuid,
                          'contentIdx': '${item.idx}',
                          'contentType': 'userContent',
                        };
                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('userContent', item.idx).then((value) {
                          if (value == null) {
                            return;
                          }
                          // context.push("/feed/detail/${ref.watch(userInformationStateProvider).list[0].nick}/피드/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${item.idx}/userContent");
                          context.push('/feed/detail', extra: extraMap);
                        });
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kPreviousNeutralColor300,
                                  ),
                                  imageUrl: thumborUrl(item.imgUrl ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    '${item.imageCnt}',
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).throttle(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTabBody() {
    final myInfo = ref.read(myInfoStateProvider);

    return CustomRefreshIndicator(
      onRefresh: () {
        return Future(() {
          // if (widget.oldMemberUuid != myInfo.uuid) {
          //   if (widget.oldMemberUuid == '') return;
          //   ref.read(userTagContentsStateProvider.notifier).memberUuid = widget.memberUuid;
          // }

          ref.read(userContentsStateProvider.notifier).memberUuid = ref.read(userTagContentsTempUuidProvider);

          _userTagContentsListPagingController.refresh();
        });
      },
      builder: (context, child, controller) {
        return RefreshLoadingAnimationWidget(controller: controller, child: child);
      },
      child: Container(
        color: kPreviousNeutralColor100,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            PagedSliverGrid<int, ContentImageData>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              shrinkWrapFirstPageIndicators: true,
              pagingController: _userTagContentsListPagingController,
              builderDelegate: PagedChildBuilderDelegate<ContentImageData>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            color: kPreviousNeutralColor100,
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
                                  '피드가 없어요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
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
                  return Container();
                  Column(
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
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        Map<String, dynamic> extraMap = {
                          'firstTitle': '${ref.watch(userInformationStateProvider).nick}',
                          'secondTitle': '태그됨',
                          'memberUuid': ref.watch(userInformationStateProvider).uuid,
                          'contentIdx': '${item.idx}',
                          'contentType': 'userTagContent',
                        };
                        await ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState('userTagContent', item.idx).then((value) {
                          if (value == null) {
                            return;
                          }
                          // context.push('/feed/detail/${ref.watch(userInformationStateProvider).list[0].nick}/태그됨/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${item.idx}/userTagContent");
                          context.push('/feed/detail', extra: extraMap);
                        });
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kPreviousNeutralColor300,
                                  ),
                                  imageUrl: thumborUrl(item.imgUrl ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18,
                                height: 14,
                                child: Center(
                                  child: Text(
                                    "${item.imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).throttle(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myPageSuccessProfile(UserInformationItemModel data, bool isFollow) {
    final isLogined = ref.watch(loginStatementProvider);

    return FlexibleSpaceBar(
      centerTitle: true,
      expandedTitleScale: 1.0,
      background: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: getProfileAvatar(data.profileImgUrl ?? "", 48, 48),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          data.isBadge == 1
                              ? Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/feed/icon/small_size/icon_special.png',
                                      height: 13,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                )
                              : Container(),
                          Expanded(
                            child: Text(
                              "${data.nick}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: data.intro != "",
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "${data.intro}",
                              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          !isLogined ? context.push("/home/login") : context.push("/member/followList/${widget.memberUuid}");
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "팔로워 ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "${data.followerCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "  ·  ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "팔로잉 ",
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                              Text(
                                "${data.followCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
              child: data.blockedMeState == 1
                  ? Expanded(
                      child: Container(
                        height: 40,
                        decoration: const BoxDecoration(
                          color: kPreviousNeutralColor300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "유저를 찾을 수 없어요.",
                            style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        data.blockedState == 1
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!isLogined) {
                                      context.push("/home/login");
                                    } else {
                                      ref.watch(userInformationStateProvider.notifier).updateUnBlockState(widget.memberUuid);

                                      final result = await ref.read(blockStateProvider.notifier).deleteBlock(
                                            blockUuid: widget.memberUuid,
                                          );

                                      if (result.result) {
                                        if (mounted) {
                                          toast(
                                            context: context,
                                            text: "'${data.nick!.length > 8 ? '${data.nick!.substring(0, 8)}...' : data.nick}'님 차단을 풀었어요.",
                                            type: ToastType.grey,
                                          );
                                        }
                                      }
                                    }

                                    // if (result.result) {
                                    //   ref
                                    //       .watch(
                                    //           userInformationStateProvider.notifier)
                                    //       .updateFollowState();
                                    // }
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: kPreviousPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "차단 풀기",
                                        style: kButton12BoldStyle.copyWith(color: kPreviousNeutralColor100),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: isFollow
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (!isLogined) {
                                            context.push("/home/login");
                                          } else {
                                            ref.watch(userInformationStateProvider.notifier).updateUnFollowState();
                                            setState(() {
                                              ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, false);
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: kPreviousNeutralColor300,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "팔로잉",
                                              style: kButton12BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (!isLogined) {
                                            context.push("/home/login");
                                          } else {
                                            ref.watch(userInformationStateProvider.notifier).updateFollowState();

                                            setState(() {
                                              ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, true);
                                            });
                                          }

                                          // if (result.result) {
                                          //   ref
                                          //       .watch(
                                          //           userInformationStateProvider.notifier)
                                          //       .updateFollowState();
                                          // }
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: kPreviousPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "팔로우",
                                              style: kButton12BoldStyle.copyWith(color: kPreviousNeutralColor100),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (data.uuid != null) {
                                final chatEnterModel = await ref.read(chatRoomListStateProvider.notifier).enterChatRoom(
                                      targetMemberUuid: data.uuid!,
                                      titleName: data.nick ?? 'unknown',
                                      targetProfileImgUrl: data.profileImgUrl ?? '',
                                    );
                                // final chatEnterModel = await ref.read(chatRoomListStateProvider.notifier).createChatRoom(targetMemberUuid: data.uuid!);
                                //
                                // if (mounted) {
                                //   context.push('/chatHome/chatRoom', extra: {
                                //     'roomId': chatEnterModel.roomId,
                                //     'nick': data.nick,
                                //     'profileImgUrl': data.profileImgUrl,
                                //     'targetMemberUuid': data.uuid,
                                //   });
                                // }
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                color: kPreviousPrimaryLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "메시지",
                                  style: kButton12BoldStyle.copyWith(color: kPreviousPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            ///NOTE
            ///2023.11.16.
            ///산책하기 보류로 주석 처리
            // ref.watch(myPetListStateProvider).itemList == null
            //     ? Container()
            //     : Padding(
            //         padding: const EdgeInsets.only(left: 12.0, bottom: 10, top: 6),
            //         child: Row(
            //           children: [
            //             Text(
            //               widget.nick.length > 15 ? '${widget.nick.substring(0, 15)}...님의 아이들' : "${widget.nick}님의 아이들",
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //               style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
            //             ),
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               ref.watch(myPetListStateProvider).itemList!.length > 99 ? "99+" : "${ref.watch(myPetListStateProvider).itemList?.length}",
            //               style: kBody13RegularStyle.copyWith(color: kTextBodyColor),
            //             ),
            //           ],
            //         ),
            //       ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 8.0),
            //     child: PagedListView<int, MyPetItemModel>(
            //       scrollDirection: Axis.horizontal,
            //       pagingController: _myPetListPagingController,
            //       builderDelegate: PagedChildBuilderDelegate<MyPetItemModel>(
            //         noItemsFoundIndicatorBuilder: (context) {
            //           return const SizedBox.shrink();
            //         },
            //         noMoreItemsIndicatorBuilder: (context) {
            //           return const SizedBox.shrink();
            //         },
            //         newPageProgressIndicatorBuilder: (context) {
            //           return Column(
            //             children: [
            //               Lottie.asset(
            //                 'assets/lottie/icon_loading.json',
            //                 fit: BoxFit.fill,
            //                 width: 80,
            //                 height: 80,
            //               ),
            //             ],
            //           );
            //         },
            //         firstPageProgressIndicatorBuilder: (context) {
            //           return Container();
            //         },
            //         itemBuilder: (context, item, index) {
            //           return InkWell(
            //             onTap: () {
            //               ///NOTE
            //               ///2023.11.14.
            //               ///산책하기 보류로 주석 처리
            //               // Navigator.push(
            //               //   context,
            //               //   MaterialPageRoute(
            //               //     builder: (_) => UserPetDetailScreen(
            //               //       itemModel: item,
            //               //     ),
            //               //   ),
            //               // );
            //               ///산책하기 보류로 주석 처리 완료
            //             },
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            //                   child: WidgetMask(
            //                     blendMode: BlendMode.srcATop,
            //                     childSaveLayer: true,
            //                     mask: Center(
            //                       child: item.url == null || item.url == ""
            //                           ? const Center(
            //                               child: Icon(
            //                                 Puppycat_social.icon_profile_large,
            //                                 size: 48,
            //                                 color: kNeutralColor500,
            //                               ),
            //                             )
            //                           : Image.network(
            //                               Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.url}").toUrl(),
            //                               width: 48,
            //                               height: 48,
            //                               fit: BoxFit.cover,
            //                             ),
            //                     ),
            //                     child: SvgPicture.asset(
            //                       'assets/image/feed/image/squircle.svg',
            //                       height: 48,
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(top: 6.0),
            //                   child: Text(
            //                     "${item.name!.length > 5 ? item.name!.substring(0, 5) + '...' : item.name}",
            //                     maxLines: 1,
            //                     overflow: TextOverflow.ellipsis,
            //                     style: kBody11RegularStyle.copyWith(color: kTextTitleColor),
            //                   ),
            //                 )
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            ///산책하기 보류로 주석 처리 완료
          ],
        ),
      ),
    );
  }
}

PopupMenuItem diaryPopUpMenuItem(
  String title,
  String value,
  Widget icon,
  BuildContext context,
) {
  return PopupMenuItem(
    value: title,
    child: Center(
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            value,
            style: kButton12BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
          ),
        ],
      ),
    ),
  );
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final double tabBarHeight;

  const TabBarDelegate({this.tabBarHeight = 48});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(builder: (ctx, ref, child) {
      final userInformationItemModel = ref.watch(userInformationStateProvider);

      return Container(
        height: tabBarHeight,
        decoration: shrinkOffset == 0
            ? const BoxDecoration(
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
              )
            : const BoxDecoration(
                color: Colors.white,
              ),
        child: userInformationItemModel.blockedState == 1 || userInformationItemModel.blockedMeState == 1
            ? Container()
            : Row(
                children: [
                  Expanded(
                    child: TabBar(
                        indicatorWeight: 2.4,
                        labelColor: kPreviousNeutralColor600,
                        indicatorColor: kPreviousNeutralColor600,
                        unselectedLabelColor: kPreviousNeutralColor500,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        tabs: [
                          Tab(
                            child: Consumer(builder: (context, ref, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "일상글",
                                    style: kTitle16BoldStyle,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "${ref.watch(userContentsFeedTotalCountProvider)}",
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
                                    "태그됨",
                                    style: kTitle16BoldStyle,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "${ref.watch(userTagContentsFeedTotalCountProvider)}",
                                    style: kBody13RegularStyle.copyWith(color: kTextTertiary),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ]),
                  ),
                ],
              ),
      );
    });
  }

  @override
  double get maxExtent {
    return tabBarHeight;
  }

  @override
  double get minExtent {
    return tabBarHeight;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
