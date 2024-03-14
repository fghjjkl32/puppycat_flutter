import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/select_button.dart';

class MyPageWithdrawalSelectScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalSelectScreen({super.key});

  @override
  MyPageWithdrawalSelectScreenState createState() => MyPageWithdrawalSelectScreenState();
}

class MyPageWithdrawalSelectScreenState extends ConsumerState<MyPageWithdrawalSelectScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.read(withdrawalStateProvider.notifier).getWithdrawalReasonList();
  }

  String? directInputText = "";
  int code = 0;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "회원.회원 탈퇴".tr(),
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
                      "회원.혹시 서비스에 불편함이 있으셨나요?".tr(),
                      style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "회원.탈퇴 사유를 남겨 주시면 더 발전하는 퍼피캣이 되겠습니다".tr(),
                      style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: withdrawalLists.length,
                      itemBuilder: (BuildContext context, int i) {
                        return SelectButton(
                          textController: textEditingController,
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
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
                                "회원.정말 탈퇴하시나요?".tr(),
                                style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextTitleColor),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: kPreviousNeutralColor400,
                          backgroundColor: kPreviousPrimaryColor,
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
                                context.push("/member/myPage/profileEdit/withdrawalSelect/withdrawalDetail");
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '회원.다음'.tr(),
                            style: kBody14BoldStyle.copyWith(color: code == 0 || (code == 7 && directInputText!.isEmpty) ? kPreviousTextSubTitleColor : kPreviousNeutralColor100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
