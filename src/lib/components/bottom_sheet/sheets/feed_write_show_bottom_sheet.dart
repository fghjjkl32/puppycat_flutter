import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_screen.dart';

void feedWriteShowBottomSheet({required BuildContext context, required VoidCallback onClose}) {
  showCustomModalBottomSheet(
      context: context,
      widget: Column(
        children: [
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: kNeutralColor300,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
              child: Text(
                "공유할 추억을 선택하세요!",
                style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                    onTap: () {
                      context.pop();
                      final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

                      InstaAssetPicker.pickAssets(
                        context,
                        maxAssets: 12,
                        pickerTheme: themeData(context).copyWith(
                          canvasColor: kNeutralColor100,
                          colorScheme: theme.colorScheme.copyWith(
                            background: kNeutralColor100,
                          ),
                          appBarTheme: theme.appBarTheme.copyWith(
                            backgroundColor: kNeutralColor100,
                          ),
                        ),
                        onCompleted: (cropStream) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FeedWriteScreen(
                                cropStream: cropStream,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: kNeutralColor300),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/character_01_dailysharing_80.json',
                            repeat: false,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                            child: Text(
                              "일상공유",
                              style: kButton14BoldStyle.copyWith(color: kTextTitleColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/character_01_walk_80.json',
                          repeat: false,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                          child: Text(
                            "산책하기",
                            style: kButton14BoldStyle.copyWith(color: kTextTitleColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onClose: () {
        onClose();
      });
}
