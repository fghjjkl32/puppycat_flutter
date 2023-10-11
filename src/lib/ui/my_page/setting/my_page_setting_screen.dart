import 'dart:convert';
import 'dart:typed_data';

import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/dialog/custom_dialog.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/my_page_setting_provider.dart';
import 'package:pet_mobile_social_flutter/ui/Admin/password_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/channel_talk_webview_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';
import 'package:tosspayments_sdk_flutter/model/tosspayments_url.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onPressed: () {
                ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.push("/home/myPage/setting/settingAlarm");
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
                ref.read(userInfoProvider).userModel == null ? context.pushReplacement("/loginScreen") : context.go("/home/myPage/setting/settingBlockedUser");
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
                      GestureDetector(
                        onTap: () async {
                          // Navigator.of(context).push(
                          //   PageRouteBuilder(
                          //     opaque: false, // set to false
                          //     pageBuilder: (_, __, ___) => const ChannelTalkWebViewScreen(),
                          //   ),
                          // );

                          // TODO: 채널톡 유료 버전 결제되면 SDK를 이용하여 변경 예정.
                          // await ChannelTalk.boot(
                          //   pluginKey: '245ceed2-c934-4622-a9e3-893158f5555c',
                          //   memberId: '2',
                          //   email: 'fghjjkl2700@naver.com',
                          //   name: '전건우',
                          //   memberHash: '798c5e01e2eefd109eb297ba94473c9630e7a4f3b559f52a132c754358165e59',
                          //   mobileNumber: '+821084287578',
                          //   // trackDefaultEvent: false,
                          //   // hidePopup: false,
                          //   // language: 'english',
                          // );
                          //
                          // await ChannelTalk.showMessenger();

                          // final tossCertSessionGenerator = TossCertSessionGenerator();
                          // final tossCertSession = tossCertSessionGenerator.generate();
                          // final sessionKey = tossCertSession.getSessionKey();
                          //
                          // print(sessionKey);

                          final txId = await ref.read(authStateProvider.notifier).getTossAuthUrl();

                          //------------------------------------------------------------
                          // String sessionId = generateSessionId();
                          // String secretKey = generateRandomBytes(16);
                          // String iv = generateRandomBytes(12);
                          // String base64PublicKey =
                          //     'MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAoVdxG0Qi9pip46Jw9ImSlPVD8+L2mM47ey6EZna7D7utgNdh8Tzkjrm1Yl4h6kPJrhdWvMIJGS51+6dh041IXcJEoUquNblUEqAUXBYwQM8PdfnS12SjlvZrP4q6whBE7IV1SEIBJP0gSK5/8Iu+uld2ctJiU4p8uswL2bCPGWdvVPltxAg6hfAG/ImRUKPRewQsFhkFvqIDCpO6aeaR10q6wwENZltlJeeRnl02VWSneRmPqqypqCxz0Y+yWCYtsA+ngfZmwRMaFkXcWjaWnvSqqV33OAsrQkvuBHWoEEkvQ0P08+h9Fy2+FhY9TeuukQ2CVFz5YyOhp25QtWyQI+IaDKk+hLxJ1APR0c3tmV0ANEIjO6HhJIdu2KQKtgFppvqSrZp2OKtI8EZgVbWuho50xvlaPGzWoMi9HSCb+8ARamlOpesxHH3O0cTRUnft2Zk1FHQb2Pidb2z5onMEnzP2xpTqAIVQyb6nMac9tof5NFxwR/c4pmci+1n8GFJIFN18j2XGad1mNyio/R8LabqnzNwJC6VPnZJz5/pDUIk9yKNOY0KJe64SRiL0a4SNMohtyj6QlA/3SGxaEXb8UHpophv4G9wN1CgfyUamsRqp8zo5qDxBvlaIlfkqJvYPkltj7/23FHDjPi8q8UkSiAeu7IV5FTfB5KsiN8+sGSMCAwEAAQ=='; // 여기에 실제 Base64 인코딩된 공개키를 추가하세요
                          // String dataToEncrypt = 'Hello, Flutter!';
                          //
                          // String sessionKey = generateSessionKey(sessionId, secretKey, iv, base64PublicKey);
                          // String encryptedData = encryptData(sessionId, secretKey, iv, dataToEncrypt);
                          //
                          // print('Session ID: $sessionId');
                          // print('Secret Key: $secretKey');
                          // print('IV: $iv');
                          // print('Session Key: $sessionKey');
                          // print('Encrypted Data: $encryptedData');
                          //
                          // String decryptedData = decryptData(secretKey, iv, encryptedData);
                          // print('Decrypted Data: $decryptedData');
                          //------------------------------------------------------------

                          // await launch("puppycat://ss");
                          //
                          // final appScheme = ConvertUrl(
                          //     "intent://toss-cert/v2/sign/user/auth?txId=112949ac-7a8e-4ef3-aff7-f1a21e6d1022&_minVerAos=5.36.0&_minVerIos=5.10.0#Intent;scheme=supertoss;package=viva.republica.toss;end"); // Intent URL을 앱 스킴 URL로 변환
                          //
                          // print(appScheme);
                          //
                          // print(appScheme.appScheme);
                          // print(appScheme.url);
                          //
                          // if (appScheme.isAppLink()) {
                          //   print(appScheme.appLink);
                          //
                          //   await appScheme.launchApp();
                          // }

                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print(appScheme);
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");
                          // print("-----------------------------------------------");

                          Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) => WebViewWidget(
                                url: 'https://auth.cert.toss.im/start?serviceType=SIGN_USER_AUTH',
                                initialUrlRequest: URLRequest(
                                  url: WebUri("https://auth.cert.toss.im/start?serviceType=SIGN_USER_AUTH"),
                                  method: 'POST',
                                  headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                  },
                                  body: Uint8List.fromList(
                                    utf8.encode('txId=$txId'),
                                  ),
                                ),
                              ),
                            ),
                          );
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
                              style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
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
            ref.read(userInfoProvider).userModel == null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      ref.read(loginStateProvider.notifier).logout(
                            ref.read(userInfoProvider).userModel!.simpleType,
                            ref.read(userInfoProvider).userModel!.appKey,
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
