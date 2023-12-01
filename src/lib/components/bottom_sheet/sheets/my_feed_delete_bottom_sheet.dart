import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

void myFeedDeleteBottomSheet({required BuildContext context, required VoidCallback onTap}) {
  showCustomModalBottomSheet(
    context: context,
    widget: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "피드를 삭제할까요?",
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          "삭제한 피드는",
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        Text(
          "삭제된 피드는 되돌릴 수 없어요.",
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                width: 152.w,
                height: 36.h,
                decoration: const BoxDecoration(
                  color: kPreviousPrimaryLightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "취소",
                    style: kButton14BoldStyle.copyWith(color: kPreviousPrimaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 152.w,
                height: 36.h,
                decoration: const BoxDecoration(
                  color: kPreviousErrorColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "삭제",
                    style: kButton14BoldStyle.copyWith(color: kPreviousNeutralColor100),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
