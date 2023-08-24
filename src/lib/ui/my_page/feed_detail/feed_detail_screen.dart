import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_follow_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_focus_index.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/user_list/popular_user_list_state_provider.dart';

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
  ScrollController contentController = ScrollController();
  int oldLength = 0;

  @override
  void initState() {
    contentController.addListener(contentsScrollListener);

    ref.read(feedDetailStateProvider.notifier).initPosts(
          loginMemberIdx: ref.read(userModelProvider)?.idx,
          memberIdx: widget.memberIdx,
          initPage: 1,
          contentIdx: widget.contentIdx,
          contentType: widget.contentType,
          searchWord: widget.secondTitle,
        );
    super.initState();

    if (widget.isRouteComment) {
      Future(() {
        context.push("/home/commentDetail/${widget.contentIdx}", extra: {
          "focusIndex": widget.commentFocusIndex,
        });
      });
      widget.isRouteComment = false;
    }
  }

  void contentsScrollListener() {
    if (contentController.position.pixels >
        contentController.position.maxScrollExtent -
            MediaQuery.of(context).size.height) {
      if (oldLength ==
          ref.read(feedDetailStateProvider).feedListState.list.length) {
        ref.read(feedDetailStateProvider.notifier).loadMorePost(
              loginMemberIdx: ref.read(userModelProvider)!.idx,
              memberIdx: widget.memberIdx,
              contentType: widget.contentType,
              searchWord: widget.secondTitle,
            );
      }
    }
  }

  @override
  void dispose() {
    contentController.removeListener(contentsScrollListener);
    contentController.dispose();

    super.dispose();
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
          child: Consumer(builder: (ctx, ref, child) {
            final contentState = ref.watch(feedDetailStateProvider);
            final isLoadMoreError = contentState.feedListState.isLoadMoreError;
            final isLoadMoreDone = contentState.feedListState.isLoadMoreDone;
            final popularUserState = ref.watch(popularUserListStateProvider);
            final isLoading = contentState.feedListState.isLoading;
            final firstList = contentState.firstFeedState.list;
            final lists = contentState.feedListState.list;

            oldLength = lists.length ?? 0;

            AppBar appBarWidget() {
              if (isLoading) {
                return AppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: widget.firstTitle == "null"
                      ? Text(
                          widget.contentType == "searchContent"
                              ? "#${widget.secondTitle}"
                              : widget.secondTitle,
                        )
                      : Column(
                          children: [
                            Text(
                              widget.contentType != "notificationContent"
                                  ? widget.firstTitle
                                  : ref
                                          .read(feedDetailStateProvider)
                                          .firstFeedState
                                          .memberInfo?[0]
                                          .nick ??
                                      '',
                              style: kBody11RegularStyle.copyWith(
                                  color: kTextBodyColor),
                            ),
                            Text(widget.secondTitle),
                          ],
                        ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                );
              }
              return AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                actions: [
                  widget.contentType == "userContent"
                      ? contentState.firstFeedState.list[0].followState == 1
                          ? InkWell(
                              onTap: () {
                                ref
                                    .watch(feedDetailStateProvider.notifier)
                                    .deleteFollow(
                                      memberIdx:
                                          ref.read(userModelProvider)!.idx,
                                      followIdx: contentState
                                          .firstFeedState.list[0].memberIdx,
                                      contentsIdx: contentState
                                          .firstFeedState.list[0].idx,
                                      contentType: widget.contentType,
                                    );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "팔로잉",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kNeutralColor500),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                ref
                                    .watch(feedDetailStateProvider.notifier)
                                    .postFollow(
                                      memberIdx:
                                          ref.read(userModelProvider)!.idx,
                                      followIdx: contentState
                                          .firstFeedState.list[0].memberIdx,
                                      contentsIdx: contentState
                                          .firstFeedState.list[0].idx,
                                      contentType: widget.contentType,
                                    );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "팔로우",
                                  style: kBody12SemiBoldStyle.copyWith(
                                      color: kPrimaryColor),
                                ),
                              ),
                            )
                      : Container()
                ],
                title: widget.firstTitle == "null"
                    ? Text(
                        widget.contentType == "searchContent"
                            ? "#${widget.secondTitle}"
                            : widget.secondTitle,
                      )
                    : Column(
                        children: [
                          Text(
                            widget.contentType != "notificationContent"
                                ? widget.firstTitle
                                : ref
                                        .read(feedDetailStateProvider)
                                        .firstFeedState
                                        .memberInfo?[0]
                                        .nick ??
                                    '',
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                          Text(widget.secondTitle),
                        ],
                      ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              );
            }

            return Scaffold(
              appBar: appBarWidget(),
              body: lists.isEmpty && firstList.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: lists.length + 1,
                      controller: contentController,
                      itemBuilder: (BuildContext context, int index) {
                        if (index != 0 && index % 4 == 0) {
                          return FeedFollowWidget(
                            popularUserListData: popularUserState.list,
                          );
                        }

                        if (index == 0) {
                          return FeedDetailWidget(
                            feedData: firstList[0],
                            nick: ref
                                    .watch(feedDetailStateProvider)
                                    .firstFeedState
                                    .memberInfo?[0]
                                    .nick ??
                                lists[0].memberInfoList?[0].nick,
                            profileImage: ref
                                    .watch(feedDetailStateProvider)
                                    .firstFeedState
                                    .memberInfo?[0]
                                    .profileImgUrl ??
                                "",
                            memberIdx: ref
                                    .watch(feedDetailStateProvider)
                                    .firstFeedState
                                    .memberInfo?[0]
                                    .memberIdx ??
                                lists[0].memberInfoList?[0].memberIdx,
                            contentType: widget.contentType,
                            imgDomain: ref
                                .watch(feedDetailStateProvider)
                                .firstFeedState
                                .imgDomain!,
                          );
                        } else {
                          if (widget.contentIdx == lists[index - 1].idx) {
                            return Container();
                          } else {
                            return FeedDetailWidget(
                              feedData: lists[index - 1],
                              nick: ref
                                      .watch(feedDetailStateProvider)
                                      .feedListState
                                      .memberInfo?[0]
                                      .nick ??
                                  lists[index - 1].memberInfoList?[0].nick,
                              profileImage: ref
                                      .watch(feedDetailStateProvider)
                                      .feedListState
                                      .memberInfo?[0]
                                      .profileImgUrl ??
                                  lists[index - 1]
                                      .memberInfoList?[0]
                                      .profileImgUrl,
                              memberIdx: ref
                                      .watch(feedDetailStateProvider)
                                      .firstFeedState
                                      .memberInfo?[0]
                                      .memberIdx ??
                                  lists[0].memberInfoList?[0].memberIdx,
                              contentType: widget.contentType,
                              imgDomain: ref
                                  .watch(feedDetailStateProvider)
                                  .firstFeedState
                                  .imgDomain!,
                            );
                          }
                        }
                      },
                    ),
            );
          }),
        ),
      ),
    );
  }
}
