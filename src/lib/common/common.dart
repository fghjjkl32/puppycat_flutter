import 'package:app_install_date/app_install_date.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/providers/comment/comment_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat_home/chat_room_screen.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

part 'package:pet_mobile_social_flutter/common/api_exception.dart';
part 'package:pet_mobile_social_flutter/common/constants.dart';
part 'package:pet_mobile_social_flutter/common/enum.dart';
part 'package:pet_mobile_social_flutter/common/hosts.dart';

Future<String> checkFirstInstall() async {
  final DateTime date = await AppInstallDate().installDate;
  return date.toString();
}

double getImageHeightCalculateValue(double width) {
  const double slope = 0.172727;
  const double intercept = 225.818182;

  // 선형 방정식을 이용하여 값을 계산
  return slope * width + intercept;
}

double getViewportFractionCalculateValue(double width) {
  // 계산된 기울기와 절편
  const double slope = -0.000909;
  const double intercept = 1.127273;

  // 선형 방정식을 이용하여 값을 계산
  return slope * width + intercept;
}

String displayedAt(DateTime time) {
  var milliSeconds = DateTime.now().difference(time).inMilliseconds;
  var seconds = milliSeconds / 1000;
  if (seconds < 60) return '방금 전'.tr();
  var minutes = seconds / 60;
  if (minutes < 60) return '분 전'.tr(args: ["${minutes.floor()}"]);
  var hours = minutes / 60;
  if (hours < 24) return '시간 전'.tr(args: ["${hours.floor()}"]);
  var days = hours / 24;
  if (days < 7) return '일 전'.tr(args: ["${days.floor()}"]);

  return DateFormat('yyyy-MM-dd').format(time);
}

String convertToJsonStringQuotes({required String raw}) {
  String jsonString = raw;

  /// add quotes to json string
  jsonString = jsonString.replaceAll('{', '{"');
  jsonString = jsonString.replaceAll(': ', '": "');
  jsonString = jsonString.replaceAll(', ', '", "');
  jsonString = jsonString.replaceAll('}', '"}');

  /// remove quotes on object json string
  jsonString = jsonString.replaceAll('"{"', '{"');
  jsonString = jsonString.replaceAll('"}"', '"}');

  /// remove quotes on array json string
  jsonString = jsonString.replaceAll('"[{', '[{');
  jsonString = jsonString.replaceAll('}]"', '}]');

  return jsonString;
}

String thumborUrl(String url) {
  return Thumbor(host: thumborHostUrl, key: thumborKey).buildImage(url).toUrl();
}

List<String> getHashtagList(textData) {
  RegExp pattern = RegExp(r"\[#\[(.*?)\]\]");
  Iterable<Match> matches = pattern.allMatches(textData);
  return matches.map((m) => '#' + m.group(1)!).toList();
}

List<String> getMentionList(String textData) {
  RegExp pattern = RegExp(r"\[@\[(.*?)\]\]");
  Iterable<Match> matches = pattern.allMatches(textData);
  return matches.map((m) => '@' + m.group(1)!).toList();
}

Future<String> processHashtagEditedText(String editedText, List<String> hashtagList) {
  for (String hashtag in hashtagList) {
    String pattern = '(^|\\s)' + RegExp.escape(hashtag) + '(\\s|\$)';
    RegExp regex = RegExp(pattern);

    editedText = editedText.replaceAllMapped(
      regex,
      (match) => '${match.group(1)}[#[' + hashtag.substring(1) + ']]${match.group(2)}',
    );
  }

  return Future.value(editedText);
}

Future<String> processMentionEditedText(String editedText, List<MentionListData> mentionList) {
  for (MentionListData mention in mentionList) {
    String pattern = '(^|\\s)@' + RegExp.escape(mention.nick!) + '(\\s|\$)';
    RegExp regex = RegExp(pattern);

    editedText = editedText.replaceAllMapped(
      regex,
      (match) => '${match.group(1)}[@[' + mention.uuid! + ']]${match.group(2)}',
    );
  }

  return Future.value(editedText);
}

