import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:store_redirect/store_redirect.dart';

class ForceUpdateBottomSheet extends ConsumerWidget {
  ForceUpdateBottomSheet({super.key});

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
                ref.watch(forceUpdateProvider).forceTitle,
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
            ],
          ),
        ),
        Text(
          ref.watch(forceUpdateProvider).forceContents,
          style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
        ),
        ref.watch(forceUpdateProvider).forcePatchNote == "" || ref.watch(forceUpdateProvider).forcePatchNote == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Html(
                  data: ref.watch(forceUpdateProvider).forcePatchNote,
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
              onTap: () {
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
                  "공통.확인".tr(),
                  style: kButton14MediumStyle.copyWith(color: kWhiteColor),
                )),
              ),
            ),
          ],
        )
      ],
    );
  }
}
