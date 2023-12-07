import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

class RecommendedUpdateDialog extends StatelessWidget {
  const RecommendedUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Text(
              '권장 업데이트',
              style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            Text(
              '권장 업데이트',
              style: kBody12RegularStyle400.copyWith(color: kPreviousTextBodyColor),
            ),
          ],
        ),
      ),
      confirmTap: () {
        context.pop();

        StoreRedirect.redirect(androidAppId: "com.uxp.puppycat", iOSAppId: "6473242050");
      },
      cancelTap: () async {
        context.pop();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastPopUpDate', DateTime.now().toIso8601String());
      },
      confirmWidget: Text(
        "업데이트",
        style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
      ),
      cancelWidget: Text(
        "닫기",
        style: kButton14MediumStyle.copyWith(color: kPreviousTextTitleColor),
      ),
    );
  }
}
