import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';

class MyPageWithdrawalDetailScreen extends ConsumerStatefulWidget {
  const MyPageWithdrawalDetailScreen(
      {required this.code, this.reason, super.key});

  final int code;
  final String? reason;

  @override
  MyPageWithdrawalDetailScreenState createState() =>
      MyPageWithdrawalDetailScreenState();
}

class MyPageWithdrawalDetailScreenState
    extends ConsumerState<MyPageWithdrawalDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onTap() {
    setState(() {
      isAgree = !isAgree;
    });
  }

  bool isAgree = false;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/feed_write/image/corgi-2 1.png',
                      height: 68.h,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      '''회원 탈퇴 후 7일 동안 활동 정보가 유지됩니다.
7일 이후 모든 활동 정보가 삭제되며,
삭제된 데이터는 복구되지 않습니다.
회원 탈퇴 후 7일 동안 재가입이 불가하니
중요한 정보가 있는지 탈퇴 전 확인해 주세요.''',
                      style:
                          kBody11RegularStyle.copyWith(color: kTextBodyColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kNeutralColor200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0.h, horizontal: 20.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "일상 공유 글, 산책 일지, 내 프로필 등",
                            style: kBody14BoldStyle.copyWith(
                                color: kTextSubTitleColor),
                          ),
                          Row(
                            children: [
                              Text(
                                "활동했던 기록이 삭제",
                                style: kBody14BoldStyle.copyWith(
                                    color: kPrimaryColor),
                              ),
                              Text(
                                "됩니다.",
                                style: kBody14BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "작성한 게시물",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "586개",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "저장한 게시물",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "4,578개",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "태그된 게시물",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "0개",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "포레스트와 함께한",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "2,279시간",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "우리 아이들과 산책한",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "589시간",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "즐거움을 공유한 친구들",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "5,890명",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0.h),
                            child: const Divider(
                              color: kNeutralColor300,
                            ),
                          ),
                          Text(
                            "참여 중인 대화방에서 모두 나가게 되고",
                            style: kBody14BoldStyle.copyWith(
                                color: kTextSubTitleColor),
                          ),
                          Row(
                            children: [
                              Text(
                                "대화 내용은 즉시 삭제",
                                style: kBody14BoldStyle.copyWith(
                                    color: kPrimaryColor),
                              ),
                              Text(
                                "됩니다.",
                                style: kBody14BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.0.h, horizontal: 8.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "참여 중인 대화방",
                                  style: kBody12RegularStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                                Text(
                                  "23개",
                                  style: kBody13BoldStyle.copyWith(
                                      color: kTextSubTitleColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0.w),
                    child: GestureDetector(
                      onTap: () {
                        onTap();
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: kPrimaryLightColor,
                            visualDensity: VisualDensity.standard,
                            value: isAgree,
                            checkColor: kPrimaryColor,
                            onChanged: (value) {
                              if (value != null) onTap();
                            },
                          ),
                          Text(
                            "모든 정보를 삭제하는 것에 동의합니다",
                            style: kBody12RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      ),
                    ),
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
                        onPressed: isAgree
                            ? () async {
                                final result = ref
                                    .read(withdrawalStateProvider.notifier)
                                    .withdrawalUser(
                                      idx: ref.read(userModelProvider)!.idx,
                                      code: widget.code + 1,
                                      reason: widget.reason == "null"
                                          ? null
                                          : widget.reason,
                                    );

                                await result
                                    ? context.push(
                                        "/home/myPage/profileEdit/withdrawalSelect/withdrawalDetail/withdrawalSuccess")
                                    : print("fail");
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '회원 탈퇴',
                            style: kBody14BoldStyle.copyWith(
                                color: isAgree
                                    ? kNeutralColor100
                                    : kTextSubTitleColor),
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
