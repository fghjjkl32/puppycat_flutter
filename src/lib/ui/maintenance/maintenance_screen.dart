import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class InspectScreen extends ConsumerStatefulWidget {
  const InspectScreen({super.key});

  @override
  InspectScreenState createState() => InspectScreenState();
}

class InspectScreenState extends ConsumerState<InspectScreen> {
  @override
  Widget build(BuildContext context) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

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
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('yyyy년 MM월 dd일 (EEE) hh:mm', 'ko_KR').format(DateTime.parse(ref.watch(inspectProvider).startDate)),
                                    style: kBody13BoldStyle.copyWith(color: kPreviousErrorColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "~ ${DateFormat('yyyy년 MM월 dd일 (EEE) hh:mm', 'ko_KR').format(DateTime.parse(ref.watch(inspectProvider).endDate))}",
                                    style: kBody13BoldStyle.copyWith(color: kPreviousErrorColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
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
                            ref.watch(inspectProvider).message == null || ref.watch(inspectProvider).message == ''
                                ? Text(
                                    "이용에 불편을 드려 죄송해요.\n안정적인 서비스를 위해 서버를 점검하고 있어요.\n더 좋은 모습으로 돌아올게요.",
                                    style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                    textAlign: TextAlign.center,
                                  )
                                : Html(
                                    data: ref.watch(inspectProvider).message,
                                    style: {
                                      "*": Style(
                                        textAlign: TextAlign.center,
                                        fontFamily: "pretendard",
                                        fontSize: FontSize(12.0),
                                        fontWeight: FontWeight.w500,
                                        color: kPreviousTextBodyColor,
                                      ),
                                    },
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
