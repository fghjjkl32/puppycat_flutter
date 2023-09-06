import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/select_button.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';

class MyPageWithdrawalSelectScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalSelectScreen({super.key});

  @override
  MyPageWithdrawalSelectScreenState createState() => MyPageWithdrawalSelectScreenState();
}

class MyPageWithdrawalSelectScreenState extends ConsumerState<MyPageWithdrawalSelectScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(withdrawalStateProvider.notifier).getWithdrawalReasonList();
  }

  String? directInputText = "";
  int code = 0;

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
                icon: const Icon(
                  Puppycat_social.icon_back,
                  size: 40,
                ),
              ),
            ),
            body: Consumer(builder: (context, ref, child) {
              final withdrawalState = ref.watch(withdrawalStateProvider);
              final withdrawalLists = withdrawalState.list;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "탈퇴하시려는 이유를 알려주세요!",
                          style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "더 발전하는 포레스트의 중요한 자료로 활용하겠습니다.",
                          style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: withdrawalLists.length,
                          itemBuilder: (BuildContext context, int i) {
                            return SelectButton(
                              isDirectInput: withdrawalLists[i].code! == 7,
                              title: withdrawalLists[i].name!,
                              isSelected: code == withdrawalLists[i].code!,
                              onPressed: () {
                                setState(() {
                                  code = withdrawalLists[i].code!;
                                });
                              },
                              onTextChanged: (text) {
                                setState(() {
                                  directInputText = text ?? "";
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  code == 0 || (code == 7 && directInputText!.isEmpty)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/character/character_07_Withdrawal_ing_72.png',
                              height: 40,
                              width: 40,
                            ),
                            Text(
                              "정말 탈퇴하시겠어요?",
                              style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
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
                        onPressed: code == 0 || (code == 7 && directInputText!.isEmpty)
                            ? null
                            : () {
                                if (directInputText == "") {
                                  directInputText = null;
                                }
                                ref.read(withdrawalCodeProvider.notifier).state = code;
                                ref.read(withdrawalReasonProvider.notifier).state = directInputText;
                                context.go("/home/myPage/profileEdit/withdrawalSelect/withdrawalDetail");
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '다음',
                            style: kBody14BoldStyle.copyWith(color: code == 0 || (code == 7 && directInputText!.isEmpty) ? kTextSubTitleColor : kNeutralColor100),
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
