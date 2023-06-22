import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    required this.counter,
    required this.imageListLength,
    Key? key,
  }) : super(key: key);

  final ValueListenable<int> counter;
  final int imageListLength;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: counter,
      builder: (BuildContext context, int index, Widget? child) =>
          AnimatedSmoothIndicator(
        activeIndex: index,
        axisDirection: Axis.horizontal,
        count: imageListLength,
        effect: ScrollingDotsEffect(
          dotColor: kNeutralColor400,
          activeDotColor: kPrimaryColor,
          dotWidth: 6.h,
          dotHeight: 6.h,
        ),
      ),
    );
  }
}
