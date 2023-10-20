import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/channel_talk_webview_screen.dart';

class RestrictionDialog extends ConsumerWidget {
  final bool isForever;
  final String foreverRestrictionTitle = "활동이 영구 정지되었습니다.";
  final String restrictionTitle = "활동이 일시적으로 제한된 계정입니다.";
  final String restrictionBody = "자세한 내용은\n1:1채널톡으로 문의해주세요.";
  final String? restrictionPeriod;
  final int? date;
  final String? startDate;
  final String? endDate;
  final String? restrainName;

  const RestrictionDialog({
    Key? key,
    this.isForever = true,
    this.date,
    this.startDate,
    this.endDate,
    this.restrictionPeriod,
    this.restrainName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 40,
      ),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0.h),
              child: Column(
                children: [
                  Text(
                    "퍼피캣에서의\n활동이 제한되었습니다.",
                    style: kBody16BoldStyle.copyWith(color: kTextTitleColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "제재와 관련된 문의 및 이의 신청은\n1:1 채널톡으로 문의해 주세요.",
                    style: kBody12RegularStyle.copyWith(color: kTextBodyColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: kNeutralColor300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "제한 사유",
                              style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "$restrainName",
                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: !isForever,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: kNeutralColor300,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "제한 기간",
                                style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${date}일",
                                style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "(${DateFormat("yy-MM-dd").format(DateTime.parse(startDate!))} ~ ${DateFormat("yy-MM-dd").format(DateTime.parse(endDate!))})",
                                style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 54,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kNeutralColor300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1.0, color: kNeutralColor300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "확인",
                            style: kButton14MediumStyle.copyWith(color: kTextSubTitleColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                      onTap: () async {
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
                      child: Center(
                        child: Text(
                          "1:1 채널톡",
                          style: kButton14MediumStyle.copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: null,
      actions: <Widget>[],
    );
    return AlertDialog(
      content: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isForever ? foreverRestrictionTitle : restrictionTitle, textAlign: TextAlign.center),
            Visibility(
              visible: !isForever,
              child: Text('기한 : $restrictionPeriod', textAlign: TextAlign.center),
            ),
            Text(
              restrictionBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('확인'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('1:1 채널톡'),
            ),
          ],
        ),
      ],
    );
  }
}