List<InlineSpan> replaceMentionsWithNicknamesInContent(String content, List<MentionListData> mentionList, BuildContext context, TextStyle tagStyle, WidgetRef ref, String? oldMemberUuid) {
  List<InlineSpan> spans = [];

  // Combining both mention and hashtag patterns
  RegExp pattern = RegExp(r"\[@\[(.*?)\]\]|\[#\[(.*?)\]\]");

  List<Match> matches = pattern.allMatches(content).toList();

  int lastIndex = 0;

  for (var match in matches) {
    String mentionMatched = match.group(1) ?? "";
    String hashtagMatched = match.group(2) ?? "";

    // Add the plain text between the current and the last mention/hashtag
    spans.add(TextSpan(text: content.substring(lastIndex, match.start)));

    if (mentionMatched.isNotEmpty) {
      if (mentionList.any((mention) => mention.uuid == mentionMatched)) {
        var mention = mentionList.firstWhere((m) => m.uuid == mentionMatched);

        spans.add(TextSpan(
            text: '@' + (mention.memberState == 0 ? "공통.알 수 없음".tr() : (mention.nick ?? '')),
            style: tagStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ref.read(myInfoStateProvider).uuid == mention.uuid
                    ? context.push("/member/myPage", extra: {"oldMemberUuid": oldMemberUuid!})
                    : mention.memberState == 0
                        ? context.push("/member/userUnknown")
                        : context.push("/member/userPage", extra: {"nick": mention.nick, "memberUuid": mention.uuid, "oldMemberUuid": oldMemberUuid});
              }));
      } else {
        spans.add(TextSpan(text: '@' + mentionMatched));
      }
    } else if (hashtagMatched.isNotEmpty) {
      if (hashtagMatched.contains('*')) {
        spans.add(TextSpan(text: '#' + hashtagMatched));
      } else {
        spans.add(TextSpan(text: '#' + hashtagMatched, style: tagStyle, recognizer: TapGestureRecognizer()..onTap = () => context.push("/search/hashtag/$hashtagMatched/$oldMemberUuid")));
      }
    }

    lastIndex = match.end;
  }

  // Add any remaining text after the last mention/hashtag
  spans.add(TextSpan(text: content.substring(lastIndex)));

  return spans;
}

String replaceMentionsWithNicknamesInContentAsString(String content, List<MentionListData> mentionList) {
  RegExp pattern = RegExp(r"\[@\[(.*?)\]\]");
  String result = content.replaceAllMapped(pattern, (match) {
    String matchedString = match.group(1) ?? "";

    if (mentionList.any((mention) => mention.uuid == matchedString)) {
      var mention = mentionList.firstWhere((m) => m.uuid == matchedString);
      return '@' + (mention.memberState == 0 ? "공통.알 수 없음".tr() : mention.nick!);
    } else {
      return '@' + matchedString;
    }
  });

  RegExp hashtagExp = RegExp(r"\[#\[(.*?)\]\]");
  result = result.replaceAllMapped(hashtagExp, (match) {
    return "#" + (match.group(1) ?? "");
  });

  return result;
}

String replaceMentionsWithNicknamesInContentAsTextFieldString(String content, List<MentionListData> mentionList) {
  RegExp pattern = RegExp(r"\[@\[(.*?)\]\]");
  String result = content.replaceAllMapped(pattern, (match) {
    String matchedString = match.group(1) ?? "";

    if (mentionList.any((mention) => mention.uuid == matchedString)) {
      var mention = mentionList.firstWhere((m) => m.uuid == matchedString);
      return '@' + (mention.memberState == 0 ? "공통.알 수 없음".tr() : mention.nick!);
    } else {
      return '@' + matchedString;
    }
  });

  RegExp hashtagExp = RegExp(r"\[#\[(.*?)\]\]");
  result = result.replaceAllMapped(hashtagExp, (match) {
    return "#" + (match.group(1) ?? "");
  });

  return result;
}

