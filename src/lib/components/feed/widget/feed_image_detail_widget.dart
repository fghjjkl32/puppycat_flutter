import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

class FeedImageDetailWidget extends StatelessWidget {
  FeedImageDetailWidget({
    required this.imageList,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 266.0.h,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              _counter.value = index;
            },
          ),
          items: imageList.map((i) {
            return Stack(
              children: [
                Padding(
                  padding: kPrimarySideFeedImagePadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${i.url!}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                ...i.imgMemberTagList!.map((tag) {
                  return Positioned(
                    left: tag.width!.toDouble(),
                    top: tag.height!.toDouble(),
                    child: GestureDetector(
                      onTap: () {},
                      child: MentionTagWidget(
                        isCanClose: false,
                        color: kTextSubTitleColor.withOpacity(0.8),
                        textStyle: kBody11RegularStyle.copyWith(
                            color: kNeutralColor100),
                        text: tag.nick!,
                        onDelete: () {},
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: DotIndicator(
            counter: _counter,
            imageListLength: imageList.length,
          ),
        ),
      ],
    );
  }
}
