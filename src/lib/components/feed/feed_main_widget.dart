import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_bottom_icon_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_content_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_image_main_widget.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_title_widget.dart';

class FeedMainWidget extends StatelessWidget {
  const FeedMainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //feed title
        FeedTitleWidget(
          profileImage: 'assets/image/feed/image/sample_image1.png',
          name: '아지다멍',
          position: '강원도 평창군 평창읍',
          time: DateTime(2023, 4, 12),
          isEdit: true,
        ),
        //feed detail image
        const FeedImageMainWidget(
          imageList: [
            'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
            'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
            'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
            'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
            'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
          ],
        ),
        //feed content
        const FeedContentMainWidget(
          content: '''제천 근처 사는 멍멍이들 주목❕🐶

아지가 너무 조아서 추천할게 있어...💓 사실 지난주에 아지가 우리 눈나야랑 제천 구독 #jc_goodog 여기에 같이 출근을 했거든🐾 근데 진짜 짱짱이라 멍멍이 친구들 많이많이 놀러왔으면 조케써서!!! 추천하려구 해💓

애견카페🥨 유치원🍼 호텔링🎀 행동교정🧸 미용🧼 루프탑🏝

실내, 야외 모두 소형견·대형견 공간이 분리되어 있으니까 다들 꼬옥 놀러와죠❕❤ ''',
        ),
        const FeedBottomIconWidget(
          likeCount: 338,
          commentCount: 13,
        ),
        Padding(
          padding: EdgeInsets.all(12.0.h),
          child: const Divider(),
        ),
      ],
    );
  }
}
