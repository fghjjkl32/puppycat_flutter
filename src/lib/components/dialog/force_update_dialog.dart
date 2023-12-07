import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:store_redirect/store_redirect.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          children: [
            Text(
              '필수 업데이트',
              style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            Text(
              '필수 업데이트',
              style: kBody12RegularStyle400.copyWith(color: kPreviousTextBodyColor),
            ),
          ],
        ),
      ),
      confirmTap: () {
        StoreRedirect.redirect(androidAppId: "com.uxp.puppycat", iOSAppId: "6473242050");
      },
      confirmWidget: Text(
        "업데이트",
        style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
      ),
    );
  }
}
