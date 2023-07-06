import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/comment/comment_custom_text_field.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item_widget.dart';
import 'package:pet_mobile_social_flutter/providers/main/comment/main_comment_header_provider.dart';

class MainCommentDetailScreen extends ConsumerStatefulWidget {
  const MainCommentDetailScreen({super.key});

  @override
  MainCommentDetailScreenState createState() => MainCommentDetailScreenState();
}

class MainCommentDetailScreenState
    extends ConsumerState<MainCommentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.watch(commentHeaderProvider.notifier).resetCommentHeader();
        context.pop();
        return false;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "댓글 5",
            ),
            leading: IconButton(
              onPressed: () {
                ref.watch(commentHeaderProvider.notifier).resetCommentHeader();
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image1.png',
                    name: 'bichon_딩동',
                    comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: false,
                    likeCount: 42,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image1.png',
                    name: 'bichon_딩동',
                    comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: false,
                    likeCount: 42,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image1.png',
                    name: 'bichon_딩동',
                    comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: false,
                    likeCount: 42,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image1.png',
                    name: 'bichon_딩동',
                    comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: false,
                    likeCount: 42,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                  CommentDetailItemWidget(
                    profileImage: 'assets/image/feed/image/sample_image2.png',
                    name: 'bichon_딩동',
                    comment: '@baejji 시켜쨔나욧❕❕🐶',
                    isSpecialUser: true,
                    time: DateTime(2023, 5, 28),
                    isReply: true,
                    likeCount: 32,
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CommentCustomTextField(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
