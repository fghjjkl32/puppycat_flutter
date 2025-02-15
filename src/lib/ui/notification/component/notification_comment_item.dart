import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/extensions/buttons_extension.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class NotificationCommentItem extends StatelessWidget {
  NotificationCommentItem({
    Key? key,
    required this.name,
    required this.regDate,
    required this.isRead,
    required this.notificationType,
    required this.content,
    required this.comment,
    required this.mentionList,
    required this.profileImgUrl,
    required this.imgUrl,
    this.onTapProfileButton,
    this.onTap,
  }) : super(key: key);

  final String name;
  final String regDate;
  final bool isRead;
  final String notificationType;
  final String content;
  final String comment;
  final Map<String, dynamic> mentionList;
  final String profileImgUrl;
  final String imgUrl;
  final Function? onTap;
  final Function? onTapProfileButton;

  // final List<MentionListData> mentionList;

  final detectRegExp = RegExp(
    r"\[@\[(.*?)\]\]|\[#\[(.*?)\]\]",
    multiLine: true,
  );

  String _replaceMentionHashTag(String comment) {
    if (mentionList.isEmpty) {
      return comment;
    }

    String replacedText = comment.replaceAllMapped(detectRegExp, (match) {
      String? detectedText = match[1] ?? match[2];

      if (detectedText == null) {
        return match[0] ?? '';
      }
      //result.list.first.mentionMemberInfo.first['ko10bd036fcdcb4aad9989296f340f54cc1688623039'].first['nick']

      String replaceText = detectedText;
      if (mentionList.keys.contains(detectedText)) {
        if (mentionList[detectedText] != null && mentionList[detectedText]!.isNotEmpty) {
          replaceText = mentionList[detectedText]!.first['nick'];
        } else {
          replaceText = detectedText;
        }
      }

      if (match[1] != null) {
        return '@$replaceText'; // @ 패턴의 경우, 내부 텍스트를 대문자로 변환
      } else {
        return '#$replaceText'; // # 패턴의 경우, 내부 텍스트를 소문자로 변환
      }
    });

    return replacedText;
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> detections = extractDetections(comment, detectRegExp);

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: isRead ? kPreviousPrimaryLightColor : kPreviousErrorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (onTapProfileButton != null) {
                  onTapProfileButton!();
                }
              },
              child: getProfileAvatar(
                profileImgUrl,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notificationType,
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                          Text(
                            regDate,
                            style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: kBody13RegularStyle.copyWith(color: kPreviousTextTitleColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: name.length > 13 ? '${name.substring(0, 13)}...' : name,
                                      style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                                    ),
                                    TextSpan(text: content),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: DetectableText(
                                  text: _replaceMentionHashTag(comment),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  detectionRegExp: detectionRegExp(atSign: true) ??
                                      RegExp(
                                        "(?!\\n)(?:^|\\s)([#]([$detectionContentLetters]+))|$urlRegexContent",
                                        multiLine: true,
                                      ),
                                  detectedStyle: kBody12RegularStyle.copyWith(color: kPreviousSecondaryColor),
                                  basicStyle: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
                                  onTap: (tappedText) {
                                    ///TODO
                                    /// 해시태그 검색 페이지 이동
                                    /// 밖에서 함수 받아오기
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            child: Image.network(
                              thumborUrl(imgUrl ?? ''),
                              fit: BoxFit.cover,
                              height: 52,
                              width: 52,
                              errorBuilder: (context, e, stackTrace) {
                                print('error imgUrl $imgUrl');
                                return const SizedBox(
                                  height: 52,
                                  width: 52,
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).throttle();
  }
}
