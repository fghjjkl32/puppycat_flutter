import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/my_page_setting_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_menu_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/Admin/password_screen.dart';
import 'package:uni_links/uni_links.dart';

class MyPageSettingScreen extends ConsumerStatefulWidget {
  const MyPageSettingScreen({super.key});

  @override
  MyPageSettingScreenState createState() => MyPageSettingScreenState();
}

class MyPageSettingScreenState extends ConsumerState<MyPageSettingScreen> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.watch(myPageSettingProvider.notifier).getCacheSizeInMB();
      ref.read(policyMenuStateProvider.notifier).getPoliciesMenu();
    });
    initUniLinks();
  }

  int adminCount = 0;
  int lastTap = DateTime.now().millisecondsSinceEpoch;

  initUniLinks() async {
    try {
      String? initialLink = await getInitialLink();
      if (initialLink != null && initialLink == "puppycat://ss") {
        print("안녕");
      }
      linkStream.listen((String? link) {
        if (link != null && link == "puppycat://ss") {
          print("안녕");
        }
      }, onError: (err) {
        // Handle the error here
      });
    } on Exception {
      // Handle the error here
    }
  }

  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

    return Material(
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
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: ListView(
          children: [
            ProfileButton(
              icon: const Icon(
                Puppycat_social.icon_bell,
                size: 20,
              ),
              title: '알림',
              onPressed: () async {
                if (await Permissions.getNotificationPermissionState()) {
                  !isLogined ? context.pushReplacement("/loginScreen") : context.push("/home/myPage/setting/settingAlarm");
                } else {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                            content: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0.h),
                              child: Column(
                                children: [
                                  Text(
                                    "푸시 알림을 받으려면\n알림 접근 권한이 필요해요.",
                                    style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    "언제든지 설정을 바꿀 수 있어요.",
                                    style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            confirmTap: () {
                              context.pop();
                              openAppSettings();
                            },
                            cancelTap: () {
                              context.pop();
                            },
                            confirmWidget: Text(
                              "설정 열기",
                              style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                            ),
                            cancelWidget: Text(
                              "닫기",
                              style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ));
                      },
                    );
                  }
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: const Divider(),
            ),
            ProfileButton(
              icon: const Icon(
                Puppycat_social.icon_user_block_ac,
                size: 20,
              ),
              title: '차단 유저 관리',
              onPressed: () {
                !isLogined ? context.pushReplacement("/loginScreen") : context.push("/home/myPage/setting/settingBlockedUser");
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: const Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 16.w),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_terms,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "이용약관",
                    style: kBody14BoldStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: ListView.builder(
                  itemCount: ref.watch(policyMenuStateProvider).length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final data = ref.watch(policyMenuStateProvider)[index];

                    bool isLastItem = index == ref.watch(policyMenuStateProvider).length - 1;

                    return GestureDetector(
                      onTap: () {
                        Map<String, dynamic> extraMap = {
                          'dateList': data.dateList,
                          'idx': data.idx,
                          'menuName': data.menuName!,
                        };

                        context.push("/home/myPage/setting/policy", extra: extraMap);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: isLastItem ? 0 : 12),
                        decoration: const BoxDecoration(
                          color: kPreviousNeutralColor300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: Text(
                              data.menuName!,
                              style: kBody11RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.h),
              child: const Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_etc,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "기타",
                    style: kBody14BoldStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                showCustomModalBottomSheet(
                  context: context,
                  widget: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0.h),
                        child: Text(
                          '앱 권한 설정',
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0.h, bottom: 4.0.h),
                        child: Text(
                          '원활한 퍼피캣 앱 이용을 위해 접근 권한을 허용해 주세요.',
                          style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '퍼피캣 이용에 꼭 필요한 접근 권한은\n해당 기능을 이용하시는 순간에 요청을 드리고 있어요.\n허용하지 않아도 퍼피캣을 이용하실 수 있지만,\n일부 서비스는 이용이 어려울 수 있어요.',
                          style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.h),
                        child: const Divider(),
                      ),
                      Text(
                        "저장 공간 (필수)",
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "사진, 미디어, 파일 등의 이용 및 로그를 저장해요.",
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "알림 (필수)",
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "푸시 알림 발송을 위해 기기 ID를 확인해요.",
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // Text(
                      //   "위치 서비스 (필수)",
                      //   style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                      // ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // Text(
                      //   "맵 서비스 등 이용하실 때 가까운 정보 및\n장소를 찾으실 수 있도록 도와줍니다.",
                      //   style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                      //   textAlign: TextAlign.center,
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      GestureDetector(
                        onTap: () {
                          openAppSettings();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12.0.w),
                          child: Container(
                            height: 30.h,
                            decoration: const BoxDecoration(
                              color: kPreviousPrimaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '앱 권한 설정하러 가기',
                                style: kBody14BoldStyle.copyWith(
                                  color: kPreviousNeutralColor100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 50.w, right: 16.w, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "앱 권한 설정",
                      style: kBody13RegularStyle.copyWith(
                        color: kPreviousTextSubTitleColor,
                      ),
                    ),
                    const Icon(
                      Puppycat_social.icon_next_small,
                      size: 20,
                      color: kPreviousTextBodyColor,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      content: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0.h),
                        child: Text(
                          "저장 공간을 정리할까요?",
                          style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      confirmTap: () {
                        context.pop();
                        ref.watch(myPageSettingProvider.notifier).clearCache(context);
                      },
                      cancelTap: () {
                        context.pop();
                      },
                      confirmWidget: Text(
                        "정리하기",
                        style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 50.w, right: 16.w, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "저장 공간 정리",
                      style: kBody13RegularStyle.copyWith(
                        color: kPreviousTextSubTitleColor,
                      ),
                    ),
                    Text(
                      "${NumberFormat('#.#').format(ref.watch(myPageSettingProvider))} MB",
                      style: kBody13RegularStyle.copyWith(
                        color: kPreviousTextSubTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h, left: 50.w, right: 16.w, bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "최초 설치일",
                    style: kBody13RegularStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(DateTime.parse(firstInstallTime)),
                    style: kBody13RegularStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.h, left: 50.w, right: 16.w, bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "앱 버전",
                    style: kBody13RegularStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      int now = DateTime.now().millisecondsSinceEpoch;
                      print('now - lastTap ${now - lastTap}');
                      // if (now - lastTap < 500) {
                      print('run?????');
                      adminCount++;
                      if (adminCount >= 10) {
                        // Do something
                        adminCount = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PasswordScreen()),
                        );
                      }
                      // }
                      // else {
                      //   adminCount = 0;
                      // }
                      lastTap = now;
                    },
                    child: Row(
                      children: [
                        lastestBuildVersion == GetIt.I<PackageInformationUtil>().appVersion
                            ? Text(
                                "최신 버전",
                                style: kBadge10MediumStyle.copyWith(
                                  color: kPreviousTextBodyColor,
                                ),
                              )
                            : Text(
                                "구 버전 사용 중",
                                style: kBadge10MediumStyle.copyWith(
                                  color: kPreviousTextBodyColor,
                                ),
                              ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          GetIt.I<PackageInformationUtil>().appVersion,
                          style: kBody13RegularStyle.copyWith(
                            color: kPreviousTextSubTitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: const Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 16.w),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_cs,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "고객지원",
                    style: kBody14BoldStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: kPreviousNeutralColor100,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go("/home/myPage/setting/FAQ");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Puppycat_social.icon_faq,
                              size: 40,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "자주하는 질문",
                              style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          !isLogined
                              ? await ChannelTalk.boot(
                                  pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                                )
                              : await ChannelTalk.boot(
                                  pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                                  memberId: myInfo.uuid,
                                  email: myInfo.email,
                                  name: myInfo.name,
                                  memberHash: myInfo.channelTalkHash,
                                  mobileNumber: myInfo.phone,
                                );
                          await ChannelTalk.showMessenger();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Puppycat_social.icon_canneltalk,
                              size: 40,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "1:1 채널톡",
                              style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go("/home/myPage/setting/notice");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Puppycat_social.icon_notice,
                              size: 40,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "공지사항",
                              style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !isLogined
                ? Container()
                : GestureDetector(
                    onTap: () {
                      ref.read(loginStateProvider.notifier).logout(
                            myInfo.simpleType ?? '',
                          );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.0.h, bottom: 20.h),
                      child: Center(
                        child: Text(
                          "로그아웃",
                          style: kButton12BoldStyle.copyWith(color: kPreviousTextBodyColor),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final Widget icon;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  title,
                  style: kBody14BoldStyle.copyWith(
                    color: kPreviousTextSubTitleColor,
                  ),
                ),
              ],
            ),
            const Icon(
              Puppycat_social.icon_next_small,
              size: 20,
              color: kPreviousTextBodyColor,
            ),
          ],
        ),
      ),
    );
  }
}
