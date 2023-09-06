import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';

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
    return WillPopScope(
      onWillPop: () async {
        ref.watch(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(loginStateProvider.notifier).state = LoginStatus.none;

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            ref.watch(loginRouteStateProvider.notifier).state = LoginRoute.none;
            ref.read(loginStateProvider.notifier).state = LoginStatus.none;

            return false;
          },
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
                    "그동안 퍼피캣을\n이용해 주셔서 감사합니다.",
                    style: kBody14BoldStyle.copyWith(color: kTextTitleColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kNeutralColor200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "새 계정을 원하시면",
                            style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            " 7일 이후 ",
                            style: kBody12SemiBoldStyle.copyWith(color: kPrimaryColor),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "가능합니다!",
                            style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
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
                    "회원 탈퇴가 완료되었습니다.\n보다 나은 서비스로 다시 만나길 바랍니다.",
                    style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
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
                          disabledBackgroundColor: kNeutralColor400,
                          backgroundColor: kPrimaryColor,
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
                            style: kBody14BoldStyle.copyWith(color: kNeutralColor100),
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
      ),
    );
  }
}
