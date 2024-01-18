import 'package:flutter/material.dart';

class CommentDetailListWidget extends StatelessWidget {
  const CommentDetailListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // CommentDetailItemWidget(
        //   profileImage: 'assets/image/feed/image/sample_image1.png',
        //   name: 'bichon_딩동',
        //   comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
        //   isSpecialUser: true,
        //   time: DateTime(2023, 5, 28),
        //   isReply: false,
        //   likeCount: 42,
        // ),
        // CommentDetailItemWidget(
        //   profileImage: 'assets/image/feed/image/sample_image2.png',
        //   name: 'bichon_딩동',
        //   comment: '@baejji 시켜쨔나욧❕❕🐶',
        //   isSpecialUser: true,
        //   time: DateTime(2023, 5, 28),
        //   isReply: true,
        //   likeCount: 32,
        // ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Divider(),
        ),
      ],
    );
  }
}
