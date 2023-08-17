import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linkfy_text/linkfy_text.dart';
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
      child: LinkifyText(
        content,
        textStyle: kBody13RegularStyle.copyWith(color: kTextTitleColor),
        linkStyle: kBody13RegularStyle.copyWith(color: kSecondaryColor),
        linkTypes: const [LinkType.hashTag, LinkType.userTag],
        onTap: (link) {},
        textAlign: TextAlign.start,
      ),
    );
  }
}
