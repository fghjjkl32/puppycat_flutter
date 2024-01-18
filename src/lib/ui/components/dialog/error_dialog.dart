import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';

class ErrorDialog extends StatelessWidget {
  final String? code;

  const ErrorDialog({
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
                '문제가 생겼어요.',
                style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
              ),
              Text(
                '잠시 후에 다시 시도해 주세요.',
                style: kBody12RegularStyle400.copyWith(color: kPreviousTextBodyColor),
              ),
              Visibility(
                visible: code?.isNotEmpty ?? false,
                child: Text(
                  '($code)',
                  style: kBody12RegularStyle400.copyWith(color: kPreviousTextBodyColor),
                ),
              ),
            ],
          ),
        ),
        confirmTap: () {
          context.pop();
        },
        confirmWidget: Text(
          "확인",
          style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
        ));
  }
}
