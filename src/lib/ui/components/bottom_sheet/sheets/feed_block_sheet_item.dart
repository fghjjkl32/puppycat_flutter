import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedBlockSheetItem extends ConsumerWidget {
  const FeedBlockSheetItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/feed_end.json',
          width: 48,
          height: 48,
          fit: BoxFit.fill,
          repeat: false,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "차단한 유저의 피드예요.",
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          "차단을 풀고 'test' 님의 피드를 볼까요?",
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        SizedBox(height: 20),
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
              width: 8,
            ),
            GestureDetector(
              onTap: () {},
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
                    "보관",
                    style: kButton14BoldStyle.copyWith(color: kPreviousNeutralColor100),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
