import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/router/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/user_restore_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/withDrawalPending_sheet_item.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';

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
        showCustomModalBottomSheet(context: context, widget: const WithDrawalPendingSheetItem());
        print('current route : ${ref.read(routerProvider).location()}');
        // context.push('/error_bottom_sheet');
      }
    });

    ref.listen(userRestoreStateProvider, (previous, next) {
      if (next) {
        print('current route 22 : ${ref.read(routerProvider).location()}');

        final userModel = ref.read(signUpUserInfoProvider);
        ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel);
      }
    });

    print('current route 77 : ${ref.read(routerProvider).location()}');

    return DefaultOnWillPopScope(
      onWillPop: () async {
        print('loginscreen poppop');
        if (context.canPop()) {
          context.pop();
        } else {
          context.pushReplacement("/home");
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Image.asset('assets/image/common/close.png'),
                splashRadius: 20,
                onPressed: () {
                  context.pushReplacement("/home");
                },
              )),
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
                padding: const EdgeInsets.only(top: 12.0, bottom: 94),
                child: Text(
                  'Close to you PUPPCAT\n더 가깝고🐱 더 사랑스럽개🐶',
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
                        backgroundColor: MaterialStateProperty.all<Color>(kKakaoLoginColor),
                      ),
                      onPressed: () {
                        ref.read(loginStateProvider.notifier).login(provider: 'kakao');
                      },
                      label: Text(
                        "카카오로 계속하기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/kakao_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
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
                      ),
                      onPressed: () {
                        ref.read(loginStateProvider.notifier).login(provider: 'naver');
                      },
                      label: Text(
                        "네이버로 계속하기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousNeutralColor100),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/naver_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
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
                      label: Text(
                        "구글로 계속하기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/google_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 264,
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(kAppleLoginColor),
                      ),
                      onPressed: () async {
                        ref.read(loginStateProvider.notifier).login(provider: 'apple');
                      },
                      label: Text(
                        "애플로 계속하기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousNeutralColor100),
                      ),
                      icon: Image.asset(
                        'assets/image/loginScreen/apple_icon.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
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
