import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedBestPostItemWidget extends StatelessWidget {
  const FeedBestPostItemWidget({
    required this.imageCount,
    required this.image,
    Key? key,
  }) : super(key: key);

  final int imageCount;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              height: 112.h,
            ),
          ),
          Positioned(
            right: 4.w,
            top: 4.w,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff414348).withOpacity(0.75),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              width: 18.w,
              height: 14.w,
              child: Center(
                child: Text(
                  "$imageCount",
                  style: kBadge9RegularStyle.copyWith(color: kNeutralColor100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
