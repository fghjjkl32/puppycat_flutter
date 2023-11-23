import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed_search/feed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/main/main_screen.dart';

class FeedDetailScreen extends ConsumerStatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final int memberIdx;
  final int contentIdx;
  final String contentType;
  bool isRouteComment;
  int? commentFocusIndex;
  int oldMemberIdx;

  FeedDetailScreen({
    required this.firstTitle,
    required this.secondTitle,
    required this.memberIdx,
    required this.contentIdx,
    required this.contentType,
    this.isRouteComment = false,
    this.commentFocusIndex,
    this.oldMemberIdx = 0,
    super.key,
  });

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<FeedDetailScreen> {
  late final PagingController<int, FeedData> _feedListPagingController = ref.read(feedListStateProvider);
  late Future _fetchFirstFeedDataFuture;

  @override
  void initState() {
    ref.read(feedListStateProvider.notifier).loginMemberIdx = ref.read(userInfoProvider).userModel?.idx;

    ref.read(feedListStateProvider.notifier).contentType = widget.contentType;
    ref.read(feedListStateProvider.notifier).memberIdx = widget.memberIdx;
    ref.read(feedListStateProvider.notifier).searchWord = widget.secondTitle;
    ref.read(feedListStateProvider.notifier).idxToRemove = widget.contentIdx;

    _fetchFirstFeedDataFuture = _fetchFirstFeedData();

    _feedListPagingController.refresh();

    super.initState();

    if (widget.isRouteComment) {
      Future(() {
        context.push("/home/commentDetail/${widget.contentIdx}/${widget.memberIdx}", extra: {
          "focusIndex": widget.commentFocusIndex,
        });
      });
      widget.isRouteComment = false;
    }
  }

  @override
  void didChangeDependencies() {
    // Access context safely in didChangeDependencies
    // ref.read(firstFeedDetailStateProvider.notifier).state = null;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<FeedData?> _fetchFirstFeedData() async {
    final firstFeedData = ref.read(firstFeedDetailStateProvider);
    if (firstFeedData == null) {
      return ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(widget.contentType, widget.contentIdx);
    } else {
      return firstFeedData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberIdx] ?? false;

    return DefaultOnWillPopScope(
      onWillPop: () {
        ref.read(firstFeedDetailStateProvider.notifier).state = null;

        ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

        ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

        ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberIdx);

        ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);

        if (widget.contentType == "FollowCardContent") {
          ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
          ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
        }

        return Future.value(true);
      },
      child: Consumer(builder: (ctx, ref, child) {
        var apiStatus = ref.read(firstFeedStatusProvider);

        AppBar appBarWidget() {
          if (apiStatus == ListAPIStatus.loading || apiStatus == ListAPIStatus.idle) {
            return AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: widget.firstTitle == "null"
                  ? Text(
                      widget.contentType == "searchContent" ? "#${widget.secondTitle}" : widget.secondTitle,
                    )
                  : Column(
                      children: [
                        Text(
                          widget.contentType != "notificationContent" ? widget.firstTitle : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                        ),
                        Text(widget.secondTitle),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(firstFeedDetailStateProvider.notifier).state = null;

                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

                  ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberIdx);

                  ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);

                  if (widget.contentType == "FollowCardContent") {
                    ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
                    ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
                  }

                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Puppycat_social.icon_back,
                  size: 40,
                ),
              ),
            );
          } else if (apiStatus == ListAPIStatus.loaded) {
            return AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                widget.contentType == "userContent" || widget.contentType == "FollowCardContent" && ref.read(firstFeedDetailStateProvider)?.memberIdx != ref.read(userInfoProvider).userModel?.idx
                    ? isFollow
                        ? InkWell(
                            onTap: () async {
                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                if (ref.read(userInfoProvider).userModel == null) {
                                  context.pushReplacement("/loginScreen");
                                } else {
                                  final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                        memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                        followIdx: widget.memberIdx,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, false);
                                    });
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "팔로잉",
                                style: kBody12SemiBoldStyle.copyWith(color: kNeutralColor500),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                if (ref.read(userInfoProvider).userModel == null) {
                                  context.pushReplacement("/loginScreen");
                                } else {
                                  final result = await ref.watch(followStateProvider.notifier).postFollow(
                                        memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                        followIdx: widget.memberIdx,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.memberIdx, true);
                                    });
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "팔로우",
                                style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                          )
                    : Container()
              ],
              title: widget.firstTitle == "null"
                  ? Text(
                      widget.contentType == "searchContent" ? "#${widget.secondTitle}" : widget.secondTitle,
                    )
                  : Column(
                      children: [
                        Text(
                          widget.contentType != "notificationContent" ? widget.firstTitle : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                        ),
                        Text(widget.secondTitle),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

                  ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberIdx);

                  ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);

                  if (widget.contentType == "FollowCardContent") {
                    ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
                    ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberIdx);
                  }

                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Puppycat_social.icon_back,
                  size: 40,
                ),
              ),
            );
          }
          return AppBar();
        }

        // final firstFeedProvider = ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(widget.contentType, widget.contentIdx);
        return Scaffold(
          appBar: appBarWidget(),
          body: FutureBuilder(
              // future: ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(widget.contentType, widget.contentIdx),
              future: _fetchFirstFeedDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('error');
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final firstFeedData = ref.watch(firstFeedDetailStateProvider);

                if (firstFeedData == null) {
                  return const Text('error2');
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      FeedDetailWidget(
                        feedData: firstFeedData,
                        nick: firstFeedData.memberInfoList != null ? firstFeedData.memberInfoList![0].nick : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick,
                        profileImage:
                            firstFeedData.memberInfoList != null ? firstFeedData.memberInfoList![0].profileImgUrl : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.profileImgUrl ?? "",
                        memberIdx: firstFeedData.memberInfoList != null ? firstFeedData.memberInfoList![0].memberIdx : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.memberIdx,
                        contentType: widget.contentType,
                        imgDomain: ref.read(firstFeedDetailStateProvider.notifier).feedImgDomain!,
                        index: 0,
                        isSpecialUser: firstFeedData.memberInfoList != null ? firstFeedData.memberInfoList![0].isBadge == 1 : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.isBadge == 1,
                        onTapHideButton: () async {
                          onTapHide(
                            context: context,
                            ref: ref,
                            contentType: widget.contentType,
                            contentIdx: widget.contentIdx,
                            memberIdx: firstFeedData.memberInfoList != null ? firstFeedData.memberInfoList![0].memberIdx : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.memberIdx,
                          );
                        },
                      ),
                      PagedListView<int, FeedData>(
                        // shrinkWrapFirstPageIndicators: true,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        pagingController: _feedListPagingController,
                        builderDelegate: PagedChildBuilderDelegate<FeedData>(
                          noItemsFoundIndicatorBuilder: (context) {
                            return ref.watch(firstFeedEmptyProvider)
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
                                              '등록된 피드가 없습니다.',
                                              textAlign: TextAlign.center,
                                              style: kBody13RegularStyle.copyWith(color: kTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : widget.memberIdx != ref.read(userInfoProvider).userModel?.idx && widget.contentType != "searchContent"
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Lottie.asset(
                                            'assets/lottie/feed_end.json',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.fill,
                                            repeat: false,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "${ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick} 님의\n피드를 모두 확인했어요!",
                                            textAlign: TextAlign.center,
                                            style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "다른 유저의 피드도 보시겠어요?",
                                            textAlign: TextAlign.center,
                                            style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Material(
                                            child: Container(
                                              color: kNeutralColor100,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => PuppyCatMain(
                                                        initialTabIndex: ref.read(userInfoProvider).userModel == null ? 0 : 1,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Text(
                                                    "다른 유저 피드 볼래요",
                                                    textAlign: TextAlign.center,
                                                    style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                          },
                          noMoreItemsIndicatorBuilder: (context) {
                            return widget.memberIdx != ref.read(userInfoProvider).userModel?.idx && widget.contentType != "searchContent"
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Lottie.asset(
                                        'assets/lottie/feed_end.json',
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.fill,
                                        repeat: false,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "${ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick} 님의\n피드를 모두 확인했어요!",
                                        textAlign: TextAlign.center,
                                        style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "다른 유저의 피드도 보시겠어요?",
                                        textAlign: TextAlign.center,
                                        style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Material(
                                        child: Container(
                                          color: kNeutralColor100,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => PuppyCatMain(
                                                    initialTabIndex: ref.read(userInfoProvider).userModel == null ? 0 : 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Text(
                                                "다른 유저 피드 볼래요",
                                                textAlign: TextAlign.center,
                                                style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
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
                            return Column(
                              children: [
                                FeedDetailWidget(
                                  feedData: item,
                                  nick: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].nick : ref.read(feedListStateProvider.notifier).memberInfo?[0].nick,
                                  profileImage:
                                      (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].profileImgUrl : ref.watch(feedListStateProvider.notifier).memberInfo?[0].profileImgUrl ?? "",
                                  memberIdx: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].memberIdx : ref.read(feedListStateProvider.notifier).memberInfo?[0].memberIdx,
                                  contentType: widget.contentType,
                                  imgDomain: ref.watch(feedListStateProvider.notifier).imgDomain!,
                                  index: index,
                                  isSpecialUser: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].isBadge == 1 : ref.read(feedListStateProvider.notifier).memberInfo?[0].isBadge == 1,
                                  onTapHideButton: () async {
                                    onTapHide(
                                      context: context,
                                      ref: ref,
                                      contentType: widget.contentType,
                                      contentIdx: widget.contentIdx,
                                      memberIdx: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].memberIdx : ref.read(feedListStateProvider.notifier).memberInfo?[0].memberIdx,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}
