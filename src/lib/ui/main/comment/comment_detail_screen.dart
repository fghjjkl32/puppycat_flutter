import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_focus_index.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CommentDetailScreen extends ConsumerStatefulWidget {
  final int contentsIdx;
  final int? commentFocusIndex;

  const CommentDetailScreen({
    required this.contentsIdx,
    this.commentFocusIndex,
    super.key,
  });

  @override
  CommentDetailScreenState createState() => CommentDetailScreenState();
}

class CommentDetailScreenState extends ConsumerState<CommentDetailScreen> {
  int _contentsIdx = -1;
  late int? _commentFocusIndex;
  late PagingController<int, CommentData> _commentPagingController;
  final AutoScrollController _scrollController = AutoScrollController();
  bool _isInitLoad = true;

  @override
  void initState() {
    _contentsIdx = widget.contentsIdx;
    _commentFocusIndex = widget.commentFocusIndex;

    // _commentPagingController = ref.read(commentListStateProvider);

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (_commentFocusIndex != null) {
        print('run??');
        await _scrollController.scrollToIndex(
          _commentFocusIndex!,
          preferPosition: AutoScrollPosition.begin,
        );
        _commentFocusIndex = null;
      }
    });

    if (_commentFocusIndex == null) {
      print('_commentFocusIndex $_commentFocusIndex');
      ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
    } else {
      ref.read(commentListStateProvider.notifier).getFocusingComments(17, 99);
      // ref.read(commentListStateProvider.notifier).getFocusingComments(_contentsIdx, _commentFocusIndex!);
      // _scrollController.addListener(() {
      //   print('_isInitLoad $_isInitLoad');
      //   if (_scrollController.position.atEdge) {
      //     if (_scrollController.position.pixels == 0) {
      //       // if (!_isInitLoad && _scrollController.position.pixels <= 100) {
      //         ref.read(commentListStateProvider.notifier).fetchPreviousPage();
      //       }
      //     }
      //   _isInitLoad = false;
      // });
    }
    // _commentPagingController.refresh();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "댓글",
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, CommentData>(
              pagingController: ref.watch(commentListStateProvider),
              scrollController: _scrollController,
              builderDelegate: PagedChildBuilderDelegate<CommentData>(
                animateTransitions: true,
                noItemsFoundIndicatorBuilder: (context) {
                  // return const Text('No Comments');
                  return const SizedBox.shrink();
                },
                firstPageProgressIndicatorBuilder: (context) {
                  // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
                  return const Center(child: CircularProgressIndicator());
                },
                itemBuilder: (context, item, index) {
                  return AutoScrollTag(
                    key: UniqueKey(),
                    controller: _scrollController,
                    index: item.idx,
                    child: CommentDetailItemWidget(
                      key: UniqueKey(),
                      parentIdx: item.parentIdx,
                      commentIdx: item.idx,
                      profileImage: item.url ?? 'assets/image/feed/image/sample_image1.png',
                      name: item.nick,
                      comment: item.contents,
                      isSpecialUser: item.isBadge == 1,
                      time: DateTime.parse(item.regDate),
                      isReply: false,
                      likeCount: item.commentLikeCnt ?? 0,
                      replies: item.childCommentData,
                      contentIdx: item.contentsIdx,
                      isLike: item.likeState == 1,
                      memberIdx: item.memberIdx,
                      mentionListData: item.mentionList ?? [],
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _scrollController.scrollToIndex(
                142,
                preferPosition: AutoScrollPosition.begin,
              );
            },
            child: const Text('test'),
          ),
          CommentCustomTextField(
            contentIdx: _contentsIdx,
          ),
        ],
      ),
    );
  }
}
