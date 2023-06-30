import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class SignUpCompleteScreen extends ConsumerWidget {
  const SignUpCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/signUpScreen/corgi_1.png'),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    '회원가입.퍼피캣의 가족이 되신 걸 환영해요'.tr(),
                    style: kTitle14BoldStyle.copyWith(height: 1.4, color: kTextTitleColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '회원가입.회원가입 환영 메시지'.tr(),
                    style: kBody12RegularStyle.copyWith(height: 1.3, color: kTextBodyColor),
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
                  width: 320.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      var userModel = ref.read(userModelProvider);
                      ref.read(loginStateProvider.notifier).loginByUserModel(userModel: userModel!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      disabledBackgroundColor: kNeutralColor400,
                      disabledForegroundColor: kTextBodyColor,
                      elevation: 0,
                    ),
                    child: Text(
                      '회원가입.퍼피캣 이용하기'.tr(),
                      style: kButton14BoldStyle,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
