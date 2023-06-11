import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_comment_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_detail_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';

import 'widget/feed_content_detail_widget.dart';

class FeedDetailWidget extends StatelessWidget {
  const FeedDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //feed title
        FeedTitleWidget(
          profileImage: 'assets/image/feed/image/sample_image1.png',
          userName: '아지다멍',
          address: '강원도 평창군 평창읍',
          time: DateTime(2023, 5, 28),
          isEdit: true,
        ),
        //feed detail image
        FeedImageDetailWidget(
          imageList: const [
            'assets/image/feed/image/sample_image2.png',
            'assets/image/feed/image/sample_image2.png',
            'assets/image/feed/image/sample_image2.png',
            'assets/image/feed/image/sample_image2.png',
            'assets/image/feed/image/sample_image2.png',
            'assets/image/feed/image/sample_image2.png',
          ],
        ),
        //feed content
        const FeedContentDetailWidget(
          content: '''제천 근처 사는 멍멍이들 주목❕🐶

아지가 너무 조아서 추천할게 있어...💓 사실 지난주에 아지가 우리 눈나야랑 제천 구독 #jc_goodog 여기에 같이 출근을 했거든🐾 근데 진짜 짱짱이라 멍멍이 친구들 많이많이 놀러왔으면 조케써서!!! 추천하려구 해💓

애견카페🥨 유치원🍼 호텔링🎀 행동교정🧸 미용🧼 루프탑🏝

실내, 야외 모두 소형견·대형견 공간이 분리되어 있으니까 다들 꼬옥 놀러와죠❕❤ ''',
        ),
        const FeedBottomIconWidget(
          likeCount: 338,
          commentCount: 13,
        ),
        const FeedCommentWidget(
          profileImage: 'assets/image/feed/image/sample_image1.png',
          name: 'bichon_딩동',
          comment: '헤엑😍 넘 귀엽자농~ 모자 쓴거야? 귀여미!!! 너무 행복해...',
          isSpecialUser: true,
        ),
        Padding(
          padding: EdgeInsets.all(12.0.h),
          child: const Divider(),
        ),
      ],
    );
  }
}
