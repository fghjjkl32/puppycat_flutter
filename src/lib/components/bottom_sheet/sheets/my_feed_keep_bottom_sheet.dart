import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/select_pet_sheet_item.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';

void myFeedKeepBottomSheet({required BuildContext context, required VoidCallback onTap}) {
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
                "게시물을 보관하시겠어요?",
                style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          "보관된 게시물은 언제든지 프로필에",
          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
        ),
        Text(
          "다시 표시 가능합니다.",
          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
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
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "취소",
                    style: kButton14BoldStyle.copyWith(color: kPrimaryColor),
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
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "보관",
                    style: kButton14BoldStyle.copyWith(color: kNeutralColor100),
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
