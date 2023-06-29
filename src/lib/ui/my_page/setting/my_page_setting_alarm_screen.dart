import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class MyPageSettingAlarmScreen extends ConsumerStatefulWidget {
  const MyPageSettingAlarmScreen({super.key});

  @override
  MyPageSettingAlarmScreenState createState() =>
      MyPageSettingAlarmScreenState();
}

class MyPageSettingAlarmScreenState
    extends ConsumerState<MyPageSettingAlarmScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onTap() {
    setState(() {
      testValue = !testValue;
    });
  }

  bool testValue = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          context.pop();

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text(
              "설정",
            ),
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "활동 알림",
                      style: kBody14BoldStyle.copyWith(
                        color: kTextSubTitleColor,
                      ),
                    ),
                    FlutterSwitch(
                      padding: 4,
                      width: 34.w,
                      height: 16.h,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: kNeutralColor500,
                      toggleSize: 12.0.w,
                      value: testValue,
                      borderRadius: 50.0.w,
                      onToggle: (value) async {
                        onTap();
                      },
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: testValue ? 140.h : 0,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "새로운 팔로워",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "내 글(댓글) 좋아요",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "멘션(태그)",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "댓글",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "팔로잉 새 글 알림",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "채팅 알림",
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34.w,
                            height: 16.h,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kNeutralColor500,
                            toggleSize: 12.0.w,
                            value: testValue,
                            borderRadius: 50.0.w,
                            onToggle: (value) async {
                              onTap();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: const Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                child: Text(
                  "혜택 및 이벤트 알림",
                  style: kBody14BoldStyle.copyWith(
                    color: kTextSubTitleColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "앱 PUSH",
                      style: kBody13RegularStyle.copyWith(
                        color: kTextSubTitleColor,
                      ),
                    ),
                    FlutterSwitch(
                      padding: 4,
                      width: 34.w,
                      height: 16.h,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: kNeutralColor500,
                      toggleSize: 12.0.w,
                      value: testValue,
                      borderRadius: 50.0.w,
                      onToggle: (value) async {
                        if (value) {
                          toast(
                              context: context,
                              text: '광고성 정보 수신 여부가 ‘동의’로 변경되었습니다.',
                              type: ToastType.purple,
                              secondText:
                                  "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                        } else {
                          toast(
                              context: context,
                              text: '광고성 정보 수신 여부가 ‘거부’로 변경되었습니다.',
                              type: ToastType.grey,
                              secondText:
                                  "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                        }

                        onTap();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: const Divider(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                child: Text(
                  "야간 알림",
                  style: kBody14BoldStyle.copyWith(
                    color: kTextSubTitleColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 4.h, bottom: 4.h, left: 36.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "매너 모드",
                          style: kBody13RegularStyle.copyWith(
                            color: kTextSubTitleColor,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "밤 9시부터 아침 8시까지 알림을 받지 않습니다.",
                          style: kBody11RegularStyle.copyWith(
                            color: kTextBodyColor,
                          ),
                        ),
                      ],
                    ),
                    FlutterSwitch(
                      padding: 4,
                      width: 34.w,
                      height: 16.h,
                      activeColor: Theme.of(context).primaryColor,
                      inactiveColor: kNeutralColor500,
                      toggleSize: 12.0.w,
                      value: testValue,
                      borderRadius: 50.0.w,
                      onToggle: (value) async {
                        if (value) {
                          toast(
                              context: context,
                              text: '야간에도 정보/활동 등 모든 알림이 발송됩니다.',
                              type: ToastType.purple,
                              secondText:
                                  "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                        } else {
                          toast(
                              context: context,
                              text: '야간에는 정보/활동 등 모든 알림이 오지 않습니다.',
                              type: ToastType.grey,
                              secondText:
                                  "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                        }
                        onTap();
                      },
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
