import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/library/read_more.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedContentDetailWidget extends StatelessWidget {
  const FeedContentDetailWidget({
    required this.content,
    Key? key,
  }) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ReadMoreText(
              content,
              trimLines: 2,
              style: kBody13RegularStyle.copyWith(color: kTextTitleColor),
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: '더보기',
              trimExpandedText: '',
              moreStyle: kBody13RegularStyle.copyWith(color: kTextBodyColor),
              lessStyle: kBody13RegularStyle.copyWith(color: kTextBodyColor),
              linkStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor),
              callback: (link) {},
            ),
          ),
        ],
      ),
    );
  }
}
