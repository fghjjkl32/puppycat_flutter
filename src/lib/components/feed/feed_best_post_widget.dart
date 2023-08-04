import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/feed_best_post_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedBestPostWidget extends StatelessWidget {
  const FeedBestPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push("/home/myPage/detail/아지다멍/게시물");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h),
            child: Text(
              "인기 급상승 게시글",
              style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 112.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0.w),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  FeedBestPostItemWidget(
                    imageCount: 3,
                    image: 'assets/image/feed/image/sample_image2.png',
                  ),
                  FeedBestPostItemWidget(
                    imageCount: 3,
                    image: 'assets/image/feed/image/sample_image2.png',
                  ),
                  FeedBestPostItemWidget(
                    imageCount: 3,
                    image: 'assets/image/feed/image/sample_image2.png',
                  ),
                  FeedBestPostItemWidget(
                    imageCount: 3,
                    image: 'assets/image/feed/image/sample_image2.png',
                  ),
                  FeedBestPostItemWidget(
                    imageCount: 3,
                    image: 'assets/image/feed/image/sample_image2.png',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0.h),
            child: const Divider(),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
