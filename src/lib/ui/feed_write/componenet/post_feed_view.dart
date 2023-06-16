import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/cropped_images_list_view.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/tag_screen.dart';
import 'package:pet_mobile_social_flutter/viewmodels/feed_write/feed_write_button_selected_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/feed_write/feed_write_current_tag_count_provider.dart';

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

    return ListView(
      children: <Widget>[
        AnimatedContainer(
          duration: kThemeChangeDuration,
          curve: Curves.easeInOut,
          height: 300.h,
          width: 270.w,
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
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
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
                  padding: EdgeInsets.only(bottom: 12.0.h),
                  child: Container(
                    width: 144.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
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
                              Text(
                                "+",
                                style: kBody16BoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "사람 태그하기 ",
                                style: kBody12SemiBoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                              Text(
                                "(",
                                style: kBody12SemiBoldStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                              Text(
                                "${ref.watch(feedWriteCurrentTagCountProvider)}",
                                style: kBody12SemiBoldStyle.copyWith(
                                    color: kTextSubTitleColor),
                              ),
                              Text(
                                "/10)",
                                style: kBody12SemiBoldStyle.copyWith(
                                    color: kTextBodyColor),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: FormBuilderTextField(
            maxLength: 200,
            scrollPadding: EdgeInsets.only(bottom: 400.0.h),
            maxLines: 6,
            decoration: InputDecoration(
                counterText: "",
                hintText: '내용을 입력해 주세요.\n(게시물 등록 기준에 맞지 않을 경우 게시가 제한될 수 있어요.)',
                hintStyle:
                    kBody12RegularStyle.copyWith(color: kNeutralColor500),
                contentPadding: const EdgeInsets.all(16)),
            name: 'content',
            style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.center,
          ),
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
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kNeutralColor400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.w),
                    child: Text(
                      "위치를 선택해주세요.",
                      style:
                          kBody12RegularStyle.copyWith(color: kNeutralColor500),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kNeutralColor400,
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
                    ref.watch(feedWriteButtonSelectedProvider.notifier).state =
                        0;
                  },
                  child: Container(
                    decoration: buttonSelected == 0
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
                        Image.asset(
                          'assets/image/feed/icon/small_size/icon_view_all.png',
                          height: 26.w,
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Text(
                          "전체 공개",
                          style: kButton14BoldStyle.copyWith(
                              color: buttonSelected == 0
                                  ? kPrimaryColor
                                  : kTextBodyColor),
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
                    ref.watch(feedWriteButtonSelectedProvider.notifier).state =
                        1;
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
                        Image.asset(
                          'assets/image/feed/icon/small_size/icon_view_follow.png',
                          height: 26.w,
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Text(
                          "팔로우 공개",
                          style: kButton14BoldStyle.copyWith(
                              color: buttonSelected == 1
                                  ? kPrimaryColor
                                  : kTextBodyColor),
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
          height: 60.h,
        ),
      ],
    );
  }
}
