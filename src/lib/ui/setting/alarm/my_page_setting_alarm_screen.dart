import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/setting/setting_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

class MyPageSettingAlarmScreen extends ConsumerStatefulWidget {
  const MyPageSettingAlarmScreen({super.key});

  @override
  MyPageSettingAlarmScreenState createState() => MyPageSettingAlarmScreenState();
}

class MyPageSettingAlarmScreenState extends ConsumerState<MyPageSettingAlarmScreen> {
  @override
  void initState() {
    Future(() {
      ref.read(settingStateProvider.notifier).initSetting();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final switchState = ref.watch(settingStateProvider).switchState;
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    Future<void> onTap(String key, bool value) async {
      int newValue = value ? 1 : 0;

      ref.read(settingStateProvider.notifier).updateSwitchState(key, newValue);

      Map<String, dynamic> data = {};

      Map<String, int> newSwitchState = Map.from(ref.watch(settingStateProvider).switchState);

      data.addAll(newSwitchState);

      await ref.read(settingStateProvider.notifier).putSetting(
            body: data,
          );
    }

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "알림",
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
        body: Consumer(builder: (ctx, ref, child) {
          final settingState = ref.watch(settingStateProvider);
          return settingState.mainList.isEmpty
              ? Container()
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "광고성 정보 수신 동의",
                            style: kBody14BoldStyle.copyWith(
                              color: kPreviousTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34,
                            height: 16,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kPreviousNeutralColor500,
                            toggleSize: 12.0,
                            value: switchState['main_2'] == 1,
                            borderRadius: 50.0,
                            onToggle: (value) async {
                              onTap('main_2', value);

                              if (value) {
                                toast(context: context, text: '광고성 정보 수신을 ‘동의’했어요.', type: ToastType.purple, secondText: "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                              } else {
                                toast(context: context, text: '광고성 정보 수신을 ‘거부’했어요.', type: ToastType.grey, secondText: "수신 거부일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: switchState['main_2'] == 1 ? 54 : 0,
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "야간 알림",
                                      style: kBody13RegularStyle.copyWith(
                                        color: kPreviousTextSubTitleColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "밤 9시부터 아침 8시까지 알림 받기",
                                      style: kBody11RegularStyle.copyWith(
                                        color: kPreviousTextBodyColor,
                                      ),
                                    ),
                                  ],
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['main_3'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('main_3', value);
                                    if (value) {
                                      toast(context: context, text: '야간 알림을 ‘동의’했어요.', type: ToastType.purple, secondText: "수신 동의일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                                    } else {
                                      toast(context: context, text: '야간 알림을 ‘거부’했어요.', type: ToastType.grey, secondText: "수신 거부일: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "커뮤니티 알림",
                            style: kBody14BoldStyle.copyWith(
                              color: kPreviousTextSubTitleColor,
                            ),
                          ),
                          FlutterSwitch(
                            padding: 4,
                            width: 34,
                            height: 16,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: kPreviousNeutralColor500,
                            toggleSize: 12.0,
                            value: switchState['main_1'] == 1,
                            borderRadius: 50.0,
                            onToggle: (value) async {
                              onTap('main_1', value);
                            },
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: switchState['main_1'] == 1 ? 200 : 0,
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "새로운 팔로워",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_1'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_1', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "내 글(댓글) 좋아요",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_2'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_2', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "멘션(태그)",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_3'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_3', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "댓글",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_4'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_4', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "팔로잉 새 글 알림",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_5'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_5', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 36, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "채팅 알림",
                                  style: kBody13RegularStyle.copyWith(
                                    color: kPreviousTextSubTitleColor,
                                  ),
                                ),
                                FlutterSwitch(
                                  padding: 4,
                                  width: 34,
                                  height: 16,
                                  activeColor: Theme.of(context).primaryColor,
                                  inactiveColor: kPreviousNeutralColor500,
                                  toggleSize: 12.0,
                                  value: switchState['sub_1_6'] == 1,
                                  borderRadius: 50.0,
                                  onToggle: (value) async {
                                    onTap('sub_1_6', value);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
