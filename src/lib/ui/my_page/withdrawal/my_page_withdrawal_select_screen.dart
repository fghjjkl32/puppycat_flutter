import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/select_button.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

enum WithdrawalSelectEnum {
  deleteRecord,
  inconvenientUse,
  privacyConcern,
  lowUsage,
  contentDissatisfaction,
  preferOtherSite,
  directInput
}

class MyPageWithdrawalSelectScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalSelectScreen({super.key});

  @override
  MyPageWithdrawalSelectScreenState createState() =>
      MyPageWithdrawalSelectScreenState();
}

class MyPageWithdrawalSelectScreenState
    extends ConsumerState<MyPageWithdrawalSelectScreen> {
  final List<String> selectList = [
    "기록을 삭제하고 싶어요.",
    "이용이 불편하고 장애가 많아요.",
    "개인정보 유출이 우려돼요.",
    "사용 빈도가 낮아요.",
    "콘텐츠가 불만스러워요.",
    "다른 사이트가 더 좋아요.",
    "직접 입력할게요.",
  ];

  @override
  void initState() {
    super.initState();
  }

  String? directInputText = "";
  int code = 0;

  WithdrawalSelectEnum? withdrawalSelectStatus;

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
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "탈퇴하시려는 이유를 알려주세요!",
                        style: kTitle16ExtraBoldStyle.copyWith(
                            color: kTextTitleColor),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        "더 발전하는 포레스트의 중요한 자료로 활용하겠습니다.",
                        style:
                            kBody12RegularStyle.copyWith(color: kTextBodyColor),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: WithdrawalSelectEnum.values.length,
                        itemBuilder: (BuildContext context, int i) {
                          return SelectButton(
                            isDirectInput: withdrawalSelectStatus ==
                                WithdrawalSelectEnum.directInput,
                            title: selectList[i],
                            isSelected: withdrawalSelectStatus ==
                                WithdrawalSelectEnum.values[i],
                            onPressed: () {
                              setState(() {
                                withdrawalSelectStatus =
                                    WithdrawalSelectEnum.values[i];
                              });
                              code = i;
                            },
                            onTextChanged: (text) {
                              directInputText = text ?? "";
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  withdrawalSelectStatus == null ||
                          (withdrawalSelectStatus ==
                                  WithdrawalSelectEnum.directInput &&
                              directInputText!.isEmpty)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/feed_write/image/corgi-2 1.png',
                              height: 68.h,
                            ),
                            Text(
                              "정말 탈퇴하시겠어요?",
                              style: kBody12SemiBoldStyle.copyWith(
                                  color: kTextTitleColor),
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
                        onPressed: withdrawalSelectStatus == null ||
                                (withdrawalSelectStatus ==
                                        WithdrawalSelectEnum.directInput &&
                                    directInputText!.isEmpty)
                            ? null
                            : () {
                                if (directInputText == "") {
                                  directInputText = null;
                                }
                                context.go(
                                    "/home/myPage/profileEdit/withdrawalSelect/withdrawalDetail/$code/$directInputText");
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '다음',
                            style: kBody14BoldStyle.copyWith(
                                color: withdrawalSelectStatus == null
                                    ? kTextSubTitleColor
                                    : kNeutralColor100),
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
