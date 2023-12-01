import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  MaintenanceScreenState createState() => MaintenanceScreenState();
}

class MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      init();
    });
  }

  String time = "";

  Future<void> init() async {
    await getMaintenanceTime();
  }

  Future<void> getMaintenanceTime() async {
    const int maxRetries = 3;
    int currentRetries = 0;

    final remoteConfig = FirebaseRemoteConfig.instance;

    while (currentRetries < maxRetries) {
      try {
        await remoteConfig.fetchAndActivate();
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));

        setState(() {
          time = remoteConfig.getString("service_title");
        });
      } catch (e) {
        currentRetries++; // 재시도 횟수를 증가시킵니다.
        if (currentRetries == maxRetries) {
          print("Remote Config 데이터를 가져오는 데 실패했습니다: $e");
        } else {
          print("재시도 중... ($currentRetries/$maxRetries)");
          await Future.delayed(Duration(seconds: 2)); // 2초 동안 기다립니다.
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            body: Center(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/image/character/character_09_service_check.png',
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPreviousNeutralColor200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            Text(
                              "서비스 점검 중",
                              style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                time,
                                style: kBody13BoldStyle.copyWith(color: kPreviousErrorColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Divider(
                                thickness: 1,
                                color: kPreviousNeutralColor100,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "이용에 불편을 드려 죄송합니다.\n안정적인 서비스를 위해 서버 점검 후\n더 좋은 모습으로 찾아뵙겠습니다.",
                              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          disabledBackgroundColor: kPreviousNeutralColor400,
                          backgroundColor: kPreviousPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          ref.read(userInfoProvider).userModel == null
                              ? await ChannelTalk.boot(
                                  pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                                )
                              : await ChannelTalk.boot(
                                  pluginKey: 'cb3dc42b-c554-4722-b8d3-f25be06cadb3',
                                  memberId: ref.read(userInfoProvider).userModel!.uuid,
                                  email: ref.read(userInfoProvider).userModel!.id,
                                  name: '${ref.read(userInfoProvider).userModel!.name}',
                                  memberHash: ref.read(userInfoProvider).userModel!.channelTalkHash,
                                  mobileNumber: '${ref.read(userInfoProvider).userModel!.phone}',
                                );
                          await ChannelTalk.showMessenger();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            '1:1 채널톡',
                            style: kBody14BoldStyle.copyWith(color: kPreviousNeutralColor100),
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
