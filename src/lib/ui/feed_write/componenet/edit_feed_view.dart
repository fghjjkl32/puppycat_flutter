import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/tag_user_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_content_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/cropped_images_list_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/edit_cropped_images_list_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/edit_tag_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_location_search_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/kpostal_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/tag_screen.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_location_information_provider.dart';

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
          memberIdx: tagData.memberIdx!,
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
      Future<void>.delayed(Duration(milliseconds: 100), () async {
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        children: <Widget>[
          AnimatedContainer(
            duration: kThemeChangeDuration,
            curve: Curves.easeInOut,
            height: 250.h,
            width: 270.w,
            child: Column(
              children: <Widget>[
                EditCroppedImagesListView(
                  feedData: widget.feedData,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
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
                    padding: EdgeInsets.only(bottom: 12.0.h),
                    child: Container(
                      width: 150,
                      height: 36.h,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        color: kNeutralColor100,
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
                                  color: kTextSubTitleColor,
                                ),
                                Text(
                                  "사람 태그하기 ",
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                Text(
                                  "(",
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                                ),
                                Text(
                                  "${ref.watch(feedWriteCurrentTagCountProvider)}",
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                ),
                                Text(
                                  "/10)",
                                  style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
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
                  child: FormBuilderTextField(
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
                    scrollPadding: EdgeInsets.only(bottom: 500.h),
                    maxLines: 6,
                    decoration: InputDecoration(
                        counterText: "",
                        hintText: '내용을 입력해 주세요.\n\n작성한 글에 대한 책임은 본인에게 있습니다.\n운영 정책에 위반되는(폭력성, 선정성, 욕설 등) 게시물은 당사자의 동의 없이 삭제될 수 있습니다.',
                        hintStyle: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                        contentPadding: const EdgeInsets.all(16)),
                    name: 'content',
                    style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.h, bottom: 8.0.h, left: 12.w),
            child: Text(
              "위치정보",
              style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
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
                  border: Border.all(color: kNeutralColor400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ref.watch(feedWriteLocationInformationProvider) == ""
                        ? Padding(
                            padding: EdgeInsets.only(left: 16.0.w),
                            child: Text(
                              "위치를 선택해주세요.",
                              style: kBody12RegularStyle.copyWith(color: kNeutralColor500),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 16.0.w),
                            child: Text(
                              ref.watch(feedWriteLocationInformationProvider),
                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                            ),
                          ),
                    ref.watch(feedWriteLocationInformationProvider) == ""
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Puppycat_social.icon_next_small,
                              size: 22,
                              color: kNeutralColor500,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              ref.watch(feedWriteLocationInformationProvider.notifier).state = "";
                            },
                            icon: const Icon(
                              Icons.close, // X 아이콘
                              size: 22,
                              color: kNeutralColor500,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0.h, bottom: 8.0.h, left: 12.w),
            child: Text(
              "공개 범위",
              style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
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
                              color: kPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kNeutralColor400),
                            ),
                      height: 44.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Puppycat_social.icon_view_all,
                            size: 26,
                            color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor,
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Text(
                            "전체 공개",
                            style: kButton14BoldStyle.copyWith(color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor),
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
                              color: kPrimaryLightColor,
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kNeutralColor400),
                            ),
                      height: 44.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Puppycat_social.icon_view_follow,
                            size: 26,
                            color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor,
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Text(
                            "팔로우 공개",
                            style: kButton14BoldStyle.copyWith(color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
