import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed/comment/component/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/cropped_images_list_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/kpostal_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/tag_screen.dart';

class PostFeedView extends ConsumerStatefulWidget {
  const PostFeedView({
    super.key,
    required this.croppedFiles,
    this.progress,
  });

  final List<File> croppedFiles;
  final double? progress;

  @override
  PostFeedViewState createState() => PostFeedViewState();
}

class PostFeedViewState extends ConsumerState<PostFeedView> {
  @override
  Widget build(BuildContext context) {
    final buttonSelected = ref.watch(feedWriteButtonSelectedProvider);
    final myInfo = ref.read(myInfoStateProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        children: <Widget>[
          AnimatedContainer(
            duration: kThemeChangeDuration,
            curve: Curves.easeInOut,
            height: getImageHeightCalculateValue(MediaQuery.of(context).size.width),
            child: Column(
              children: <Widget>[
                CroppedImagesListView(
                  progress: widget.progress,
                  croppedFiles: widget.croppedFiles,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false, // set to false
                    pageBuilder: (_, __, ___) => TagScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      width: 150,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        color: kPreviousNeutralColor100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: -2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Puppycat_social.icon_add_small,
                                  size: 20,
                                  color: kPreviousTextSubTitleColor,
                                ),
                                Text(
                                  "피드.유저 태그하기 띄어쓰기".tr(),
                                  style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                                ),
                                Text(
                                  "(",
                                  style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                                ),
                                Text(
                                  "${ref.watch(feedWriteCurrentTagCountProvider)}",
                                  style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                ),
                                Text(
                                  "/10)",
                                  style: kBody11SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MultiTriggerAutocomplete(
            optionsAlignment: OptionsAlignment.topStart,
            autocompleteTriggers: [
              AutocompleteTrigger(
                trigger: '@',
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  return MentionAutocompleteOptions(
                    query: autocompleteQuery.query,
                    onMentionUserTap: (user) {
                      final autocomplete = MultiTriggerAutocomplete.of(context);
                      return autocomplete.acceptAutocompleteOption(user.nick!);
                    },
                  );
                },
              ),
            ],
            fieldViewBuilder: (context, controller, focusNode) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.watch(feedWriteContentProvider.notifier).state = controller;
              });

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: (text) {
                      int cursorPos = ref.watch(feedWriteContentProvider).selection.baseOffset;
                      if (cursorPos > 0) {
                        int from = text!.lastIndexOf('@', cursorPos);
                        if (from != -1) {
                          int prevCharPos = from - 1;
                          if (prevCharPos >= 0 && text[prevCharPos] != ' ') {
                            return;
                          }

                          int nextSpace = text.indexOf(' ', from);
                          if (nextSpace == -1 || nextSpace >= cursorPos) {
                            String toSearch = text.substring(from + 1, cursorPos);
                            toSearch = toSearch.trim();

                            if (toSearch.isNotEmpty) {
                              if (toSearch.length >= 1) {
                                ref.watch(searchStateProvider.notifier).searchQuery.add(toSearch);
                              }
                            } else {
                              ref.watch(searchStateProvider.notifier).getMentionRecommendList(initPage: 1);
                            }
                          }
                        }
                      }
                    },
                    scrollPhysics: const ClampingScrollPhysics(),
                    maxLength: 500,
                    scrollPadding: const EdgeInsets.only(bottom: 500),
                    maxLines: 6,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: "피드.피드 힌트 텍스트".tr(args: ["${myInfo.nick}"]),
                        hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
                        contentPadding: const EdgeInsets.all(16)),
                    // name: 'content',
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "피드.위치 정보".tr(),
                  style: kBody16BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                ),
                ref.watch(feedWriteLocationInformationProvider) == ""
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 8, top: 12, left: 12),
                          child: Text(
                            "피드.삭제".tr(),
                            style: kBody13RegularStyle.copyWith(color: kTextTertiary),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () async {
                // ref.watch(feedWriteLocationInformationProvider.notifier).state =
                //     await Navigator.of(context).push(
                //   PageRouteBuilder(
                //     opaque: false, // set to false
                //     pageBuilder: (_, __, ___) =>
                //         const FeedWriteLocationSearchScreen(),
                //   ),
                // );
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KpostalView(
                        useLocalServer: true,
                        localPort: 9723,
                        kakaoKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY']!,
                        callback: (Kpostal result) {
                          print('location result $result');
                          ref.watch(feedWriteLocationInformationProvider.notifier).state = result.buildingName == "" ? result.roadAddress : result.buildingName;
                        },
                      ),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kPreviousNeutralColor400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ref.watch(feedWriteLocationInformationProvider) == ""
                        ? Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "피드.위치를 추가해 주세요".tr(),
                              style: kBody12RegularStyle.copyWith(color: kPreviousNeutralColor500),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              ref.watch(feedWriteLocationInformationProvider),
                              style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                            ),
                          ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Puppycat_social.icon_next_small,
                        size: 22,
                        color: kPreviousNeutralColor500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
            child: Text(
              "피드.공개 범위".tr(),
              style: kTitle16BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.watch(feedWriteButtonSelectedProvider.notifier).state = 1;
                    },
                    child: Container(
                      decoration: buttonSelected == 1
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPreviousPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPreviousNeutralColor400),
                            ),
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Puppycat_social.icon_view_all,
                            size: 20,
                            color: buttonSelected == 1 ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            "피드.전체 공개".tr(),
                            style: kTitle14BoldStyle.copyWith(color: buttonSelected == 1 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.watch(feedWriteButtonSelectedProvider.notifier).state = 2;
                    },
                    child: Container(
                      decoration: buttonSelected == 2
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPreviousPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPreviousNeutralColor400),
                            ),
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Puppycat_social.icon_view_follow,
                            size: 20,
                            color: buttonSelected == 2 ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            "피드.팔로우 공개".tr(),
                            style: kTitle14BoldStyle.copyWith(color: buttonSelected == 2 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.watch(feedWriteButtonSelectedProvider.notifier).state = 0;
                    },
                    child: Container(
                      decoration: buttonSelected == 0
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPreviousPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPreviousNeutralColor400),
                            ),
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Puppycat_social.icon_keep,
                            size: 20,
                            color: buttonSelected == 0 ? kPreviousPrimaryColor : kPreviousTextBodyColor,
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            "피드.피드 보관".tr(),
                            style: kTitle14BoldStyle.copyWith(color: buttonSelected == 0 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
