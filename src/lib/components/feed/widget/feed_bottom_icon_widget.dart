import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedBottomIconWidget extends StatelessWidget {
  const FeedBottomIconWidget({
    required this.likeCount,
    required this.commentCount,
    Key? key,
  }) : super(key: key);

  final int likeCount;
  final int commentCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/feed/icon/large_size/icon_like_off.png',
                      height: 32.w,
                    ),
                    Text(
                      '$likeCount',
                      style:
                          kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  context.push("/home/commentDetail");
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/feed/icon/large_size/icon_comment.png',
                      height: 32.w,
                    ),
                    Text(
                      '$commentCount',
                      style:
                          kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/image/feed/icon/large_size/icon_bookmark.png',
            height: 32.w,
          ),
        ],
      ),
    );
  }
}
