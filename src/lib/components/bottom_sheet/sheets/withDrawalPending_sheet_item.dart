import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/user_restore_state_provider.dart';

class WithDrawalPendingSheetItem extends ConsumerWidget {
  const WithDrawalPendingSheetItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            '다시 만나 반가워요!\n이전 활동을 이어서 할까요?',
            style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 336,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              var userModel = ref.read(userInfoProvider).userModel;

              if (userModel == null) {
                ///TODO
                ///Error Proc
                return;
              }
              ref.read(userRestoreStateProvider.notifier).restoreAccount(userModel.simpleId);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(kPreviousPrimaryColor),
            ),
            child: Text(
              '이어서 하기',
              style: kBody14BoldStyle.copyWith(
                color: kPreviousNeutralColor100,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: SizedBox(
            width: 336,
            height: 46,
            child: TextButton(
              onPressed: () {
                ref.read(loginStateProvider.notifier).state = LoginStatus.none;
                Navigator.pop(context);
              },
              child: Text(
                '다른 계정으로 로그인하기',
                style: kBody12SemiBoldStyle.copyWith(
                  color: kPreviousTextBodyColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
