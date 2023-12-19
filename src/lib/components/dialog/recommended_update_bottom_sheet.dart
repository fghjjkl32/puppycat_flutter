import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

class RecommendedUpdateBottomSheet extends ConsumerWidget {
  RecommendedUpdateBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref.watch(recommendUpdateProvider).title,
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          ref.watch(recommendUpdateProvider).contents,
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        ref.watch(recommendUpdateProvider).patchNote == "" || ref.watch(recommendUpdateProvider).patchNote == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Html(
                  data: ref.watch(recommendUpdateProvider).patchNote,
                  style: {
                    "*": Style(
                      textAlign: TextAlign.center,
                      fontFamily: "pretendard",
                      fontSize: FontSize(16.0),
                      fontWeight: FontWeight.w700,
                      color: kPreviousTextTitleColor,
                    ),
                  },
                ),
              ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                ref.read(isRecommendUpdateProvider.notifier).state = false;

                context.pushReplacement("/home");

                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('lastPopUpDate', DateTime.now().toIso8601String());
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
                    "다음에하기",
                    style: kButton14MediumStyle.copyWith(color: kPreviousTextTitleColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () {
                ref.read(isRecommendUpdateProvider.notifier).state = false;

                context.pushReplacement("/home");

                StoreRedirect.redirect(androidAppId: "com.uxp.puppycat", iOSAppId: "6473242050");
              },
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
                    "지금 업데이트",
                    style: kButton14MediumStyle.copyWith(color: kWhiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
