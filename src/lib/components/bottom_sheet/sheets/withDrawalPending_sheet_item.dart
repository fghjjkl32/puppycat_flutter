import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/account/account_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class WithDrawalPendingSheetItem extends ConsumerWidget {
  const WithDrawalPendingSheetItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Text(
            '가입 제한 안내',
            style:
                kBody16BoldStyle.copyWith(color: kTextTitleColor, height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 32.0),
          child: Text(
            '퍼피캣 탈퇴 7일 이후 재가입 가능합니다.\n기존 활동 내역으로 이어서 이용하시겠습니까?',
            style: kBody12RegularStyle400.copyWith(
                color: kTextBodyColor, height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 336,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              var userModel = ref.read(userModelProvider);

              if (userModel == null) {
                ///TODO
                ///Error Proc
                return;
              }
              ref
                  .read(accountRestoreStateProvider.notifier)
                  .restoreAccount(userModel.simpleId);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
            ),
            child: Text(
              '기존 계정으로 로그인',
              style: kBody14BoldStyle.copyWith(
                color: kNeutralColor100,
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
                '7일 후 회원가입',
                style: kBody12SemiBoldStyle.copyWith(
                  color: kTextBodyColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
