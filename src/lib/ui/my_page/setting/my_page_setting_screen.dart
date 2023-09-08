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
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/my_page_setting_provider.dart';
import 'package:pet_mobile_social_flutter/ui/Admin/password_screen.dart';

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
    });
  }

  int adminCount = 0;
  int lastTap = DateTime.now().millisecondsSinceEpoch;

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
                onPressed: () {
                  ref.read(userModelProvider) == null ? context.pushReplacement("/loginScreen") : context.push("/home/myPage/setting/settingAlarm");
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
                  ref.read(userModelProvider) == null ? context.pushReplacement("/loginScreen") : context.go("/home/myPage/setting/settingBlockedUser");
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
                        color: kTextSubTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go("/home/myPage/setting/TermsOfService");
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kNeutralColor300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Text(
                                "서비스 이용약관",
                                style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go("/home/myPage/setting/PrivacyPolicy");
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kNeutralColor300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Text(
                                "개인정보 처리 방침",
                                style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go("/home/myPage/setting/PrivacyPolicyAccepted");
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kNeutralColor300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Text(
                                "개인정보 수집/이용 동의",
                                style: kBody11RegularStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        color: kTextSubTitleColor,
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
                            style: kTitle16ExtraBoldStyle.copyWith(color: kTextTitleColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0.h, bottom: 4.0.h),
                          child: Text(
                            '편리한 퍼피캣 앱 사용을 위해 접근 권한을 허용해 주세요.',
                            style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          '선택적 접근 권한은 해당 기능 이용 시 동의를 받고 있습니다.\n허용하지 않으셔도 포레스트 앱의 서비스를 이용 가능하며,\n일부 관련 서비스 이용 시 사용제 제한이 있을 수 있습니다.',
                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.h),
                          child: const Divider(),
                        ),
                        Text(
                          "저장 공간 (필수)",
                          style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "사진, 미디어, 파일 등의 이용 및 로그를 저장합니다.",
                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "전화 (필수)",
                          style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "PUSH 알림 발송을 위한 기기 ID를 확인합니다.",
                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "위치 서비스 (필수)",
                          style: kBody13BoldStyle.copyWith(color: kTextSubTitleColor),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          "맵 서비스 등 이용하실 때 가까운 정보 및\n장소를 찾으실 수 있도록 도와줍니다.",
                          style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            openAppSettings();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12.0.w),
                            child: Container(
                              height: 30.h,
                              decoration: const BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '앱 권한 설정하러 가기',
                                  style: kBody14BoldStyle.copyWith(
                                    color: kNeutralColor100,
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
                          color: kTextSubTitleColor,
                        ),
                      ),
                      const Icon(
                        Puppycat_social.icon_next_small,
                        size: 20,
                        color: kTextBodyColor,
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
                            "캐시를 삭제하시겠습니까?",
                            style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
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
                          "삭제",
                          style: kButton14MediumStyle.copyWith(color: kBadgeColor),
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
                        "캐시 삭제",
                        style: kBody13RegularStyle.copyWith(
                          color: kTextSubTitleColor,
                        ),
                      ),
                      Text(
                        "${NumberFormat('#.#').format(ref.watch(myPageSettingProvider))} MB",
                        style: kBody13RegularStyle.copyWith(
                          color: kTextSubTitleColor,
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
                        color: kTextSubTitleColor,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(DateTime.parse(firstInstallTime)),
                      style: kBody13RegularStyle.copyWith(
                        color: kTextSubTitleColor,
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
                        color: kTextSubTitleColor,
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
                                  "최신 버전 사용 중",
                                  style: kBadge10MediumStyle.copyWith(
                                    color: kTextBodyColor,
                                  ),
                                )
                              : Text(
                                  "구 버전 사용 중",
                                  style: kBadge10MediumStyle.copyWith(
                                    color: kTextBodyColor,
                                  ),
                                ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            GetIt.I<PackageInformationUtil>().appVersion,
                            style: kBody13RegularStyle.copyWith(
                              color: kTextSubTitleColor,
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
                        color: kTextSubTitleColor,
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
                    color: kNeutralColor100,
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
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Column(
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
                              style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                            ),
                          ],
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
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ref.read(userModelProvider) == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        ref.read(loginStateProvider.notifier).logout(
                              ref.read(userModelProvider)!.simpleType,
                              ref.read(userModelProvider)!.appKey,
                            );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 60.0.h, bottom: 20.h),
                        child: Center(
                          child: Text(
                            "로그아웃",
                            style: kButton12BoldStyle.copyWith(color: kTextBodyColor),
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
                    color: kTextSubTitleColor,
                  ),
                ),
              ],
            ),
            const Icon(
              Puppycat_social.icon_next_small,
              size: 20,
              color: kTextBodyColor,
            ),
          ],
        ),
      ),
    );
  }
}
