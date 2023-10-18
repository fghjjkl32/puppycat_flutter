import 'package:app_install_date/app_install_date.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static Future<String> getBaseUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedURL') ?? "https://api.pcstg.co.kr/v1";
  }

  static Future<String> getThumborHostUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('thumborHostUrl') ?? "https://tb.pcstg.co.kr/";
  }

  static Future<String> getThumborKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('thumborKey') ?? "Tjaqhvpt";
  }

  static Future<String> getThumborDomain() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('thumborDomain') ?? "https://imgs.pcstg.co.kr";
  }

  static Future<String> checkFirstInstall() async {
    final DateTime date = await AppInstallDate().installDate;
    return date.toString();
  }
}

String baseUrl = "https://api.pcstg.co.kr/v1";
String thumborHostUrl = "https://tb.pcstg.co.kr/";
String thumborKey = "Tjaqhvpt";
String imgDomain = "https://imgs.pcstg.co.kr";
String firstInstallTime = "";
String lastestBuildVersion = "";
bool isAppLinkHandled = false;

String displayedAt(DateTime time) {
  var milliSeconds = DateTime.now().difference(time).inMilliseconds;
  var seconds = milliSeconds / 1000;
  if (seconds < 60) return '방금 전';
  var minutes = seconds / 60;
  if (minutes < 60) return '${minutes.floor()}분 전';
  var hours = minutes / 60;
  if (hours < 24) return '${hours.floor()}시간 전';
  var days = hours / 24;
  if (days < 7) return '${days.floor()}일 전';

  return DateFormat('yyyy-MM-dd').format(time);
}

final ContentResponseModel contentNullResponseModel = ContentResponseModel(
  result: false,
  code: "",
  data: const ContentDataListModel(
    list: [],
    params: ParamsModel(
      memberIdx: 0,
      pagination: Pagination(
        startPage: 0,
        limitStart: 0,
        totalPageCount: 0,
        existNextPage: false,
        endPage: 0,
        existPrevPage: false,
        totalRecordCount: 0,
      ),
      offset: 0,
      limit: 0,
      pageSize: 0,
      page: 0,
      recordSize: 0,
    ),
  ),
  message: "",
);

final FeedResponseModel feedNullResponseModel = FeedResponseModel(
  result: false,
  code: "",
  data: const FeedDataListModel(
    list: [],
    params: ParamsModel(
      memberIdx: 0,
      pagination: Pagination(
        startPage: 0,
        limitStart: 0,
        totalPageCount: 0,
        existNextPage: false,
        endPage: 0,
        existPrevPage: false,
        totalRecordCount: 0,
      ),
      offset: 0,
      limit: 0,
      pageSize: 0,
      page: 0,
      recordSize: 0,
    ),
  ),
  message: "",
);
List<InlineSpan> replaceMentionsWithNicknamesInContent(String content, List<MentionListData> mentionList, BuildContext context, TextStyle tagStyle, WidgetRef ref, int? oldMemberIdx) {
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
        spans.add(WidgetSpan(
          child: GestureDetector(
            onTap: () {
              ref.read(userInfoProvider).userModel?.idx == mention.memberIdx
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPageMainScreen(
                          oldMemberIdx: oldMemberIdx!,
                        ),
                      ),
                    )
                  : mention.memberState == 0
                      ? context.push("/home/myPage/userUnknown")
                      : context.push("/home/myPage/followList/${mention.memberIdx}/userPage/${mention.nick}/${mention.memberIdx}/${oldMemberIdx}");
            },
            child: Text('@' + (mention.memberState == 0 ? "(알 수 없음)" : (mention.nick ?? '')), style: tagStyle),
          ),
        ));
      } else {
        spans.add(TextSpan(text: '@' + mentionMatched));
      }
    } else if (hashtagMatched.isNotEmpty) {
      // Handle hashtag
      spans.add(WidgetSpan(
        child: GestureDetector(
          onTap: () {
            context.push("/home/search/$hashtagMatched/$oldMemberIdx");
          },
          child: Text('#' + hashtagMatched, style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
        ),
      ));
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
      return '@' + (mention.memberState == 0 ? "(알 수 없음)" : mention.nick!);
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
      return '@' + (mention.memberState == 0 ? "(알 수 없음)" : mention.nick!);
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

String toLowercase(String input) {
  return input.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
    return match.group(0)!.toLowerCase();
  });
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
      msg: "한번 더 누르시면 종료됩니다.",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: kNeutralColor500,
      fontSize: 14,
      toastLength: Toast.LENGTH_SHORT,
    );
    return false;
  }
  return true;
}

enum PetGender {
  boy(1, "수컷", ""),
  girl(2, "암컷", ""),
  boyNeutering(3, "수컷 중성화", ""),
  girlNeutering(4, "암컷 중성화", "");

  const PetGender(this.value, this.name, this.icon);
  final int value;
  final String name;
  final String icon;
}

enum PetSize {
  small(1, "작음", ""),
  middle(2, "중간", ""),
  big(3, "큼", "");

  const PetSize(this.value, this.name, this.icon);
  final int value;
  final String name;
  final String icon;
}

enum PetAge {
  puppy(1, "퍼피", ""),
  adult(2, "어덜트", ""),
  senior(3, "시니어", "");

  const PetAge(this.value, this.name, this.icon);
  final int value;
  final String name;
  final String icon;
}

enum PetCharacter {
  kind(1, '착하고 온순해요!'),
  timid(2, '소심하고 겁이 많아요!'),
  barky(3, '사람만 보면 짖어요!'),
  active(4, '활발해요!'),
  sensitive(5, '예민해요!'),
  friendly(6, '친화력이 좋아요!'),
  custom(7, '직접입력(최대 40자)');

  const PetCharacter(this.value, this.name);
  final int value;
  final String name;
}
