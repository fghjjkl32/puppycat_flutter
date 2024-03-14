import 'package:channel_talk_flutter/channel_talk_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

class RestrainDialog extends ConsumerWidget {
  final RestrainItemModel restrainItemModel;

  const RestrainDialog({
    Key? key,
    required this.restrainItemModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

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
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Text(
                    "공통.이용불가 제목".tr(),
                    style: kBody16BoldStyle.copyWith(color: kPreviousTextTitleColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "공통.궁금한 점이 있다면 1:1채널톡으로 알려주세요".tr(),
                    style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
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
                        color: kPreviousNeutralColor300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "공통.제한 사유".tr(),
                              style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              restrainItemModel.restrainName ?? '',
                              style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: kPreviousNeutralColor300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "공통.제한 기간".tr(),
                              style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '공통.제한 날짜'.tr(args: ["${restrainItemModel.date}"]),
                              style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "(${DateFormat("yy-MM-dd").format(DateTime.parse(restrainItemModel.startDate!))} ~ ${DateFormat("yy-MM-dd").format(DateTime.parse(restrainItemModel.endDate!))})",
                              style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
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
            Container(
              height: 54,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
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
                        isLogined ? context.pushReplacement('/home') : context.push('/home/login');
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "공통.확인".tr(),
                            style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                      onTap: () async {
                        isLogined == false
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
                      child: Center(
                        child: Text(
                          "공통.1:1 채널톡".tr(),
                          style: kButton14MediumStyle.copyWith(color: kPreviousPrimaryColor),
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
    );
  }
}
