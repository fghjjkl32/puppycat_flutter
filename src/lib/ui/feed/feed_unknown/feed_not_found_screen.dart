import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedNotFoundScreen extends StatelessWidget {
  const FeedNotFoundScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    double image1Width = 131 * 0.9;
    double image2Width = 56 * 0.9;
    double image3Width = 141 * 0.9;

    double availableWidthPerSide = (deviceWidth - image1Width - image3Width) / 2;

    int numberOfWidgetsPerSide = (availableWidthPerSide / image2Width).floor();

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 0.9,
                    child: Image.asset(
                      'assets/image/character/character_02_page_error_1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                for (var i = 0; i < numberOfWidgetsPerSide; i++)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: 0.9,
                      child: Image.asset(
                        'assets/image/character/character_02_page_error_2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 0.9,
                    child: Image.asset(
                      'assets/image/character/character_02_page_error_3.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "피드.피드를 찾을 수 없어요".tr(),
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "피드.피드 에러 문구".tr(),
              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPreviousPrimaryLightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      context.pushReplacement("/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '홈으로 이동'.tr(),
                        style: kBody14BoldStyle.copyWith(
                          color: kPreviousPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
