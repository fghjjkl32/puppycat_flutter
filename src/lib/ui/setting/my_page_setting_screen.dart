import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/package_info/package_info_util.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_menu_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/setting/my_page_setting_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/Admin/password_screen.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/custom_dialog.dart';
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
    final isLogined = ref.watch(loginStatementProvider);
    final myInfo = ref.read(myInfoStateProvider);
    final isOldVersion = ref.read(oldVersionStateProvider);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "설정.설정".tr(),
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
              title: '설정.알림'.tr(),
              onPressed: () async {
                print('isLogined $isLogined');
                if (await Permissions.getNotificationPermissionState()) {
                  !isLogined ? context.push("/home/login") : context.push("/setting/alarm");
                } else {
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Column(
                                children: [
                                  Text(
                                    "설정.푸시 알림 권한".tr(),
                                    style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "설정.언제든지 설정을 바꿀 수 있어요".tr(),
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
                              "설정.설정 열기".tr(),
                              style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                            ),
                            cancelWidget: Text(
                              "설정.닫기".tr(),
                              style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ));
                      },
                    );
                  }
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            ProfileButton(
              icon: const Icon(
                Puppycat_social.icon_user_block_ac,
                size: 20,
              ),
              title: '설정.차단 유저 관리'.tr(),
              onPressed: () {
                !isLogined ? context.push("/home/login") : context.push("/setting/blockedUser");
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_terms,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "설정.이용약관".tr(),
                    style: kBody14BoldStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 46,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                        context.push("/setting/policy", extra: extraMap);
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_etc,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "설정.기타".tr(),
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          '설정.앱 권한 설정'.tr(),
                          style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                        child: Text(
                          '설정.원활한 퍼피캣 앱 이용을 위해 접근 권한을 허용해 주세요'.tr(),
                          style: kTitle14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '설정.퍼피캣 권한 안내'.tr(),
                          style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: Divider(),
                      ),
                      Text(
                        "설정.카메라 (필수)".tr(),
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "설정.사진 촬영을 위해 필요한 권한이에요".tr(),
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "설정.저장 공간 (필수)".tr(),
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "설정.사진, 미디어, 파일 등을 사용 하기 위해 필요한 권한이에요".tr(),
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "설정.알림 (필수)".tr(),
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "설정.푸시 알림 수신을 위해 필요한 권한이에요".tr(),
                        style: kBody12RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                      ),
                      const SizedBox(
                        height: 10,
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
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 46,
                            decoration: const BoxDecoration(
                              color: kPreviousPrimaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '설정.앱 권한 설정하러 가기'.tr(),
                                style: kBody16MediumStyle.copyWith(
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
                padding: const EdgeInsets.only(top: 8, left: 50, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "설정.앱 권한 설정".tr(),
                      style: kBody14RegularStyle.copyWith(
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
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          "설정.저장 공간을 정리할까요?".tr(),
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
                        "설정.정리하기".tr(),
                        style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 50, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "설정.저장 공간 정리".tr(),
                      style: kBody14RegularStyle.copyWith(
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
              padding: const EdgeInsets.only(top: 8, left: 50, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "설정.최초 설치일".tr(),
                    style: kBody14RegularStyle.copyWith(
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
              padding: const EdgeInsets.only(top: 8, left: 50, right: 16, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "설정.앱 버전".tr(),
                    style: kBody14RegularStyle.copyWith(
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
                        // lastestBuildVersion == GetIt.I<PackageInformationUtil>().appVersion
                        isOldVersion
                            ? Text(
                                "설정.구 버전 사용 중".tr(),
                                style: kBadge10MediumStyle.copyWith(
                                  color: kPreviousTextBodyColor,
                                ),
                              )
                            : Text(
                                "설정.최신 버전".tr(),
                                style: kBadge10MediumStyle.copyWith(
                                  color: kPreviousTextBodyColor,
                                ),
                              ),
                        const SizedBox(
                          width: 10,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Puppycat_social.icon_cs,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "설정.고객지원".tr(),
                    style: kBody14BoldStyle.copyWith(
                      color: kPreviousTextSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push("/setting/faq");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Puppycat_social.icon_faq,
                              size: 40,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "설정.자주하는 질문".tr(),
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
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "설정.1:1 채널톡".tr(),
                              style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // context.go("/setting/notice");
                          context.push("/setting/notice");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Puppycat_social.icon_notice,
                              size: 40,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "설정.공지사항".tr(),
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
                      padding: const EdgeInsets.only(top: 60.0, bottom: 20),
                      child: Center(
                        child: Text(
                          "설정.로그아웃".tr(),
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 10,
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
