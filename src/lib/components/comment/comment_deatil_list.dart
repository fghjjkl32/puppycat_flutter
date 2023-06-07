import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/comment/widget/comment_detail_item.dart';

class CommentDetailList extends StatelessWidget {
  const CommentDetailList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommentDetailItem(
          profileImage: 'assets/image/feed/image/sample_image1.png',
          name: 'bichon_딩동',
          comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
          isSpecialUser: true,
          time: DateTime(2023, 5, 28),
          isReply: false,
          likeCount: 42,
        ),
        CommentDetailItem(
          profileImage: 'assets/image/feed/image/sample_image2.png',
          name: 'bichon_딩동',
          comment: '@baejji 시켜쨔나욧❕❕🐶',
          isSpecialUser: true,
          time: DateTime(2023, 5, 28),
          isReply: true,
          likeCount: 32,
        ),
        Padding(
          padding: EdgeInsets.all(10.0.h),
          child: const Divider(),
        ),
      ],
    );
  }
}
