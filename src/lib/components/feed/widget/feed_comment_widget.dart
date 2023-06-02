import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedCommentWidget extends StatelessWidget {
  const FeedCommentWidget({
    required this.image,
    required this.name,
    required this.comment,
    Key? key,
  }) : super(key: key);

  final String? image;
  final String name;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Row(
        children: [
          image == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: kNeutralColor300,
                    child: Image.asset(
                      'assets/image/feed/icon/large_size/icon_taguser.png',
                      height: 30.h,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    image!,
                    height: 30.h,
                  ),
                ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Bubble(
              radius: Radius.circular(10.w),
              elevation: 0,
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftCenter,
              color: kNeutralColor200,
              padding: BubbleEdges.only(
                  left: 12.w, right: 12.w, top: 10.h, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: kBody11SemiBoldStyle.copyWith(
                        color: kTextSubTitleColor),
                  ),
                  Text(
                    comment,
                    style:
                        kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
