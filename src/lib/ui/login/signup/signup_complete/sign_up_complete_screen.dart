import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';

class SignUpCompleteScreen extends ConsumerWidget {
  final String nick;

  const SignUpCompleteScreen({required this.nick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            print('didPop $didPop');
            if (didPop) {
              return;
            }

            ///NOTE
            ///여기 고치면 아래 주석 검색해서 거기도 고쳐야하는지 봐야함
            ///로그인 페이지 이동 초기화
            final userModel = ref.read(signUpUserInfoProvider);
            ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel, enableRoutePop: false);
            // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
            ref.read(authStateProvider.notifier).state = false;
            ref.read(checkButtonProvider.notifier).state = false;
            ref.read(policyStateProvider.notifier).policyStateReset();
            ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
          },
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/character_00_welcome_220.json',
                      repeat: false,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '회원가입.회원가입 완료!'.tr(),
                      style: kTitle18BoldStyle.copyWith(height: 1.4, color: kPreviousTextTitleColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '회원가입.회원가입 환영 메시지'.tr(args: [nick]),
                      style: kTitle18BoldStyle.copyWith(height: 1.3, color: kPreviousTextTitleColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "회원가입.퍼피캣과 함께 일상을 공유해 보세요!",
                      style: kBody13RegularStyle.copyWith(height: 1.3, color: kPreviousTextBodyColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 320,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ///NOTE
                        ///여기 고치면 아래 주석 검색해서 거기도 고쳐야하는지 봐야함
                        ///로그인 페이지 이동 초기화
                        final userModel = ref.read(signUpUserInfoProvider);
                        ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel, enableRoutePop: false);
                        // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
                        ref.read(authStateProvider.notifier).state = false;
                        ref.read(checkButtonProvider.notifier).state = false;
                        ref.read(policyStateProvider.notifier).policyStateReset();
                        ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPreviousPrimaryColor,
                        disabledBackgroundColor: kPreviousNeutralColor400,
                        disabledForegroundColor: kPreviousTextBodyColor,
                        elevation: 0,
                      ),
                      child: Text(
                        '회원가입.퍼피캣 시작하기'.tr(),
                        style: kButton14BoldStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         Center(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Image.asset('assets/image/signUpScreen/corgi_1.png'),
    //               SizedBox(
    //                 height: 12.h,
    //               ),
    //               Text(
    //                 '회원가입.퍼피캣의 가족이 되신 걸 환영해요'.tr(),
    //                 style: kTitle14BoldStyle.copyWith(height: 1.4, color: kTextTitleColor),
    //                 textAlign: TextAlign.center,
    //               ),
    //               SizedBox(
    //                 height: 8.h,
    //               ),
    //               Text(
    //                 '회원가입.회원가입 환영 메시지'.tr(),
    //                 style: kBody12RegularStyle.copyWith(height: 1.3, color: kTextBodyColor),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ],
    //           ),
    //         ),
    //         Positioned(
    //           bottom: 0,
    //           child: Padding(
    //             padding: const EdgeInsets.all(20.0),
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    //               child: SizedBox(
    //                 width: 320.w,
    //                 height: 48.h,
    //                 child: ElevatedButton(
    //                   onPressed: () {},
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: kPrimaryColor,
    //                     disabledBackgroundColor: kNeutralColor400,
    //                     disabledForegroundColor: kTextBodyColor,
    //                     elevation: 0,
    //                   ),
    //                   child: Text(
    //                     '회원가입.퍼피캣 이용하기'.tr(),
    //                     style: kButton14BoldStyle,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
