import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_detail_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class MyPageWithdrawalDetailScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalDetailScreen({super.key});

  @override
  MyPageWithdrawalDetailScreenState createState() => MyPageWithdrawalDetailScreenState();
}

class MyPageWithdrawalDetailScreenState extends ConsumerState<MyPageWithdrawalDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(withdrawalDetailStateProvider.notifier).getWithdrawalDetailList();
  }

  void onTap() {
    setState(() {
      isAgree = !isAgree;
    });
  }

  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);

    return Material(
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
          final withdrawalState = ref.watch(withdrawalDetailStateProvider);
          final withdrawalInfo = withdrawalState.memberInfo;
          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/character/character_07_Withdrawal_ing_72.png',
                    height: 68,
                    width: 68,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '''활동한 정보는 돌아오실 경우를 위해 
                    7일간 유지하고 그 이후엔 전부 삭제돼요.
                    ''',
                    style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPreviousNeutralColor200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${myInfo.nick}님이",
                          style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                        ),
                        Row(
                          children: [
                            Text(
                              "퍼피캣과 함께한 ",
                              style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                            Text(
                              "활동 정보",
                              style: kBody14BoldStyle.copyWith(color: kPreviousPrimaryColor),
                            ),
                            Text(
                              "예요.",
                              style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "작성한 피드",
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "${withdrawalInfo?.totalContentsCnt ?? 0}개",
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "저장한 피드",
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "${withdrawalInfo?.totalSaveCnt ?? 0}개",
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "태그된 피드",
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "${withdrawalInfo?.totalTagCnt ?? 0}개",
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "포레스트와 함께한",
                                style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                              Text(
                                "${withdrawalInfo?.totalActivityTime ?? 0}",
                                style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 8.0.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "우리 아이들과 산책한",
                        //         style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //       Text(
                        //         "589시간",
                        //         style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 8.0.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "즐거움을 공유한 친구들",
                        //         style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //       Text(
                        //         "5,890명",
                        //         style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        //   child: const Divider(
                        //     color: kNeutralColor300,
                        //   ),
                        // ),
                        // Text(
                        //   "참여 중인 대화방에서 모두 나가게 되고",
                        //   style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
                        // ),
                        // Row(
                        //   children: [
                        //     Text(
                        //       "대화 내용은 즉시 삭제",
                        //       style: kBody14BoldStyle.copyWith(color: kPrimaryColor),
                        //     ),
                        //     Text(
                        //       "됩니다.",
                        //       style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 4.h,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 8.0.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         "참여 중인 대화방",
                        //         style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //       Text(
                        //         "23개",
                        //         style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
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
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () {
                    onTap();
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: kPreviousPrimaryLightColor,
                        visualDensity: VisualDensity.standard,
                        value: isAgree,
                        checkColor: kPreviousPrimaryColor,
                        onChanged: (value) {
                          if (value != null) onTap();
                        },
                      ),
                      Text(
                        "모든 정보 삭제 동의하기",
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
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
                    onPressed: isAgree
                        ? () async {
                            final result = await ref.read(withdrawalStateProvider.notifier).withdrawalUser(
                                  code: ref.read(withdrawalCodeProvider.notifier).state,
                                  reason: ref.read(withdrawalReasonProvider.notifier).state == "null" ? null : ref.read(withdrawalReasonProvider.notifier).state,
                                );

                            // if (result && mounted) {
                            //   print('withdrawalSuccess');
                            //   context.push("/member/myPage/profileEdit/withdrawalSelect/withdrawalDetail/withdrawalSuccess");
                            // }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '탈퇴하기',
                        style: kBody14BoldStyle.copyWith(color: isAgree ? kPreviousNeutralColor100 : kPreviousTextSubTitleColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
