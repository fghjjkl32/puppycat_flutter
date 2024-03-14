import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // Widget _loginButton({
  //   required Function onPressed,
  //   required Widget icon,
  //   Color backgroundColor = const Color(0xffffffff),
  //   String label = 'Login Button',
  //   double? width,
  //   double? height,
  //   double? borderRadius,
  //   TextStyle? labelStyle,
  //   ButtonStyle? buttonStyle,
  // }) {
  //   return SizedBox(
  //     width: width ?? 200,
  //     height: height ?? 40,
  //     child: ElevatedButton.icon(
  //       style: buttonStyle ?? ButtonStyle(
  //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 8.0)),
  //         ),
  //         backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
  //       ),
  //       onPressed: () {
  //         onPressed();
  //       },
  //       label: Text(
  //         label,
  //         style: labelStyle ?? kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
  //       ),
  //       icon: icon,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('test333333 login ${GoRouter.of(context).routerDelegate.currentConfiguration}');
    ref.listen(loginStateProvider, (previous, next) {
      if (next == LoginStatus.withdrawalPending) {
        print('test333333 login 22222 ${GoRouter.of(context).routerDelegate.currentConfiguration}');
        // showCustomModalBottomSheet(context: context, widget: const WithDrawalPendingSheetItem());
        print('current route : ${ref.read(routerProvider).location()}');
        context.pushNamed('withDrawalPendingBottomSheet');
      }
    });

    // ref.listen(userRestoreStateProvider, (previous, next) {
    //   if (next) {
    //     print('current route 22 : ${ref.read(routerProvider).location()}');
    //
    //     final userModel = ref.read(signUpUserInfoProvider);
    //     ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel);
    //   }
    // });

    print('current route 77 : ${ref.read(routerProvider).location()}');

    return WillPopScope(
      onWillPop: () async {
        print('loginscreen poppop');
        if (context.canPop()) {
          context.pop();
        } else {
          context.go("/home");
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              context.pushReplacement("/home");
            },
            icon: const Icon(
              Puppycat_social.icon_close,
              size: 40,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/character/character_00_login.png',
                width: 156,
                height: 156,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 84),
                child: Text(
                  '로그인.인트로 문구'.tr(),
                  style: kTitle18BoldStyle.copyWith(color: kPreviousTextTitleColor, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                spacing: 8,
                children: [
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(kKakaoLoginColor),
                      ),
                      onPressed: () {
                        ref.read(loginStateProvider.notifier).login(provider: 'kakao');
                      },
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "로그인.카카오로 계속하기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/kakao_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ).throttle(),
                  ),
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(kNaverLoginColor),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      onPressed: () {
                        ref.read(loginStateProvider.notifier).login(provider: 'naver');
                      },
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "로그인.네이버로 계속하기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousNeutralColor100),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/naver_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ).throttle(),
                  ),
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(kGoogleLoginColor),
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                            width: 1,
                            color: kPreviousNeutralColor400,
                          ),
                        ),
                      ),
                      onPressed: () {
                        ref.read(loginStateProvider.notifier).login(provider: 'google');
                      },
                      label: Padding(
                        padding: const EdgeInsets.only(left: 9.0),
                        child: Text(
                          "로그인.구글로 계속하기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/google_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ).throttle(),
                  ),
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(kAppleLoginColor),
                      ),
                      onPressed: () async {
                        ref.read(loginStateProvider.notifier).login(provider: 'apple');
                      },
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "로그인.애플로 계속하기".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousNeutralColor100),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/apple_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ).throttle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
