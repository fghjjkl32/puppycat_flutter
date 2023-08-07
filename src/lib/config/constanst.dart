import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

List<InlineSpan> replaceMentionsWithNicknamesInContent(
    String content,
    List<MentionListData> mentionList,
    BuildContext context,
    TextStyle tagStyle) {
  List<InlineSpan> spans = [];

  String remainingContent = content;

  while (true) {
    MentionListData? firstMention;
    int firstMentionIndex = -1;

    // Find the first mention in the remaining content
    for (var mention in mentionList) {
      String uuid = mention.uuid ?? '';
      String pattern = '[@[' + uuid + ']]';
      int mentionIndex = remainingContent.indexOf(pattern);

      if (mentionIndex != -1 &&
          (firstMentionIndex == -1 || mentionIndex < firstMentionIndex)) {
        firstMention = mention;
        firstMentionIndex = mentionIndex;
      }
    }

    // If no more mentions are found, break the loop
    if (firstMention == null) {
      break;
    }

    // Add the text before the mention to the spans
    if (firstMentionIndex > 0) {
      spans.add(
          TextSpan(text: remainingContent.substring(0, firstMentionIndex)));
    }

    // Add the mention to the spans with special style and click behavior
    spans.add(WidgetSpan(
      child: GestureDetector(
        onTap: () {
          context.push(
              "/home/myPage/followList/${firstMention!.memberIdx}/userPage/${firstMention.nick}/${firstMention.memberIdx}");
        },
        child: Text('@' + (firstMention.nick ?? ''), style: tagStyle),
      ),
    ));

    // Remove the processed content
    remainingContent = remainingContent
        .substring(firstMentionIndex + '[@[${firstMention.uuid}]]'.length);
  }

  // Process hashtags
  String remainingContentAfterMentions = remainingContent;
  while (true) {
    RegExp exp = new RegExp(r"\[#\[(.*?)\]\]");
    var match = exp.firstMatch(remainingContentAfterMentions);

    if (match == null) break;

    String beforeHashtag =
        remainingContentAfterMentions.substring(0, match.start);
    String hashtag = match.group(1) ?? '';

    spans.add(TextSpan(text: beforeHashtag));

    spans.add(WidgetSpan(
      child: GestureDetector(
        onTap: () {
          print(hashtag);
          context.push("/home/search/$hashtag");
        },
        child: Text('#' + hashtag,
            style: kBody13RegularStyle.copyWith(color: kSecondaryColor)),
      ),
    ));

    remainingContentAfterMentions =
        remainingContentAfterMentions.substring(match.end);
  }

  // Add the remaining content after the last pattern
  spans.add(TextSpan(text: remainingContentAfterMentions));

  return spans;
}

String replaceMentionsWithNicknamesInContentAsString(
    String content, List<MentionListData> mentionList) {
  String result = "";

  String remainingContent = content;

  while (true) {
    MentionListData? firstMention;
    int firstMentionIndex = -1;

    // Find the first mention in the remaining content
    for (var mention in mentionList) {
      String uuid = mention.uuid ?? '';
      String pattern = '[@[' + uuid + ']]';
      int mentionIndex = remainingContent.indexOf(pattern);

      if (mentionIndex != -1 &&
          (firstMentionIndex == -1 || mentionIndex < firstMentionIndex)) {
        firstMention = mention;
        firstMentionIndex = mentionIndex;
      }
    }

    // If no more mentions are found, break the loop
    if (firstMention == null) {
      break;
    }

    // Add the text before the mention to the result
    if (firstMentionIndex > 0) {
      result += remainingContent.substring(0, firstMentionIndex);
    }

    // Add the mention to the result
    result += '@' + (firstMention.nick ?? '');

    // Remove the processed content
    remainingContent = remainingContent
        .substring(firstMentionIndex + '[@[${firstMention.uuid}]]'.length);
  }

  // Process hashtags
  String remainingContentAfterMentions = remainingContent;
  while (true) {
    RegExp exp = new RegExp(r"\[#\[(.*?)\]\]");
    var match = exp.firstMatch(remainingContentAfterMentions);

    if (match == null) break;

    String beforeHashtag =
        remainingContentAfterMentions.substring(0, match.start);
    String hashtag = match.group(1) ?? '';

    // Add the text before the hashtag to the result
    result += beforeHashtag;

    // Add the hashtag to the result
    result += '#' + hashtag;

    remainingContentAfterMentions =
        remainingContentAfterMentions.substring(match.end);
  }

  // Add the remaining content after the last pattern to the result
  result += remainingContentAfterMentions;

  return result;
}
