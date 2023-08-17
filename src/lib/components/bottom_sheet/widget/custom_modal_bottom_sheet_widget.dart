import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    required this.widget,
    required this.context,
    Key? key,
  }) : super(key: key);

  final Widget widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
        color: kNeutralColor100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70.w,
              height: 6.h,
              decoration: const BoxDecoration(
                color: kNeutralColor200,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            widget
          ],
        ),
      ),
    );
  }
}
