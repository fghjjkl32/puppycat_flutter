import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/first_feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/feed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/tag_contents/user_tag_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_contents/user_contents_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user_information/user_information_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/feed_detail_widget.dart';

class FeedDetailScreen extends ConsumerStatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final String memberUuid;
  final int contentIdx;
  final String contentType;
  bool isRouteComment;
  int? commentFocusIndex;
  String oldMemberUuid;

  FeedDetailScreen({
    required this.firstTitle,
    required this.secondTitle,
    required this.memberUuid,
    required this.contentIdx,
    required this.contentType,
    this.isRouteComment = false,
    this.commentFocusIndex,
    this.oldMemberUuid = '',
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
    ref.read(feedListStateProvider.notifier).contentType = widget.contentType;
    ref.read(feedListStateProvider.notifier).memberUuid = widget.memberUuid;
    ref.read(feedListStateProvider.notifier).searchWord = widget.secondTitle;
    ref.read(feedListStateProvider.notifier).firstFeedIdx = widget.contentIdx;

    _fetchFirstFeedDataFuture = _fetchFirstFeedData();

    _feedListPagingController.refresh();

    super.initState();

    print('11111111111111111111111111111');

    if (widget.isRouteComment) {
      Future(() {
        print('widget.commentFocusIndex ${widget.commentFocusIndex}');
        context.push("/feed/comment/${widget.contentIdx}/${widget.memberUuid == "" ? null : widget.memberUuid}", extra: {
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
      if (firstFeedData.idx != widget.contentIdx) {
        return ref.read(firstFeedDetailStateProvider.notifier).getFirstFeedState(widget.contentType, widget.contentIdx);
      }
      return firstFeedData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFollow = ref.watch(followUserStateProvider)[widget.memberUuid] ?? false;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return DefaultOnWillPopScope(
      onWillPop: () {
        ref.read(firstFeedDetailStateProvider.notifier).state = null;

        ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

        ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberUuid);

        ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberUuid);

        ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberUuid);

        if (widget.contentType == "FollowCardContent") {
          ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
          ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
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
                      style: kTitle18BoldStyle,
                    )
                  : Column(
                      children: [
                        Text(
                          widget.contentType != "notificationContent" ? widget.firstTitle : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick ?? '',
                          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                        Text(
                          widget.secondTitle,
                          style: kTitle16BoldStyle,
                        ),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(firstFeedDetailStateProvider.notifier).state = null;

                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberUuid);

                  ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberUuid);

                  ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberUuid);

                  if (widget.contentType == "FollowCardContent") {
                    ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                    ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                  }

                  context.pop();
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
                (widget.contentType == "userContent" || widget.contentType == "FollowCardContent") && ref.read(firstFeedDetailStateProvider)?.memberUuid != myInfo.uuid
                    ? isFollow
                        ? InkWell(
                            onTap: () async {
                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                if (!isLogined) {
                                  context.push("/home/login");
                                } else {
                                  final result = await ref.watch(followStateProvider.notifier).deleteFollow(
                                        followUuid: widget.memberUuid,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, false);
                                    });
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "팔로잉",
                                style: kTitle14BoldStyle.copyWith(color: kPreviousNeutralColor500),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              if (!ref.watch(followApiIsLoadingStateProvider)) {
                                if (!isLogined) {
                                  context.push("/home/login");
                                } else {
                                  final result = await ref.watch(followStateProvider.notifier).postFollow(
                                        followUuid: widget.memberUuid,
                                      );

                                  if (result.result) {
                                    setState(() {
                                      ref.read(followUserStateProvider.notifier).setFollowState(widget.memberUuid, true);
                                    });
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "팔로우",
                                style: kTitle14BoldStyle.copyWith(color: kTextActionPrimary),
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
                          style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                        Text(widget.secondTitle),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberUuid);

                  ref.read(userContentsStateProvider.notifier).getStateForUserContent(widget.memberUuid);

                  ref.read(userTagContentsStateProvider.notifier).getStateForUserTagContent(widget.memberUuid);

                  if (widget.contentType == "FollowCardContent") {
                    ref.read(feedListStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                    ref.read(firstFeedDetailStateProvider.notifier).getStateForUser(widget.oldMemberUuid);
                  }

                  context.pop();
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

                // if (firstFeedData == null) {
                //   return const Text('error2');
                // }

                return CustomScrollView(
                  slivers: <Widget>[
                    if (firstFeedData != null)
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return FeedDetailWidget(
                              feedData: firstFeedData,
                              nick: firstFeedData.memberInfo != null ? firstFeedData.memberInfo!.nick : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick,
                              profileImage:
                                  firstFeedData.memberInfo != null ? firstFeedData.memberInfo!.profileImgUrl : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.profileImgUrl ?? "",
                              memberUuid: firstFeedData.memberInfo != null ? firstFeedData.memberInfo!.uuid! : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.uuid ?? '',
                              contentType: widget.contentType,
                              index: 0,
                              isSpecialUser: firstFeedData.memberInfo != null ? firstFeedData.memberInfo!.isBadge == 1 : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.isBadge == 1,
                              onTapHideButton: () async {
                                onTapHide(
                                  context: context,
                                  ref: ref,
                                  contentType: widget.contentType,
                                  contentIdx: widget.contentIdx,
                                  memberUuid: firstFeedData.memberInfo != null ? firstFeedData.memberInfo!.uuid! : ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.uuid ?? '',
                                );
                              },
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    PagedSliverList<int, FeedData>(
                      // shrinkWrapFirstPageIndicators: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
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
                                            '피드가 없어요.',
                                            textAlign: TextAlign.center,
                                            style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : widget.memberUuid != myInfo.uuid && widget.contentType != "searchContent"
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Lottie.asset(
                                          'assets/lottie/feed_end.json',
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.fill,
                                          repeat: false,
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          "대단해요!\n${ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick}님의 피드를 모두 확인했어요!",
                                          textAlign: TextAlign.center,
                                          style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "다른 유저의 피드도 보러 갈까요?",
                                          textAlign: TextAlign.center,
                                          style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Material(
                                          child: Container(
                                            color: kPreviousNeutralColor100,
                                            child: GestureDetector(
                                              onTap: () {
                                                context.pushReplacement("/home", extra: {
                                                  "initialTabIndex": !isLogined ? 0 : 1,
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Text(
                                                  "다른 피드 보러 가기",
                                                  textAlign: TextAlign.center,
                                                  style: kBody12SemiBoldStyle.copyWith(color: kPreviousPrimaryColor),
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
                          return widget.memberUuid != myInfo.uuid && widget.contentType != "searchContent"
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
                                      "대단해요!\n${ref.read(firstFeedDetailStateProvider.notifier).memberInfo?.nick}님의 피드를 모두 확인했어요!",
                                      textAlign: TextAlign.center,
                                      style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "다른 유저의 피드도 보러 갈까요?",
                                      textAlign: TextAlign.center,
                                      style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Material(
                                      child: Container(
                                        color: kPreviousNeutralColor100,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pushReplacement("/home", extra: {
                                              "initialTabIndex": !isLogined ? 0 : 1,
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              "다른 피드 보러 가기",
                                              textAlign: TextAlign.center,
                                              style: kBody12SemiBoldStyle.copyWith(color: kPreviousPrimaryColor),
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
                                nick: (item.memberInfo != null) ? item.memberInfo!.nick : ref.read(feedListStateProvider.notifier).memberInfo?.nick,
                                profileImage: (item.memberInfo != null) ? item.memberInfo!.profileImgUrl : ref.watch(feedListStateProvider.notifier).memberInfo?.profileImgUrl ?? "",
                                memberUuid: (item.memberInfo != null) ? item.memberInfo!.uuid! : ref.read(feedListStateProvider.notifier).memberInfo?.uuid ?? '',
                                contentType: widget.contentType,
                                index: index,
                                isSpecialUser: (item.memberInfo != null) ? item.memberInfo!.isBadge == 1 : ref.read(feedListStateProvider.notifier).memberInfo?.isBadge == 1,
                                onTapHideButton: () async {
                                  onTapHide(
                                    context: context,
                                    ref: ref,
                                    contentType: widget.contentType,
                                    contentIdx: item.idx,
                                    memberUuid: (item.memberInfo != null) ? item.memberInfo!.uuid! : ref.read(feedListStateProvider.notifier).memberInfo?.uuid ?? '',
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        );
      }),
    );
  }
}
