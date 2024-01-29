import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/feed/comment/component/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_edit/component/edit_cropped_images_list_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_edit/edit_tag_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/kpostal_view.dart';

class EditFeedView extends ConsumerStatefulWidget {
  const EditFeedView({
    super.key,
    required this.feedData,
  });

  final FeedData feedData;

  @override
  PostFeedViewState createState() => PostFeedViewState();
}

class PostFeedViewState extends ConsumerState<EditFeedView> {
  final ScrollController _scrollController = ScrollController();

  List<TagImages> feedDataToPostFeedState(FeedData feedData) {
    List<TagImages> tagImages = [];

    for (int i = 0; i < feedData.imgList!.length; i++) {
      var imgData = feedData.imgList![i];
      List<Tag> tags = [];

      for (var tagData in imgData.imgMemberTagList!) {
        tags.add(Tag(
          username: tagData.nick!,
          memberUuid: tagData.memberUuid!,
          position: Offset(tagData.width!, tagData.height!),
          imageIndex: tagData.imgIdx!,
        ));
      }

      tagImages.add(TagImages(
        index: i,
        tag: tags,
      ));
    }

    return tagImages;
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(hashtagListProvider.notifier).state = getHashtagList(widget.feedData.contents!);
      ref.read(mentionListProvider.notifier).state = widget.feedData.mentionList!;

      Future<void>.delayed(const Duration(milliseconds: 100), () async {
        ref.watch(feedEditContentProvider.notifier).state.text = replaceMentionsWithNicknamesInContentAsTextFieldString(widget.feedData.contents!, widget.feedData.mentionList!);
        ref.watch(feedWriteLocationInformationProvider.notifier).state = widget.feedData.location!;
        ref.watch(feedWriteButtonSelectedProvider.notifier).state = widget.feedData.isView!;

        List<TagImages> postFeedState = feedDataToPostFeedState(widget.feedData);
        final updatedState = ref.watch(feedWriteProvider.notifier).state.copyWith(tagImage: postFeedState);
        ref.watch(feedWriteProvider.notifier).state = updatedState;

        List<TagImages> initialTagImages = feedDataToPostFeedState(widget.feedData);

        ref.read(feedWriteProvider.notifier).initializeTags(initialTagImages);
      });
    });
  }

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
                EditCroppedImagesListView(
                  feedData: widget.feedData,
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
                    pageBuilder: (_, __, ___) => EditTagScreen(
                      feedData: widget.feedData,
                    ),
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
                                  "유저 태그하기 ",
                                  style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                ),
                                Text(
                                  "(",
                                  style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
                                ),
                                Text(
                                  "${ref.watch(feedWriteCurrentTagCountProvider)}",
                                  style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                ),
                                Text(
                                  "/10)",
                                  style: kBody12SemiBoldStyle.copyWith(color: kPreviousTextBodyColor),
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
                ref.watch(feedEditContentProvider.notifier).state = controller;
              });

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: (text) {
                      int cursorPos = ref.watch(feedEditContentProvider).selection.baseOffset;
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
                    scrollController: _scrollController,
                    maxLength: 500,
                    scrollPadding: const EdgeInsets.only(bottom: 500),
                    maxLines: 6,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: "내용을 입력해 주세요. (최대 500자)\n\n운영 정책에 위반되는 폭력/선정/욕설 등은\n'${myInfo.nick}'님에게 책임이 있으며 동의 없이 삭제될 수 있어요.",
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
                  "위치정보",
                  style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                            "삭제",
                            style: kBadge10MediumStyle.copyWith(color: kTextTertiary),
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
                        kakaoKey: 'e70ed9e481a7927e0adc8647263bf6a5',
                        callback: (Kpostal result) {
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
                              "위치를 추가해 주세요.",
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
                    ref.watch(feedWriteLocationInformationProvider) == ""
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Puppycat_social.icon_next_small,
                              size: 22,
                              color: kPreviousNeutralColor500,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                            },
                            icon: const Icon(
                              Icons.close, // X 아이콘
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
              "공개 범위",
              style: kBody14BoldStyle.copyWith(color: kPreviousTextSubTitleColor),
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
                            "전체 공개",
                            style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 1 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
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
                            "팔로우 공개",
                            style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 2 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
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
                            "피드 보관",
                            style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 0 ? kPreviousPrimaryColor : kPreviousTextBodyColor),
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
