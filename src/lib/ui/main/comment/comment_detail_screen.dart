import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CommentDetailScreen extends ConsumerStatefulWidget {
  final int contentsIdx;
  final int? commentFocusIndex;
  final String oldMemberUuid;

  const CommentDetailScreen({
    required this.contentsIdx,
    this.commentFocusIndex,
    required this.oldMemberUuid,
    super.key,
  });

  @override
  CommentDetailScreenState createState() => CommentDetailScreenState();
}

class CommentDetailScreenState extends ConsumerState<CommentDetailScreen> {
  int _contentsIdx = -1;
  late int? _commentFocusIndex;
  late final PagingController<int, CommentData> _commentPagingController = ref.read(commentListStateProvider);
  final AutoScrollController _scrollController = AutoScrollController();
  bool _isInitLoad = true;

  @override
  void initState() {
    Future(() {
      ref.read(commentHeaderProvider.notifier).resetReplyCommentHeader();
      ref.read(commentHeaderProvider.notifier).setHasInput(false);
      ref.read(commentHeaderProvider.notifier).setControllerValue("");
    });

    _contentsIdx = widget.contentsIdx;
    _commentFocusIndex = widget.commentFocusIndex;

    super.initState();

    if (_commentFocusIndex == null) {
      ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
    } else {
      // ref.read(commentListStateProvider.notifier).getFocusingComments(17, 99);
      ref.read(commentListStateProvider.notifier).getFocusingComments(_contentsIdx, _commentFocusIndex!);
      // _scrollController.addListener(() {
      //   // if (_scrollController.position.atEdge) {
      //   //   if (_scrollController.position.pixels == 0) {
      //   if (!_isInitLoad && _scrollController.position.pixels <= 100) {
      //     ref.read(commentListStateProvider.notifier).fetchPreviousPage();
      //   }
      //   // }
      //   if (_scrollController.position.pixels >= 100) {
      //     _isInitLoad = false;
      //   }
      // });

      _commentPagingController.addListener(() async {
        print('not run? ');
        if (_commentPagingController.itemList != null) {
          int refreshFocusIdx = ref.read(commentListRefreshFocusProvider);
          if (_commentFocusIndex != null) {
            refreshFocusIdx = _commentFocusIndex!;
          }
          int scrollIdx = ref.read(commentListStateProvider).itemList!.indexWhere((element) => element.idx == refreshFocusIdx);
          print('run?? $refreshFocusIdx / scrollIdx $scrollIdx');
          if (scrollIdx < 0) {
            return;
          }

          await _scrollController.scrollToIndex(
            // _commentFocusIndex!,
            scrollIdx,
            preferPosition: AutoScrollPosition.begin,
          );
          _commentFocusIndex = null;
          ref.read(commentListRefreshFocusProvider.notifier).state = 0;
        }
      });
    }
    // _commentPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "댓글",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: PagedListView<int, CommentData>(
                  pagingController: _commentPagingController,
                  scrollController: _scrollController,
                  builderDelegate: PagedChildBuilderDelegate<CommentData>(
                    // animateTransitions: true,
                    noItemsFoundIndicatorBuilder: (context) {
                      // return const Text('No Comments');
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
                                  '아직 댓글이 없어요.\n피드에 댓글을 남겨 보세요.',
                                  textAlign: TextAlign.center,
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextBodyColor, height: 1.4, letterSpacing: 0.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) {
                      // ref.read(commentListStateProvider.notifier).getComments(_contentsIdx);
                      return const Center(child: CircularProgressIndicator());
                    },
                    itemBuilder: (context, item, index) {
                      return AutoScrollTag(
                        key: UniqueKey(),
                        controller: _scrollController,
                        index: index,
                        child: CommentDetailItemWidget(
                          key: UniqueKey(),
                          parentIdx: item.parentIdx,
                          commentIdx: item.idx,
                          profileImage: item.profileImgUrl ?? 'assets/image/feed/image/sample_image1.png',
                          name: item.nick,
                          comment: item.contents,
                          isSpecialUser: item.isBadge == 1,
                          time: DateTime.parse(item.regDate),
                          isReply: item.isReply,
                          likeCount: item.commentLikeCnt ?? 0,
                          // replies: item.childCommentData,
                          contentIdx: item.contentsIdx,
                          isLike: item.likeState == 1,
                          memberUuid: item.memberUuid,
                          mentionListData: item.mentionList ?? [],
                          oldMemberUuid: widget.oldMemberUuid,
                          isLastDisPlayChild: item.isLastDisPlayChild,
                          // remainChildCount: item.remainChildCount,
                          onMoreChildComment: (page) {
                            print('load more child comment');
                            ref.read(commentListStateProvider.notifier).getChildComments(
                                  item.contentsIdx,
                                  item.parentIdx,
                                  item.idx,
                                  page,
                                  true,
                                );
                          },
                          pageNumber: item.pageNumber,
                          isDisplayPreviousMore: item.isDisplayPreviousMore,
                          onPrevMoreChildComment: (page) {
                            print('load prev more child comment');
                            ref.read(commentListStateProvider.notifier).getChildComments(
                                  item.contentsIdx,
                                  item.parentIdx,
                                  item.idx,
                                  page,
                                  false,
                                );
                          },
                          onTapRemoveButton: () async {
                            final result = await ref.read(commentListStateProvider.notifier).deleteContents(
                                  contentsIdx: item.contentsIdx,
                                  commentIdx: item.idx,
                                  parentIdx: item.parentIdx,
                                );

                            if (result.result) {
                              context.pop();
                            }
                          },

                          onTapEditButton: () {
                            final commentHeaderState = ref.watch(commentHeaderProvider.notifier);

                            // context.pop();

                            commentHeaderState.addEditCommentHeader(item.contents, item.idx);

                            commentHeaderState.setHasInput(true);

                            ref.read(hashtagListProvider.notifier).state = getHashtagList(item.contents);
                            ref.read(mentionListProvider.notifier).state = item.mentionList ?? [];

                            commentHeaderState.setControllerValue(replaceMentionsWithNicknamesInContentAsString(item.contents, item.mentionList ?? []));
                            context.pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            CommentCustomTextField(
              contentIdx: _contentsIdx,
            ),
          ],
        ),
      ),
    );
  }
}
