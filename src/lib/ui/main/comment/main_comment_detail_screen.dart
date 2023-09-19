// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
// import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/main/comment/comment_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';
//
// class MainCommentDetailScreen extends ConsumerStatefulWidget {
//   final int? contentIdx;
//   const MainCommentDetailScreen({required this.contentIdx, super.key});
//
//   @override
//   MainCommentDetailScreenState createState() => MainCommentDetailScreenState();
// }
//
// class MainCommentDetailScreenState
//     extends ConsumerState<MainCommentDetailScreen> {
//   int commentOldLength = 0;
//   ScrollController commentController = ScrollController();
//
//   @override
//   void initState() {
//     commentController.addListener(_commentScrollListener);
//
//     ref
//         .read(commentStateProvider.notifier)
//         .getInitComment(widget.contentIdx, ref.read(userInfoProvider).userModel!.idx, 1);
//
//     super.initState();
//   }
//
//   void _commentScrollListener() {
//     if (commentController.position.pixels >
//         commentController.position.maxScrollExtent -
//             MediaQuery.of(context).size.height) {
//       if (commentOldLength == ref.read(commentStateProvider).list.length) {
//         ref.read(commentStateProvider.notifier).loadMoreComment(
//             ref.watch(commentStateProvider).list[0].contentsIdx,
//             ref.read(userInfoProvider).userModel!.idx);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         ref.watch(commentHeaderProvider.notifier).resetReplyCommentHeader();
//         context.pop();
//         return false;
//       },
//       child: Material(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//             title: const Text(
//               "댓글",
//             ),
//             leading: IconButton(
//               onPressed: () {
//                 ref
//                     .watch(commentHeaderProvider.notifier)
//                     .resetReplyCommentHeader();
//                 context.pop();
//               },
//               icon: const Icon(Icons.arrow_back),
//             ),
//           ),
//           body: Stack(
//             children: [
//               Consumer(builder: (context, ref, child) {
//                 final commentContentState = ref.watch(commentStateProvider);
//                 final commentLists = commentContentState.list;
//
//                 commentOldLength = commentLists.length ?? 0;
//
//                 return ListView.builder(
//                   controller: commentController,
//                   itemCount: commentLists.length,
//                   padding: EdgeInsets.only(bottom: 80.h),
//                   itemBuilder: (BuildContext context, int index) {
//                     return CommentDetailItemWidget(
//                       key: UniqueKey(),
//                       parentIdx: commentLists[index].parentIdx,
//                       commentIdx: commentLists[index].idx,
//                       profileImage: commentLists[index].url ??
//                           'assets/image/feed/image/sample_image1.png',
//                       name: commentLists[index].nick,
//                       comment: commentLists[index].contents,
//                       isSpecialUser: commentLists[index].isBadge == 1,
//                       time: DateTime.parse(commentLists[index].regDate),
//                       isReply: false,
//                       likeCount: commentLists[index].commentLikeCnt ?? 0,
//                       replies: commentLists[index].childCommentData,
//                       contentIdx: commentLists[index].contentsIdx,
//                       isLike: commentLists[index].likeState == 1,
//                       memberIdx: commentLists[index].memberIdx,
//                       mentionListData: commentLists[index].mentionList ?? [],
//                     );
//                   },
//                 );
//               }),
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: CommentCustomTextField(
//                   contentIdx: widget.contentIdx!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
