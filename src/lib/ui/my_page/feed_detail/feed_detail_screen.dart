import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_focus_index.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_detail_state.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/first_feed_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed_search/feed_search_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/tag_contents/tag_contents_state_provider.dart';
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

  FeedDetailScreen({
    required this.firstTitle,
    required this.secondTitle,
    required this.memberIdx,
    required this.contentIdx,
    required this.contentType,
    this.isRouteComment = false,
    this.commentFocusIndex,
    super.key,
  });

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<FeedDetailScreen> {
  late final PagingController<int, FeedData> _firstFeedPagingController = ref.read(firstFeedStateProvider);

  late final PagingController<int, FeedData> _feedListPagingController = ref.read(feedListStateProvider);

  @override
  void initState() {
    ref.read(firstFeedStateProvider.notifier).apiStatus = ListAPIStatus.idle;
    ref.read(firstFeedStateProvider.notifier).loginMemberIdx = ref.read(userInfoProvider).userModel?.idx;
    ref.read(feedListStateProvider.notifier).loginMemberIdx = ref.read(userInfoProvider).userModel?.idx;

    ref.read(firstFeedStateProvider.notifier).contentType = widget.contentType;
    ref.read(firstFeedStateProvider.notifier).contentIdx = widget.contentIdx;
    ref.read(feedListStateProvider.notifier).contentType = widget.contentType;
    ref.read(feedListStateProvider.notifier).memberIdx = widget.memberIdx;
    ref.read(feedListStateProvider.notifier).searchWord = widget.secondTitle;
    ref.read(feedListStateProvider.notifier).idxToRemove = widget.contentIdx;

    _firstFeedPagingController.refresh();

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

        ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

        ref.read(userContentStateProvider.notifier).getStateForUserContent(widget.memberIdx);

        ref.read(tagContentStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);
      },
      child: Consumer(builder: (ctx, ref, child) {
        final contentState = ref.watch(firstFeedStateProvider.notifier);
        var apiStatus = contentState.apiStatus;

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
                          widget.contentType != "notificationContent" ? widget.firstTitle : ref.read(firstFeedStateProvider.notifier).memberInfo?[0].nick ?? '',
                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                        ),
                        Text(widget.secondTitle),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

                  ref.read(userContentStateProvider.notifier).getStateForUserContent(widget.memberIdx);

                  ref.read(tagContentStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);
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
                widget.contentType == "userContent" && ref.watch(firstFeedStateProvider).itemList![0].memberIdx != ref.read(userInfoProvider).userModel?.idx
                    ? ref.watch(firstFeedStateProvider).itemList![0].followState == 1
                        ? InkWell(
                            onTap: () {
                              ref.read(userInfoProvider).userModel == null
                                  ? context.pushReplacement("/loginScreen")
                                  : ref.watch(firstFeedStateProvider.notifier).deleteFollow(
                                        memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                        followIdx: ref.watch(firstFeedStateProvider).itemList![0].memberIdx!,
                                      );
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
                            onTap: () {
                              ref.read(userInfoProvider).userModel == null
                                  ? context.pushReplacement("/loginScreen")
                                  : ref.watch(firstFeedStateProvider.notifier).postFollow(
                                        memberIdx: ref.read(userInfoProvider).userModel!.idx,
                                        followIdx: ref.watch(firstFeedStateProvider).itemList![0].memberIdx!,
                                      );
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
                          widget.contentType != "notificationContent" ? widget.firstTitle : ref.read(firstFeedStateProvider.notifier).memberInfo?[0].nick ?? '',
                          style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                        ),
                        Text(widget.secondTitle),
                      ],
                    ),
              leading: IconButton(
                onPressed: () {
                  ref.read(feedSearchStateProvider.notifier).getStateForContent(widget.secondTitle ?? "");

                  ref.read(userInformationStateProvider.notifier).getStateForUserInformation(widget.memberIdx);

                  ref.read(userContentStateProvider.notifier).getStateForUserContent(widget.memberIdx);

                  ref.read(tagContentStateProvider.notifier).getStateForUserTagContent(widget.memberIdx);
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

        return Scaffold(
          appBar: appBarWidget(),
          body: CustomScrollView(
            slivers: <Widget>[
              PagedSliverList<int, FeedData>(
                shrinkWrapFirstPageIndicators: true,
                pagingController: _firstFeedPagingController,
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
                    return Column(
                      children: [
                        FeedDetailWidget(
                          feedData: item,
                          nick: item.memberInfoList != null ? item.memberInfoList![0].nick : ref.read(firstFeedStateProvider.notifier).memberInfo?[0].nick,
                          profileImage: item.memberInfoList != null ? item.memberInfoList![0].profileImgUrl : ref.watch(firstFeedStateProvider.notifier).memberInfo?[0].profileImgUrl ?? "",
                          memberIdx: item.memberInfoList != null ? item.memberInfoList![0].memberIdx : ref.read(firstFeedStateProvider.notifier).memberInfo?[0].memberIdx,
                          contentType: widget.contentType,
                          imgDomain: ref.watch(firstFeedStateProvider.notifier).imgDomain!,
                          index: index,
                        ),
                      ],
                    );
                  },
                ),
              ),
              PagedSliverList<int, FeedData>(
                shrinkWrapFirstPageIndicators: true,
                pagingController: _feedListPagingController,
                builderDelegate: PagedChildBuilderDelegate<FeedData>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return const SizedBox.shrink();
                  },
                  noMoreItemsIndicatorBuilder: (context) {
                    return widget.contentType == "userContent"
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
                                "${ref.read(firstFeedStateProvider.notifier).memberInfo?[0].nick} 님의\n게시물을 모두 확인했어요!",
                                textAlign: TextAlign.center,
                                style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "다른 유저의 게시물도 보시겠어요?",
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
                                            initialTabIndex: ref.read(userInfoProvider).userModel == null ? 0 : 2,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "다른 유저 게시물 볼래요",
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
                            profileImage: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].profileImgUrl : ref.watch(feedListStateProvider.notifier).memberInfo?[0].profileImgUrl ?? "",
                            memberIdx: (item.memberInfoList!.isNotEmpty) ? item.memberInfoList![0].memberIdx : ref.read(feedListStateProvider.notifier).memberInfo?[0].memberIdx,
                            contentType: widget.contentType,
                            imgDomain: ref.watch(feedListStateProvider.notifier).imgDomain!,
                            index: index),
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
  }
}
