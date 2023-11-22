// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
// import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
// import 'package:pet_mobile_social_flutter/repositories/main/comment/comment_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
//
// final commentStateProvider = StateNotifierProvider<CommentStateNotifier, CommentDataListModel>((ref) {
//   return CommentStateNotifier(ref);
// });
//
// class CommentStateNotifier extends StateNotifier<CommentDataListModel> {
//   CommentStateNotifier(this.ref) : super(const CommentDataListModel());
//
//   int maxPages = 1;
//   int currentPage = 1;
//
//   int repliesMaxPages = 1;
//   int repliesCurrentPage = 1;
//   Ref ref;
//
//   getInitComment(
//     contentIdx,
//     memberIdx,
//     int? initPage,
//   ) async {
//     currentPage = 1;
//
//     final page = initPage ?? state.page;
//     final lists = await CommentRepository(dio: ref.read(dioProvider)).getComment(page: page, memberIdx: memberIdx, contentIdx: contentIdx);
//
//     maxPages = lists.data.params!.pagination!.endPage!;
//
//     state = state.copyWith(totalCount: lists.data.params!.pagination?.totalRecordCount! ?? 0);
//
//     if (lists == null) {
//       state = state.copyWith(page: page, isLoading: false);
//       return;
//     }
//
//     state = state.copyWith(page: page, isLoading: false, list: lists.data.list);
//   }
//
//   loadMoreComment(contentIdx, memberIdx) async {
//     if (currentPage >= maxPages) {
//       state = state.copyWith(isLoadMoreDone: true);
//       return;
//     }
//
//     StringBuffer bf = StringBuffer();
//
//     bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
//     if (state.isLoading) {
//       bf.write(' fail');
//       return;
//     }
//     bf.write(' success');
//     state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);
//
//     final lists = await CommentRepository(dio: ref.read(dioProvider)).getComment(
//       contentIdx: contentIdx,
//       page: state.page + 1,
//       memberIdx: memberIdx,
//     );
//
//     if (lists == null) {
//       state = state.copyWith(isLoadMoreError: true, isLoading: false);
//       return;
//     }
//
//     if (lists.data.list.isNotEmpty) {
//       state = state.copyWith(page: state.page + 1, isLoading: false, list: [...state.list, ...lists.data.list]);
//
//       currentPage++;
//     } else {
//       state = state.copyWith(
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> refresh(contentsIdx, memberIdx) async {
//     getInitComment(contentsIdx, memberIdx, 1);
//     currentPage = 1;
//   }
//
//   Future<ResponseModel> deleteContents({
//     required memberIdx,
//     required contentsIdx,
//     required commentIdx,
//     required parentIdx,
//   }) async {
//     final result = await CommentRepository(dio: ref.read(dioProvider)).deleteComment(
//       memberIdx: memberIdx,
//       contentsIdx: contentsIdx,
//       commentIdx: commentIdx,
//       parentIdx: parentIdx,
//     );
//
//     await refresh(contentsIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> postContents({
//     required memberIdx,
//     required contents,
//     required contentIdx,
//     int? parentIdx,
//   }) async {
//     final result = await CommentRepository(dio: ref.read(dioProvider)).postComment(memberIdx: memberIdx, contents: contents, parentIdx: parentIdx, contentIdx: contentIdx);
//
//     await refresh(contentIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> editContents({
//     required int memberIdx,
//     required int commentIdx,
//     required String contents,
//     required int contentIdx,
//   }) async {
//     final result = await CommentRepository(dio: ref.read(dioProvider)).editComment(
//       memberIdx: memberIdx,
//       contents: contents,
//       contentIdx: contentIdx,
//       commentIdx: commentIdx,
//     );
//
//     await refresh(contentIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> postCommentLike({
//     required memberIdx,
//     required commentIdx,
//     required contentsIdx,
//   }) async {
//     final result = await CommentRepository(dio: ref.read(dioProvider)).postCommentLike(memberIdx: memberIdx, commentIdx: commentIdx);
//
//     await refresh(contentsIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> deleteCommentLike({
//     required memberIdx,
//     required commentIdx,
//     required contentsIdx,
//   }) async {
//     final result = await CommentRepository(dio: ref.read(dioProvider)).deleteCommentLike(memberIdx: memberIdx, commentIdx: commentIdx);
//
//     await refresh(contentsIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> postBlock({
//     required contentsIdx,
//     required memberIdx,
//     required blockIdx,
//   }) async {
//     final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
//       memberIdx: memberIdx,
//       blockIdx: blockIdx,
//     );
//
//     await refresh(contentsIdx, memberIdx);
//
//     return result;
//   }
//
//   Future<ResponseModel> postCommentReport({
//     required int loginMemberIdx,
//     required int contentIdx,
//     required int reportCode,
//     required String? reason,
//     required String reportType,
//   }) async {
//     final result = await FeedRepository(dio: ref.read(dioProvider)).postContentReport(
//       reportType: reportType,
//       memberIdx: loginMemberIdx,
//       contentIdx: contentIdx,
//       reportCode: reportCode,
//       reason: reason,
//     );
//
//     return result;
//   }
//
//   Future<ResponseModel> deleteCommentReport({
//     required String reportType,
//     required int loginMemberIdx,
//     required int contentIdx,
//   }) async {
//     final result = await FeedRepository(dio: ref.read(dioProvider)).deleteContentReport(
//       reportType: reportType,
//       memberIdx: loginMemberIdx,
//       contentsIdx: contentIdx,
//     );
//
//     return result;
//   }
//
//   getInitReplyComment(
//     contentIdx,
//     memberIdx,
//     int? initPage,
//     commentIdx,
//   ) async {
//     repliesCurrentPage = 1;
//
//     final page = initPage ?? state.page;
//     final lists = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(page: page, memberIdx: memberIdx, contentIdx: contentIdx, commentIdx: commentIdx);
//
//     repliesMaxPages = lists.data.params!.pagination!.endPage!;
//
//     if (lists == null) {
//       state = state.copyWith(page: page, isLoading: false);
//       return;
//     }
//
//     // Find the comment with the given commentIdx
//     final commentIndex = state.list.indexWhere((c) => c.idx == commentIdx);
//
//     // Update the childCommentData of the comment
//     final updatedComment = state.list[commentIndex].copyWith(childCommentData: ChildCommentData(params: lists.data.params!, list: lists.data.list), showAllReplies: true);
//
//     // Update the comment in the state
//     state = state.copyWith(list: [
//       ...state.list.sublist(0, commentIndex),
//       updatedComment,
//       ...state.list.sublist(commentIndex + 1),
//     ], page: page, isLoading: false);
//   }
//
//   loadMoreReplyComment(contentIdx, memberIdx, commentIdx) async {
//     if (repliesCurrentPage >= repliesMaxPages) {
//       state = state.copyWith(isLoadMoreDone: true);
//       return;
//     }
//
//     StringBuffer bf = StringBuffer();
//
//     bf.write('try to request loading ${state.isLoading} at ${state.page + 1}');
//     if (state.isLoading) {
//       bf.write(' fail');
//       return;
//     }
//     bf.write(' success');
//     state = state.copyWith(isLoading: true, isLoadMoreDone: false, isLoadMoreError: false);
//
//     final lists = await CommentRepository(dio: ref.read(dioProvider)).getReplyComment(page: repliesCurrentPage + 1, memberIdx: memberIdx, contentIdx: contentIdx, commentIdx: commentIdx);
//
//     if (lists == null) {
//       state = state.copyWith(isLoadMoreError: true, isLoading: false);
//       return;
//     }
//
//     // Find the comment with the given commentIdx
//     final commentIndex = state.list.indexWhere((c) => c.idx == commentIdx);
//
//     // Append the newly loaded replies to the existing replies
//     final updatedComment = state.list[commentIndex].copyWith(
//       childCommentData: ChildCommentData(
//         params: lists.data.params!,
//         list: [
//           ...state.list[commentIndex].childCommentData!.list,
//           ...lists.data.list,
//         ],
//       ),
//     );
//
//     // Update the comment in the state
//     state = state.copyWith(
//       list: [
//         ...state.list.sublist(0, commentIndex),
//         updatedComment,
//         ...state.list.sublist(commentIndex + 1),
//       ],
//       isLoading: false,
//     );
//
//     repliesCurrentPage++;
//   }
//
//   void increaseLoadMoreClickCount(int commentIdx) {
//     final commentIndex = state.list.indexWhere((c) => c.idx == commentIdx);
//     final updatedComment = state.list[commentIndex].copyWith(
//       loadMoreClickCount: state.list[commentIndex].loadMoreClickCount + 1,
//     );
//
//     state = state.copyWith(list: [
//       ...state.list.sublist(0, commentIndex),
//       updatedComment,
//       ...state.list.sublist(commentIndex + 1),
//     ]);
//   }
// }
