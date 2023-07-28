import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/feed_detail_state_provider.dart';

class FeedDetailScreen extends ConsumerStatefulWidget {
  final String firstTitle;
  final String secondTitle;
  final int memberIdx;
  final int contentIdx;
  final String contentType;

  const FeedDetailScreen({
    required this.firstTitle,
    required this.secondTitle,
    required this.memberIdx,
    required this.contentIdx,
    required this.contentType,
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
          loginMemberIdx: ref.read(userModelProvider)!.idx,
          memberIdx: widget.memberIdx,
          initPage: 1,
          contentIdx: widget.contentIdx,
          contentType: widget.contentType,
          searchWord: widget.secondTitle,
        );
    super.initState();
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
          child: Scaffold(
            appBar: AppBar(
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
                          widget.firstTitle,
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
            ),
            body: Consumer(builder: (ctx, ref, child) {
              final contentState = ref.watch(feedDetailStateProvider);
              final isLoadMoreError =
                  contentState.feedListState.isLoadMoreError;
              final isLoadMoreDone = contentState.feedListState.isLoadMoreDone;
              final isLoading = contentState.feedListState.isLoading;
              final firstList = contentState.firstFeedState.list;
              final lists = contentState.feedListState.list;

              oldLength = lists.length ?? 0;

              return lists.isEmpty && firstList.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: lists.length + 1,
                      controller: contentController,
                      itemBuilder: (BuildContext context, int index) {
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
                            );
                          }
                        }
                      },
                    );
            }),
          ),
        ),
      ),
    );
  }
}
