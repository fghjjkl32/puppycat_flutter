import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              "피드를 찾을 수 없어요.",
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "피드가 삭제되었거나\n공개 범위가 바뀌었을 수 있어요.",
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
                padding: EdgeInsets.only(
                  left: 20.0.w,
                  right: 20.0.w,
                  bottom: 20.0.h,
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
                        '홈으로 이동',
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
