import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';

void myFeedKeepBottomSheet({required BuildContext context, required VoidCallback onTap}) {
  showCustomModalBottomSheet(
    context: context,
    widget: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Lottie.asset(
            'assets/lottie/feed_end.json',
            width: 50,
            height: 50,
            fit: BoxFit.fill,
            repeat: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "공통.피드를 보관할까요?".tr(),
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          "공통.보관된 피드는".tr(),
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        Text(
          "공통.[마이페이지 → 내 글 관리 → 보관피드]에서 볼 수 있어요".tr(),
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                width: 152,
                height: 36,
                decoration: const BoxDecoration(
                  color: kBackgroundSecondary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "공통.닫기".tr(),
                    style: kButton14BoldStyle.copyWith(color: kTextSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 152,
                height: 36,
                decoration: const BoxDecoration(
                  color: kPreviousPrimaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    "공통.보관하기".tr(),
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
