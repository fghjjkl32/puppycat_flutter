import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';

void feedWriteShowBottomSheet({required BuildContext context, required VoidCallback onClose}) {
  showCustomModalBottomSheet(
      context: context,
      widget: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: kPreviousNeutralColor300,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Text(
                "공통.공유할 추억을 선택하세요!".tr(),
                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                          canvasColor: kPreviousNeutralColor100,
                          colorScheme: theme.colorScheme.copyWith(
                            background: kPreviousNeutralColor100,
                          ),
                          appBarTheme: theme.appBarTheme.copyWith(
                            backgroundColor: kPreviousNeutralColor100,
                          ),
                        ),
                        onCompleted: (cropStream) {
                          context.push('/feed/write', extra: cropStream);

                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => FeedWriteScreen(
                          //       cropStream: cropStream,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "공통.일상공유".tr(),
                              style: kButton14BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
                    onTap: () {
                      // context.push('/map');
                      ///NOTE
                      ///2023.11.14.
                      ///산책하기 보류로 주석 처리
                      // Navigator.pop(context);
                      // showCustomModalBottomSheet(context: context, widget: const SelectPetSheetItem());
                      ///산책하기 보류로 주석 처리 완료
                      ///여긴 UI가 바뀌어야함
                      // context.pushNamed('error_dialog');
                      // context.pushNamed('error_bottom_sheet');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/character_01_walk_80.json',
                          repeat: false,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "공통.산책하기".tr(),
                            style: kButton14BoldStyle.copyWith(color: kPreviousTextTitleColor),
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
