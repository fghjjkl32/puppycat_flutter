import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';

class DuplicationSignUpDialog extends ConsumerWidget {
  final String simpleType;
  final String email;

  const DuplicationSignUpDialog({
    super.key,
    required this.simpleType,
    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomDialog(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: kBody16BoldStyle.copyWith(color: kNeutralColor900),
                  children: [
                    TextSpan(
                      text: simpleType,
                      style: kBody16BoldStyle.copyWith(color: getSimpleTypeColor(simpleType), height: 1.4),
                    ),
                    TextSpan(
                      text: '공통.로 가입된 계정이 있어요!'.tr(),
                      style: TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '공통.아래 계정으로 로그인해 주세요'.tr(),
                style: kBody13RegularStyle.copyWith(color: kNeutralColor500),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                // color: kNeutralColor100,
                alignment: Alignment.center,
                width: 220,
                height: 38,
                decoration: BoxDecoration(
                  color: kNeutralColor100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  email,
                  style: kBody13RegularStyle.copyWith(color: kNeutralColor500),
                ),
              ),
            ],
          ),
        ),
        confirmTap: () {
          ///NOTE
          ///여기 고치면 아래 주석 검색해서 거기도 고쳐야하는지 봐야함
          ///로그인 페이지 이동 초기화
          // ref.read(loginRouteStateProvider.notifier).state = LoginRouteEnum.none;
          // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
          ref.read(signUpUserInfoProvider.notifier).state = null;
          ref.read(authStateProvider.notifier).state = false;
          ref.read(checkButtonProvider.notifier).state = false;
          ref.read(policyStateProvider.notifier).policyStateReset();
          ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
          // context.pop();
          context.go('/home/login');
        },
        confirmWidget: Text(
          "공통.확인".tr(),
          style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
        ));
  }
}
