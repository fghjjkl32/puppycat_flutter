import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedImageDetailWidget extends StatelessWidget {
  FeedImageDetailWidget({
    required this.imageList,
    Key? key,
  }) : super(key: key);

  final List<String> imageList;

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
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: kPrimarySideFeedImagePadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      i,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: ValueListenableBuilder<int>(
            valueListenable: _counter,
            builder: (BuildContext context, int index, Widget? child) =>
                AnimatedSmoothIndicator(
              activeIndex: index,
              axisDirection: Axis.horizontal,
              count: imageList.length,
              effect: ScrollingDotsEffect(
                dotColor: kNeutralColor400,
                activeDotColor: kPrimaryColor,
                dotWidth: 6.h,
                dotHeight: 6.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
