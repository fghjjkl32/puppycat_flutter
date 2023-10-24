import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/assets_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/components/feed/comment/mention_autocomplete_options.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/search/search_state_notifier.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_result_screen.dart';

class WriteWalkLogScreen extends ConsumerStatefulWidget {
  final Uint8List screenShotImage;
  final List<String> tabs;

  const WriteWalkLogScreen({
    Key? key,
    required this.screenShotImage,
    required this.tabs,
  }) : super(key: key);

  @override
  WriteWalkLogScreenState createState() => WriteWalkLogScreenState();
}

class WriteWalkLogScreenState extends ConsumerState<WriteWalkLogScreen> with TickerProviderStateMixin {
  List<File> additionalCroppedFiles = [];
  late TabController tabController;
  int selectedButton = 0;

  List<PetState> petStates = [];

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: widget.tabs.length,
      vsync: this,
    );

    for (var pet in widget.tabs) {
      petStates.add(PetState(
        petUuid: "",
        peeCount: 0,
        peeAmount: 0,
        peeColor: 0,
        poopCount: 0,
        poopAmount: 0,
        poopColor: 0,
        poopForm: 0,
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSelected = ref.watch(feedWriteButtonSelectedProvider);

    List<Widget> imageWidgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9.0),
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: [
                Image.memory(
                  widget.screenShotImage,
                  width: double.infinity,
                  height: 225,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    additionalCroppedFiles.asMap().forEach((index, file) {
      imageWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Stack(
                children: [
                  Image.file(
                    file,
                    width: double.infinity,
                    height: 225,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          additionalCroppedFiles.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kTextSubTitleColor.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        height: 28,
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: kNeutralColor100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "산책 결과",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            AnimatedContainer(
              duration: kThemeChangeDuration,
              curve: Curves.easeInOut,
              height: 250,
              width: 270,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        CarouselSlider.builder(
                          carouselController: ref.watch(feedWriteCarouselControllerProvider),
                          options: CarouselOptions(
                            initialPage: 0,
                            height: 260.0,
                            enableInfiniteScroll: false,
                            aspectRatio: 1,
                            padEnds: false,
                          ),
                          itemCount: imageWidgets.length,
                          itemBuilder: (BuildContext context, int index, int realIndex) {
                            return imageWidgets[index];
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  final theme = InstaAssetPicker.themeData(Theme.of(context).primaryColor);

                  InstaAssetPicker.pickAssets(
                    context,
                    maxAssets: 11,
                    pickerTheme: themeData(context).copyWith(
                      canvasColor: kNeutralColor100,
                      colorScheme: theme.colorScheme.copyWith(
                        background: kNeutralColor100,
                      ),
                      appBarTheme: theme.appBarTheme.copyWith(
                        backgroundColor: kNeutralColor100,
                      ),
                    ),
                    onCompleted: (cropStream) {
                      cropStream.listen((event) {
                        if (event.croppedFiles.isNotEmpty) {
                          setState(() {
                            additionalCroppedFiles = event.croppedFiles;
                          });
                        }
                      });

                      context.pop();
                    },
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        width: 150,
                        height: 36,
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
                                    "사진 업로드",
                                    style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                  ),
                                  Text(
                                    "(",
                                    style: kBody12SemiBoldStyle.copyWith(color: kTextBodyColor),
                                  ),
                                  Text(
                                    "${additionalCroppedFiles.length + 1}",
                                    style: kBody12SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                                  ),
                                  Text(
                                    "/12)",
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
                  ref.watch(walkLogContentProvider.notifier).state = controller;
                });

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: FormBuilderTextField(
                      focusNode: focusNode,
                      controller: ref.watch(walkLogContentProvider),
                      onChanged: (text) {
                        int cursorPos = ref.watch(walkLogContentProvider).selection.baseOffset;
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
                      maxLines: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: '산책 중 일어난 일을 메모해 보세요 . (최대 500자)\n작성한 메모는 마이페이지 산책일지에서 나만 볼 수 있습니다.',
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
              padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
              child: Text(
                "공개 범위",
                style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Puppycat_social.icon_view_all,
                              size: 14,
                              color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                              "전체 공개",
                              style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 1 ? kPrimaryColor : kTextBodyColor),
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
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Puppycat_social.icon_view_all,
                              size: 14,
                              color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                              "팔로우 공개",
                              style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 2 ? kPrimaryColor : kTextBodyColor),
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
                        ref.watch(feedWriteButtonSelectedProvider.notifier).state = 3;
                      },
                      child: Container(
                        decoration: buttonSelected == 3
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryLightColor,
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kNeutralColor400),
                              ),
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Puppycat_social.icon_view_all,
                              size: 14,
                              color: buttonSelected == 3 ? kPrimaryColor : kTextBodyColor,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                              "비공개",
                              style: kBody12SemiBoldStyle.copyWith(color: buttonSelected == 3 ? kPrimaryColor : kTextBodyColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12),
              child: Text(
                "산책결과",
                style: kBody14BoldStyle.copyWith(color: kTextSubTitleColor),
              ),
            ),
            TabBar(
              isScrollable: true,
              controller: tabController,
              indicatorWeight: 3,
              labelColor: kPrimaryColor,
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kNeutralColor500,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              tabs: widget.tabs
                  .map(
                    (tab) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        tab,
                        style: kBody14BoldStyle,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: selectedButton == 0 ? 270 : 310,
              child: TabBarView(
                controller: tabController,
                children: petStates.map((tab) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kNeutralColor400),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0, bottom: 22.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedButton = 0;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: selectedButton == 0 ? kNeutralColor300 : kNeutralColor100,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Puppycat_social.icon_comment,
                                                color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "소변",
                                                style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 0 ? kTextTitleColor : kTextBodyColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedButton = 1;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: selectedButton == 1 ? kNeutralColor300 : kNeutralColor100,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Puppycat_social.icon_comment,
                                                color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "대변",
                                                style: kBody12SemiBoldStyle.copyWith(color: selectedButton == 1 ? kTextTitleColor : kTextBodyColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (selectedButton == 0)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "횟수",
                                            style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: tab.peeCount > 0
                                                      ? () {
                                                          setState(() {
                                                            tab.peeCount -= 1;
                                                          });
                                                        }
                                                      : null,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: kNeutralColor400),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                      child: Text(
                                                        "-",
                                                        style: kButton14MediumStyle.copyWith(color: tab.peeCount > 0 ? kTextBodyColor : kNeutralColor500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Puppycat_social.icon_comment,
                                                        color: kTextTitleColor,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "${tab.peeCount}",
                                                        style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: tab.peeCount < 99
                                                      ? () {
                                                          setState(() {
                                                            tab.peeCount += 1;
                                                          });
                                                        }
                                                      : null,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: kNeutralColor400),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                      child: Text(
                                                        "+",
                                                        style: kButton14MediumStyle.copyWith(color: tab.peeCount < 99 ? kTextBodyColor : kNeutralColor500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "양",
                                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var i = 0; i < peeAmountList.length; i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tab.peeAmount = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: tab.peeAmount == i
                                                          ? BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kPrimaryLightColor,
                                                            )
                                                          : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                        child: Text(
                                                          peeAmountList[i],
                                                          style: kBody13RegularStyle.copyWith(
                                                            color: tab.peeAmount == i ? kPrimaryColor : kTextBodyColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "색",
                                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var i = 0; i < peeColorList.length; i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tab.peeColor = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: tab.peeColor == i
                                                          ? BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kPrimaryLightColor,
                                                            )
                                                          : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                        child: Text(
                                                          peeColorList[i],
                                                          style: kBody13RegularStyle.copyWith(
                                                            color: tab.peeColor == i ? kPrimaryColor : kTextBodyColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    ),
                                  ],
                                ),
                              if (selectedButton == 1)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "횟수",
                                            style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: tab.poopCount > 0
                                                      ? () {
                                                          setState(() {
                                                            tab.poopCount -= 1;
                                                          });
                                                        }
                                                      : null,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: kNeutralColor400),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                      child: Text(
                                                        "-",
                                                        style: kButton14MediumStyle.copyWith(color: tab.poopCount > 0 ? kTextBodyColor : kNeutralColor500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Puppycat_social.icon_comment,
                                                        color: kTextTitleColor,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "${tab.poopCount}",
                                                        style: kBody12SemiBoldStyle.copyWith(color: kTextTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: tab.poopCount < 99
                                                      ? () {
                                                          setState(() {
                                                            tab.poopCount += 1;
                                                          });
                                                        }
                                                      : null,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: kNeutralColor400),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                                      child: Text(
                                                        "+",
                                                        style: kButton14MediumStyle.copyWith(color: tab.poopCount < 99 ? kTextBodyColor : kNeutralColor500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "양",
                                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var i = 0; i < poopAmountList.length; i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tab.poopAmount = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: tab.poopAmount == i
                                                          ? BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kPrimaryLightColor,
                                                            )
                                                          : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                        child: Text(
                                                          poopAmountList[i],
                                                          style: kBody13RegularStyle.copyWith(
                                                            color: tab.poopAmount == i ? kPrimaryColor : kTextBodyColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "색",
                                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var i = 0; i < poopColorList.length; i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tab.poopColor = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: tab.poopColor == i
                                                          ? BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kPrimaryLightColor,
                                                            )
                                                          : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                        child: Text(
                                                          poopColorList[i],
                                                          style: kBody13RegularStyle.copyWith(
                                                            color: tab.poopColor == i ? kPrimaryColor : kTextBodyColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: kNeutralColor300,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Text(
                                              "형태",
                                              style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                for (var i = 0; i < poopFormList.length; i++)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tab.poopForm = i;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: tab.poopForm == i
                                                          ? BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: kPrimaryLightColor,
                                                            )
                                                          : null,
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                                        child: Text(
                                                          poopFormList[i],
                                                          style: kBody13RegularStyle.copyWith(
                                                            color: tab.poopForm == i ? kPrimaryColor : kTextBodyColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }
}
