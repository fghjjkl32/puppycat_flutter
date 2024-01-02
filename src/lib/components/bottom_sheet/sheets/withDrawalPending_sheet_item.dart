import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/user_restore_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';

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
              // final isLogined = ref.read(loginStatementProvider);
              //
              // if (!isLogined) {
              //   ///TODO
              //   ///Error Proc
              //   return;
              // }
              print('current route  44 : ${ref.read(routerProvider).location()}');

              ref.read(userRestoreStateProvider.notifier).restoreAccount();

              print('current route 55 : ${ref.read(routerProvider).location()}');

              // context.pop();
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
              onPressed: () async {
                await TokenController.clearTokens();
                ref.read(loginStateProvider.notifier).state = LoginStatus.none;
                ref.read(myInfoStateProvider.notifier).state = UserInformationItemModel();
                // ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
                ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
                ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
                ref.read(signUpUserInfoProvider.notifier).state = null;
                ref.read(authStateProvider.notifier).state = false;
                ref.read(checkButtonProvider.notifier).state = false;
                ref.read(policyStateProvider.notifier).policyStateReset();
                ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
                context.pop();
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
