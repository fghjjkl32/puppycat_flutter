import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/post_feed_write_provider.dart';

class TagScreen extends ConsumerWidget {
  TagScreen({
    super.key,
  });

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<File> croppedFiles = ref.watch(croppedFilesProvider);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kNeutralColor100,
                  ),
                ),
                Text(
                  "사람 태그하기",
                  style: kTitle18BoldStyle.copyWith(color: kNeutralColor100),
                ),
                // "등록" 버튼을 정의합니다. 사용자가 이 버튼을 누르면 태그를 저장하고,
                // carousel을 현재 보고 있는 이미지로 이동시킵니다. 그리고 태그 개수를
                // 업데이트하고, 현재 스크린을 종료합니다.
                TextButton(
                  child: Text(
                    '등록',
                    style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
                  ),
                  onPressed: () {
                    ref.read(postFeedWriteProvider.notifier).saveTag();
                    ref.watch(carouselControllerProvider.notifier).jumpToPage(
                        ref.watch(currentViewCountProvider.notifier).state);

                    int currentIndex =
                        ref.watch(currentViewCountProvider.notifier).state;
                    List<TagImages> tagImages =
                        ref.watch(postFeedWriteProvider).tagImage;

                    TagImages? currentTagImage = tagImages.firstWhere(
                      (tagImage) => tagImage.index == currentIndex,
                      orElse: () => TagImages(index: 0, tags: []),
                    );

                    ref.watch(currentTagCountProvider.notifier).state =
                        currentTagImage.tags.length;

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: 103.h),
            Text(
              "태그할 위치를 선택해 주세요.",
              style: kBody14BoldStyle.copyWith(color: kNeutralColor100),
            ),
            SizedBox(
              height: 12.h,
            ),
            SizedBox(
              height: 280.h,
              // PageView를 사용하여 사용자가 태그를 추가할 이미지를 넘겨볼 수 있게 합니다.
              // 사용자가 페이지를 넘길 때마다, counter를 업데이트합니다.
              child: PageView(
                padEnds: false,
                onPageChanged: (index) {
                  _counter.value = index;
                  ref.watch(currentViewCountProvider.notifier).state = index;
                },
                controller: PageController(
                    initialPage: ref.watch(currentViewCountProvider)),
                scrollDirection: Axis.horizontal,
                children: croppedFiles.asMap().entries.map((entry) {
                  var imageIndex = entry.key;
                  var image = entry.value;

                  return Center(
                    child: TaggableImage(
                      image: image,
                      imageIndex: imageIndex,
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: DotIndicator(
                counter: ValueNotifier<int>(
                    ref.watch(currentViewCountProvider.notifier).state),
                imageListLength: croppedFiles.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaggableImage extends ConsumerStatefulWidget {
  final File image;
  final int imageIndex;

  const TaggableImage(
      {super.key, required this.image, required this.imageIndex});

  @override
  _TaggableImageState createState() => _TaggableImageState();
}

class _TaggableImageState extends ConsumerState<TaggableImage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    PostFeedState state = ref.watch(postFeedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;
    TagImages tagImages = taggedImages.firstWhere(
        (tagImage) => tagImage.index == widget.imageIndex,
        orElse: () => TagImages(index: widget.imageIndex, tags: []));

    List<Offset> tags = tagImages.tags;

    return GestureDetector(
      onTapDown: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset tapLocation = box.globalToLocal(details.globalPosition);
        ref
            .read(postFeedWriteProvider.notifier)
            .addTag(tapLocation, widget.imageIndex, context);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.file(
                widget.image,
              ),
            ),
          ),
          ...tags
              .map((tag) => Positioned(
                    top: tag.dy,
                    left: tag.dx,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(postFeedWriteProvider.notifier).removeTag(tag);
                      },
                      child: MentionTagWidget(
                        color: kTextSubTitleColor.withOpacity(0.8),
                        textStyle: kBody11RegularStyle.copyWith(
                            color: kNeutralColor100),
                        text: 'bearhat',
                        onDelete: () {
                          ref
                              .read(postFeedWriteProvider.notifier)
                              .removeTag(tag);
                        },
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