String? getNickDescription(NickNameStatus nickNameStatus) {
  switch (nickNameStatus) {
    case NickNameStatus.duplication:
      return '회원가입.이미 존재하는 닉네임입니다'.tr();
    case NickNameStatus.maxLength:
      return '회원가입.닉네임은 20자를 초과할 수 없습니다'.tr();
    case NickNameStatus.minLength:
      return '회원가입.닉네임은 최소 2자 이상 설정 가능합니다'.tr();
    case NickNameStatus.invalidLetter:
      return '회원가입.닉네임 입력 예외 메시지'.tr();
    case NickNameStatus.valid:
      return '회원가입.사용 가능한 닉네임입니다'.tr();
    case NickNameStatus.invalidWord:
      return '회원가입.사용할 수 없는 닉네임입니다'.tr();
    default:
      return null;
  }
}

DateTime? currentBackPressTime;

bool onBackPressed() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
      msg: "공통.한번 더 누르시면 종료됩니다".tr(),
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kPreviousNeutralColor500,
      fontSize: 14,
      toastLength: Toast.LENGTH_SHORT,
    );
    return false;
  }
  return true;
}

String formatDuration(Duration d) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

List<String> peeColorList = ["밝은노랑", "어두운노랑", "갈색", "붉은색"];
List<String> peeAmountList = ["적음", "중간", "많음", "잘모르겠음"];
List<String> poopColorList = ["갈색", "흑색", "혈액", "흰색", "회색", "노랑"];
List<String> poopAmountList = ["적음", "중간", "많음", "잘모르겠음"];
List<String> poopFormList = ["정상", "연변", "설사", "단단", "토끼똥"];

void onTapHide({
  required BuildContext context,
  required WidgetRef ref,
  required String contentType,
  required dynamic contentIdx,
  required String memberUuid,
}) async {
  if (!ref.read(loginStatementProvider)) {
    context.push("/home/login");
  } else {
    final tempContentIdx = contentIdx;

    print(tempContentIdx);
    print(contentIdx);

    context.pop();

    final result = await ref.watch(feedListStateProvider.notifier).postHide(
          contentType: contentType,
          contentIdx: tempContentIdx,
        );

    if (result.result && context.mounted) {
      toast(
        context: context,
        text: '공통.피드를 숨겼어요'.tr(),
        type: ToastType.purple,
        buttonText: "공통.되돌리기".tr(),
        buttonOnTap: () async {
          final result = await ref.watch(feedListStateProvider.notifier).deleteHide(
                contentType: contentType,
                contentIdx: tempContentIdx,
              );

          if (result.result && context.mounted) {
            toast(
              context: context,
              text: '공통.피드를 되돌렸어요'.tr(),
              type: ToastType.purple,
            );
          }
        },
      );
    }
  }
}

void onTapReport({
  required BuildContext context,
  required Ref<Object?> ref,
  required dynamic contentIdx,
  required bool reportType,
}) async {
  toast(
    context: context,
    text: '공통.신고 접수 완료!'.tr(),
    type: ToastType.purple,
    buttonText: "공통.되돌리기".tr(),
    buttonOnTap: () async {
      final result = reportType
          ? await ref.read(commentListStateProvider.notifier).deleteCommentReport(
                contentIdx: contentIdx,
                reportType: reportType ? "comment" : "contents",
              )
          : await ref.read(feedListStateProvider.notifier).deleteContentReport(
                contentIdx: contentIdx,
                reportType: reportType ? "comment" : "contents",
              );

      if (result.result && context.mounted) {
        toast(
          context: context,
          text: '공통.신고 접수를 취소했어요'.tr(),
          type: ToastType.grey,
        );
      }
    },
  );
}
