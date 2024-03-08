import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';

class ErrorReasonDialog extends StatelessWidget {
  final String? code;

  const ErrorReasonDialog({
    super.key,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Text(
                '공통.문제가 생겼어요'.tr(),
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
              Text(
                '($code)',
                style: kBody12RegularStyle400.copyWith(color: kPreviousTextBodyColor),
              ),
            ],
          ),
        ),
        confirmTap: () {
          context.pop();
        },
        confirmWidget: Text(
          "공통.확인".tr(),
          style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
        ));
  }
}
