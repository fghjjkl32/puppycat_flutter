import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/block/block_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
///NOTE
///2023.11.16.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/providers/my_page/my_pet/my_pet_list/my_pet_list_state_provider.dart';
///산책하기 보류로 주석 처리 완료
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/user_pet_detail_screen.dart';
///산책하기 보류로 주석 처리 완료
import 'package:thumbor/thumbor.dart';

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({
    super.key,
    required this.memberIdx,
    required this.nick,
    required this.oldMemberIdx,
  });

  final int memberIdx;
  final String nick;
  final int oldMemberIdx;

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
    ref.read(userContentsStateProvider.notifier).memberIdx = widget.memberIdx;
    ref.read(userTagContentsStateProvider.notifier).memberIdx = widget.memberIdx;

    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);
    ref.read(firstFeedDetailStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    Future(() async {
      ref.watch(userInformationStateProvider.notifier).getInitUserInformation(ref.watch(userInfoProvider).userModel?.idx, widget.memberIdx);
      _userContentsListPagingController.refresh();
      _userTagContentsListPagingController.refresh();
    });

    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= 128.h && appBarColor != kNeutralColor100) {
      setState(() {
        appBarColor = kNeutralColor100;
      });
    } else if (scrollController.offset < 128.h && appBarColor != Colors.transparent) {
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
    return DefaultOnWillPopScope(
      onWillPop: () async {
        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
        ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
        return Future.value(true);
      },
      child: Material(
        child: SafeArea(
            child: DefaultTabController(
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
                          ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
                          ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Puppycat_social.icon_back,
                          size: 40,
                        ),
                      ),
                      forceElevated: innerBoxIsScrolled,
                      actions: [
                        Consumer(builder: (context, ref, _) {
                          final userInformationState = ref.watch(userInformationStateProvider);
                          final lists = userInformationState.list;

                          return lists.isEmpty
                              ? Container()
                              : lists[0].blockedState == 1 || lists[0].blockedMeState == 1
                                  ? Container()
                                  : PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      offset: Offset(0, 42),
                                      child: showLottieAnimation
                                          ? Lottie.asset(
                                              'assets/lottie/icon_more_header.json',
                                              repeat: false,
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: const Icon(
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
                                          if (ref.read(userInfoProvider).userModel == null) {
                                            context.pushReplacement("/loginScreen");
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialog(
                                                  content: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 24.0.h),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "‘${widget.nick}’님을\n차단하시겠어요?",
                                                          style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text(
                                                          "‘${widget.nick}’님은 더 이상 회원님의\n피드를 보거나 메시지 등을 보낼 수 없습니다.",
                                                          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Text(
                                                          " ‘${widget.nick}’님에게는 차단 정보를 알리지 않으며\n[마이페이지 → 설정 → 차단 유저 관리] 에서\n언제든지 해제할 수 있습니다.",
                                                          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  confirmTap: () async {
                                                    context.pop();
                                                    toast(
                                                      context: context,
                                                      text: "'${widget.nick.length > 8 ? '${widget.nick.substring(0, 8)}...' : widget.nick}'님을 차단하였습니다.",
                                                      type: ToastType.purple,
                                                    );
                                                    final result = await ref.read(userInformationStateProvider.notifier).postBlock(
                                                          memberIdx: ref.watch(userInfoProvider).userModel!.idx,
                                                          blockIdx: widget.memberIdx,
                                                        );

                                                    if (result.result) {
                                                      ref.watch(userInformationStateProvider.notifier).updateBlockState();
                                                    }
                                                  },
                                                  cancelTap: () {
                                                    context.pop();
                                                  },
                                                  confirmWidget: Text(
                                                    "프로필 차단",
                                                    style: kButton14MediumStyle.copyWith(color: kBadgeColor),
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
                      expandedHeight: 210,

                      ///산책하기 보류로 주석 처리 완료
                      flexibleSpace: Consumer(builder: (context, ref, _) {
                        final userInformationState = ref.watch(userInformationStateProvider);
                        final lists = userInformationState.list;

                        final isFollow = ref.watch(followUserStateProvider)[widget.memberIdx] ?? false;

                        return lists.isEmpty ? Container() : _myPageSuccessProfile(lists[0], isFollow);
                      }));
                }),
                const SliverPersistentHeader(
                  delegate: TabBarDelegate(),
                  pinned: true,
                ),
              ];
            },
            body: Consumer(builder: (context, ref, _) {
              final userInformationState = ref.watch(userInformationStateProvider);
              final lists = userInformationState.list;

              return lists.isEmpty
                  ? Container()
                  : lists[0].blockedState == 1
                      ? Container(
                          color: kNeutralColor100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image/character/character_07_block_88 (1).png',
                                height: 68.h,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "차단한 유저의 정보는 확인할 수 없습니다.\n정보를 보시려면 차단을 해제해 주세요.",
                                textAlign: TextAlign.center,
                                style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                            ],
                          ),
                        )
                      : lists[0].blockedMeState == 1
                          ? Container(
                              color: kNeutralColor100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'character_07_block_me_88.png',
                                    height: 68.h,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "정보를 확인할 수 없습니다.",
                                    textAlign: TextAlign.center,
                                    style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
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
        )),
      ),
    );
  }

  Widget _firstTabBody() {
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          if (widget.oldMemberIdx != ref.watch(userInfoProvider).userModel?.idx) {
            if (widget.oldMemberIdx == 0) return;
            ref.read(userContentsStateProvider.notifier).memberIdx = widget.oldMemberIdx;
          }

          _userContentsListPagingController.refresh();
        });
      },
      child: Container(
        color: kNeutralColor100,
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
                                  '피드가 없습니다.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                            "/home/myPage/detail/${ref.watch(userInformationStateProvider).list[0].nick}/피드/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${item.idx}/userContent");
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kNeutralColor300,
                                  ),
                                  imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.imgUrl}").toUrl(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 30,
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
                              right: 6.w,
                              top: 6.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18.w,
                                height: 14.w,
                                child: Center(
                                  child: Text(
                                    '${item.imageCnt}',
                                    style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    return RefreshIndicator(
      onRefresh: () {
        return Future(() {
          if (widget.oldMemberIdx != ref.watch(userInfoProvider).userModel?.idx) {
            if (widget.oldMemberIdx == 0) return;
            ref.read(userTagContentsStateProvider.notifier).memberIdx = widget.oldMemberIdx;
          }
          _userTagContentsListPagingController.refresh();
        });
      },
      child: Container(
        color: kNeutralColor100,
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
                                  '피드가 없습니다.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
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
                itemBuilder: (context, item, itemBuilderIndex) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                            "/home/myPage/detail/${ref.watch(userInformationStateProvider).list[0].nick}/태그됨/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${item.idx}/userTagContent");
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    color: kNeutralColor300,
                                  ),
                                  imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${item.imgUrl}").toUrl(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6.w,
                              top: 6.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                ),
                                width: 18.w,
                                height: 14.w,
                                child: Center(
                                  child: Text(
                                    "${item.imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: getProfileAvatar(data.profileImgUrl ?? "", 48.w, 48.h),
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
                                      height: 13.h,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                  ],
                                )
                              : Container(),
                          Expanded(
                            child: Text(
                              "${data.nick}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: data.intro != "",
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "${data.intro}",
                              style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.push("/home/myPage/followList/${widget.memberIdx}");
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0.h),
                          child: Row(
                            children: [
                              Text(
                                "팔로워 ",
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              Text(
                                "${data.followerCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                              Text(
                                "  ·  ",
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              Text(
                                "팔로잉 ",
                                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                              ),
                              Text(
                                "${data.followCnt}",
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
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
              padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h, bottom: 10.h),
              child: data.blockedMeState == 1
                  ? Expanded(
                      child: Container(
                        height: 30.h,
                        decoration: const BoxDecoration(
                          color: kNeutralColor300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "유저를 찾을 수 없습니다.",
                            style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
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
                                    if (ref.read(userInfoProvider).userModel == null) {
                                      context.pushReplacement("/loginScreen");
                                    } else {
                                      ref.watch(userInformationStateProvider.notifier).updateUnBlockState(ref.watch(userInfoProvider).userModel!.idx, widget.memberIdx);

                                      final result = await ref.read(blockStateProvider.notifier).deleteBlock(
                                            memberIdx: ref.watch(userInfoProvider).userModel!.idx,
                                            blockIdx: widget.memberIdx,
                                          );

                                      if (result.result) {
                                        if (mounted) {
                                          toast(
                                            context: context,
                                            text: "'${data.nick!.length > 8 ? '${data.nick!.substring(0, 8)}...' : data.nick}'님을 차단해제하였습니다.",
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
                                    height: 30.h,
                                    decoration: const BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "차단 해제",
                                        style: kButton12BoldStyle.copyWith(color: kNeutralColor100),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: isFollow
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (!ref.watch(followApiIsLoadingStateProvider)) {
                                            if (ref.read(userInfoProvider).userModel == null) {
                                              context.pushReplacement("/loginScreen");
                                            } else {
                                              final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                                    memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                    followIdx: widget.memberIdx,
                                                  );
                                              ref.watch(userInformationStateProvider.notifier).updateUnFollowState();

                                              if (result.result) {
                                                setState(() {
                                                  ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, false);
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 30.h,
                                          decoration: const BoxDecoration(
                                            color: kNeutralColor300,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "팔로잉",
                                              style: kButton12BoldStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          if (!ref.watch(followApiIsLoadingStateProvider)) {
                                            if (ref.read(userInfoProvider).userModel == null) {
                                              context.pushReplacement("/loginScreen");
                                            } else {
                                              final result = await ref.watch(followStateProvider.notifier).postFollow(
                                                    memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                    followIdx: widget.memberIdx,
                                                  );
                                              ref.watch(userInformationStateProvider.notifier).updateFollowState();

                                              if (result.result) {
                                                setState(() {
                                                  ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, true);
                                                });
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
                                          height: 30.h,
                                          decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "팔로우",
                                              style: kButton12BoldStyle.copyWith(color: kNeutralColor100),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              ///NOTE
                              ///2023.11.17.
                              ///채팅 교체 예정으로 일단 주석 처리
                              // if (data.chatMemberId != null) {
                              //   ChatController chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${data.memberIdx}')));
                              //
                              //   var roomId = await chatController.client.startDirectChat(data.chatMemberId!, enableEncryption: false);
                              //
                              //   Room? room = chatController.client.rooms.firstWhereOrNull((element) => element.id == roomId);
                              //
                              //   if (mounted) {
                              //     ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.push('/chatMain/chatRoom', extra: room);
                              //   }
                              // }
                              ///여기까지 채팅 교체 주석
                            },
                            child: Container(
                              height: 30.h,
                              decoration: const BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "메시지",
                                  style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
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
          SizedBox(
            width: 10.w,
          ),
          Text(
            value,
            style: kButton12BoldStyle.copyWith(color: kTextSubTitleColor),
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
      final userInformationState = ref.watch(userInformationStateProvider);
      final lists = userInformationState.list;

      return lists.isEmpty
          ? Container()
          : Container(
              height: tabBarHeight,
              decoration: shrinkOffset == 0
                  ? BoxDecoration(
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
                    )
                  : const BoxDecoration(
                      color: Colors.white,
                    ),
              child: lists[0].blockedState == 1 || lists[0].blockedMeState == 1
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: TabBar(
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
                                        "${ref.watch(userContentsFeedTotalCountProvider)}",
                                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                      ),
                                    ],
                                  );
                                }),
                                Consumer(builder: (context, ref, child) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "태그됨",
                                        style: kBody14BoldStyle,
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Text(
                                        "${ref.watch(userTagContentsFeedTotalCountProvider)}",
                                        style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                      ),
                                    ],
                                  );
                                }),
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
