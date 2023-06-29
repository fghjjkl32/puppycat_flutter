import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class MyPageWithdrawalSuccessScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalSuccessScreen({super.key});

  @override
  MyPageWithdrawalSuccessScreenState createState() =>
      MyPageWithdrawalSuccessScreenState();
}

class MyPageWithdrawalSuccessScreenState
    extends ConsumerState<MyPageWithdrawalSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            context.pop();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text(
                "회원 탈퇴",
              ),
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/feed_write/image/corgi-2 1.png',
                    height: 68.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "그동안 포레스트를\n이용해 주셔서 감사합니다.",
                    style: kBody14BoldStyle.copyWith(color: kTextTitleColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    "회원 탈퇴가 완료되었으며 7일 후 재가입이 가능합니다.\n보다 나은 서비스로 다시 만나길 바랍니다.",
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
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '확인',
                            style: kBody14BoldStyle.copyWith(
                                color: kNeutralColor100),
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
