import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class MyPageWithdrawalSuccessScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalSuccessScreen({super.key});

  @override
  MyPageWithdrawalSuccessScreenState createState() => MyPageWithdrawalSuccessScreenState();
}

class MyPageWithdrawalSuccessScreenState extends ConsumerState<MyPageWithdrawalSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () async {
        ref.watch(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(loginStateProvider.notifier).state = LoginStatus.none;
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "회원 탈퇴",
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/character/character_07_Withdrawal_complete.png',
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "지금은 퍼피캣을 떠나시지만,\n다시 만나길 바랄게요!",
                  style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPreviousNeutralColor200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "새 계정은 ",
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "7일이 지나면",
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousPrimaryColor),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          " 만들 수 있어요.",
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "더 나은 퍼피캣을 위해 의견을 남겨 주셔서 감사해요.\n모든 기기에서 안전하게 로그아웃 처리할게요.",
                  style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0.w,
                    right: 20.0.w,
                    bottom: 20.0.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: kPreviousNeutralColor400,
                        backgroundColor: kPreviousPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        ref.watch(loginRouteStateProvider.notifier).state = LoginRoute.none;
                        ref.read(loginStateProvider.notifier).state = LoginStatus.none;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          '확인',
                          style: kBody14BoldStyle.copyWith(color: kPreviousNeutralColor100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
