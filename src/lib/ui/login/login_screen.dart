import 'dart:convert';

import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/sheets/withDrawalPending_sheet_item.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/user/user_restore_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/kakao/kakao_login.dart';
import 'package:pet_mobile_social_flutter/ui/dialog/restriction_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    ref.listen(loginStateProvider, (previous, next) {
      if (next == LoginStatus.withdrawalPending) {
        showCustomModalBottomSheet(context: context, widget: const WithDrawalPendingSheetItem());
      } else if (next == LoginStatus.restriction) {
        ///TODO
        ///API 호출
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const RestrictionDialog(
            isForever: false,
          ),
        );
      }
    });

    ref.listen(userRestoreStateProvider, (previous, next) {
      if (next) {
        var userModel = ref.read(userInfoProvider).userModel;
        ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
              'assets/image/loginScreen/login_intro.png',
              width: 157,
              height: 116,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 94),
              child: Text(
                '소중한 내 아이의 추억을\n기록하고 공유해보세요!',
                style: kTitle18BoldStyle.copyWith(color: kTextTitleColor, height: 1.4),
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
                      "카카오로 시작하기",
                      style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                    ),
                    icon: Image.asset('assets/image/loginScreen/kakao_icon.png'),
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
                      "네이버로 시작하기",
                      style: kButton14MediumStyle.copyWith(color: kNeutralColor100),
                    ),
                    icon: Image.asset('assets/image/loginScreen/naver_icon.png'),
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
                          color: kNeutralColor400,
                        ),
                      ),
                    ),
                    onPressed: () {
                      ref.read(loginStateProvider.notifier).login(provider: 'google');
                    },
                    label: Text(
                      "구글로 시작하기",
                      style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                    ),
                    icon: Image.asset('assets/image/loginScreen/google_icon.png'),
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
                      "애플로 시작하기",
                      style: kButton14MediumStyle.copyWith(color: kNeutralColor100),
                    ),
                    icon: Image.asset('assets/image/loginScreen/apple_icon.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
