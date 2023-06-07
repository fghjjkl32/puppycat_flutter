import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widget/feed_follow_card_widget.dart';

class FeedFollowWidget extends StatelessWidget {
  const FeedFollowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 205.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              FeedFollowCardWidget(
                imageList: [
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                ],
                profileImage: 'assets/image/feed/image/sample_image1.png',
                userName: 'user',
                followCount: 11820,
              ),
              FeedFollowCardWidget(
                imageList: [
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                ],
                profileImage: null,
                userName: 'name',
                followCount: 182,
              ),
              FeedFollowCardWidget(
                imageList: [
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                  'assets/image/feed/image/sample_image2.png',
                ],
                profileImage: 'assets/image/feed/image/sample_image1.png',
                userName: 'Username',
                followCount: 1182,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
