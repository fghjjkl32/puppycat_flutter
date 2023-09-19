import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:matrix/matrix.dart' hide Visibility;
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/block/block_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/content_like_user_list/content_like_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

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
  ScrollController scrollController = ScrollController();
  ScrollController userContentController = ScrollController();
  ScrollController tagContentController = ScrollController();
  ScrollController commentController = ScrollController();

  bool showLottieAnimation = false;

  late TabController tabController;
  Color appBarColor = Colors.transparent;
  int userOldLength = 0;
  int tagOldLength = 0;
  int commentOldLength = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

    ref.read(feedListStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);
    ref.read(firstFeedStateProvider.notifier).saveStateForUser(widget.oldMemberIdx);

    userContentController.addListener(_userContentsScrollListener);
    tagContentController.addListener(_tagContentsScrollListener);
    commentController.addListener(_commentScrollListener);

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    Future(() {
      ref.watch(userInformationStateProvider.notifier).getInitUserInformation(ref.watch(userInfoProvider).userModel?.idx, widget.memberIdx);
      ref.read(userContentStateProvider.notifier).initPosts(ref.read(userInfoProvider).userModel?.idx, widget.memberIdx, 1);
      ref.read(tagContentStateProvider.notifier).initPosts(ref.read(userInfoProvider).userModel?.idx, widget.memberIdx, 1);
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

  void _userContentsScrollListener() {
    if (userContentController.position.pixels > userContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (userOldLength == ref.read(userContentStateProvider).list.length) {
        ref.read(userContentStateProvider.notifier).loadMorePost(ref.read(userInfoProvider).userModel!.idx, widget.memberIdx);
      }
    }
  }

  void _tagContentsScrollListener() {
    if (tagContentController.position.pixels > tagContentController.position.maxScrollExtent - MediaQuery.of(context).size.height) {
      if (tagOldLength == ref.read(tagContentStateProvider).list.length) {
        ref.read(tagContentStateProvider.notifier).loadMorePost(ref.read(userInfoProvider).userModel!.idx, widget.memberIdx);
      }
    }
  }

  void _commentScrollListener() {
    if (commentController.position.extentAfter < 200) {
      if (commentOldLength == ref.read(commentStateProvider).list.length) {
        ref.read(commentStateProvider.notifier).loadMoreComment(ref.watch(commentStateProvider).list[0].contentsIdx, ref.read(userInfoProvider).userModel!.idx);
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    userContentController.removeListener(_userContentsScrollListener);
    userContentController.dispose();
    tagContentController.removeListener(_userContentsScrollListener);
    tagContentController.dispose();
    commentController.removeListener(_commentScrollListener);
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () async {
        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
        ref.read(firstFeedStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
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
                SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: appBarColor,
                    title: Text(widget.nick),
                    leading: IconButton(
                      onPressed: () {
                        ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
                        ref.read(firstFeedStateProvider.notifier).getStateForUser(widget.oldMemberIdx ?? 0);
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
                                                        "‘${widget.nick}’님은 더 이상 회원님의\n게시물을 보거나 메시지 등을 보낼 수 없습니다.",
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
                                                    text: "‘${widget.nick}’님을 차단하였습니다.",
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
                    expandedHeight: 146.h,
                    flexibleSpace: Consumer(builder: (context, ref, _) {
                      final userInformationState = ref.watch(userInformationStateProvider);
                      final lists = userInformationState.list;

                      return lists.isEmpty ? Container() : _myPageSuccessProfile(lists[0]);
                    })),
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
    return Consumer(
      builder: (ctx, ref, child) {
        final myContentState = ref.watch(userContentStateProvider);
        final isLoadMoreError = myContentState.isLoadMoreError;
        final isLoadMoreDone = myContentState.isLoadMoreDone;
        final isLoading = myContentState.isLoading;
        final lists = myContentState.list;

        userOldLength = lists.length ?? 0;

        return lists.isEmpty
            ? Container(
                color: kNeutralColor100,
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
                        '게시물이 없습니다.',
                        textAlign: TextAlign.center,
                        style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return ref.read(userContentStateProvider.notifier).refresh(
                        ref.read(userInfoProvider).userModel?.idx,
                        widget.memberIdx,
                      );
                },
                child: Container(
                  color: kNeutralColor100,
                  child: GridView.builder(
                    controller: userContentController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: lists.length,
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

                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                                "/home/myPage/detail/${ref.watch(userInformationStateProvider).list[0].nick}/게시물/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${lists[index].idx}/userContent");
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
                                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${lists[index].imgUrl}").toUrl(),
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
                                        '${lists[index].imageCnt}',
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
              );
      },
    );
  }

  Widget _secondTabBody() {
    return Consumer(
      builder: (ctx, ref, child) {
        final tagContentState = ref.watch(tagContentStateProvider);
        final isLoadMoreError = tagContentState.isLoadMoreError;
        final isLoadMoreDone = tagContentState.isLoadMoreDone;
        final isLoading = tagContentState.isLoading;
        final lists = tagContentState.list;

        tagOldLength = lists.length ?? 0;

        return RefreshIndicator(
          onRefresh: () {
            return ref.read(tagContentStateProvider.notifier).refresh(
                  ref.read(userInfoProvider).userModel?.idx,
                  widget.memberIdx,
                );
          },
          child: lists.isEmpty
              ? Container(
                  color: kNeutralColor100,
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
                          '게시물이 없습니다.',
                          textAlign: TextAlign.center,
                          style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  color: kNeutralColor100,
                  child: GridView.builder(
                    controller: tagContentController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: lists.length,
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

                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                                "/home/myPage/detail/${ref.watch(userInformationStateProvider).list[0].nick}/태그됨/${ref.watch(userInformationStateProvider).list[0].memberIdx}/${lists[index].idx}/userTagContent");
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
                                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain${lists[index].imgUrl}").toUrl(),
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
                                        "${lists[index].imageCnt}",
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
        );
      },
    );
  }

  Widget _myPageSuccessProfile(UserInformationItemModel data) {
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
                Column(
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
                        Text(
                          "${data.nick}",
                          style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h),
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
                                      await ref.read(blockStateProvider.notifier).deleteBlock(
                                            memberIdx: ref.watch(userInfoProvider).userModel!.idx,
                                            blockIdx: widget.memberIdx,
                                          );
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
                                child: data.followState == 1
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (ref.read(userInfoProvider).userModel == null) {
                                            context.pushReplacement("/loginScreen");
                                          } else {
                                            ref.watch(userInformationStateProvider.notifier).updateUnFollowState();
                                            await ref.watch(followStateProvider.notifier).deleteFollow(
                                                  memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                  followIdx: widget.memberIdx,
                                                );
                                          }

                                          // if (result.result) {
                                          //   ref
                                          //       .watch(
                                          //           userInformationStateProvider.notifier)
                                          //       .updateUnFollowState();
                                          // }
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
                                          if (ref.read(userInfoProvider).userModel == null) {
                                            context.pushReplacement("/loginScreen");
                                          } else {
                                            ref.watch(userInformationStateProvider.notifier).updateFollowState();
                                            await ref.watch(followStateProvider.notifier).postFollow(
                                                  memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                                  followIdx: widget.memberIdx,
                                                );
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
                              if (data.chatMemberId != null) {
                                ChatController chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${data.memberIdx}')));

                                var roomId = await chatController.client.startDirectChat(data.chatMemberId!, enableEncryption: false);

                                Room? room = chatController.client.rooms.firstWhereOrNull((element) => element.id == roomId);

                                if (mounted) {
                                  ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.push('/chatMain/chatRoom', extra: room);
                                }
                              }
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
            )
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
                                        "${ref.watch(userContentStateProvider).totalCount}",
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
                                        "${ref.watch(tagContentStateProvider).totalCount}",
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
