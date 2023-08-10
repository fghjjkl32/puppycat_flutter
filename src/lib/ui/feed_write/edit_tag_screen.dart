import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/feed_write_tag_search_screen.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';

class EditTagScreen extends ConsumerWidget {
  EditTagScreen({
    Key? key,
    required this.feedData,
  }) : super(key: key);

  final FeedData feedData;

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ref.read(feedWriteProvider.notifier).saveTag();
                    ref
                        .watch(feedWriteCarouselControllerProvider.notifier)
                        .jumpToPage(ref
                            .watch(feedWriteCurrentViewCountProvider.notifier)
                            .state);

                    int currentIndex = ref
                        .watch(feedWriteCurrentViewCountProvider.notifier)
                        .state;
                    List<TagImages> tagImages =
                        ref.watch(feedWriteProvider).tagImage;

                    TagImages? currentTagImage = tagImages.firstWhere(
                      (tagImage) => tagImage.index == currentIndex,
                      orElse: () => TagImages(index: 0, tag: []),
                    );

                    ref.watch(feedWriteCurrentTagCountProvider.notifier).state =
                        currentTagImage.tag.length;

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
                  ref.watch(feedWriteCurrentViewCountProvider.notifier).state =
                      index;
                },
                controller: PageController(
                    initialPage: ref.watch(feedWriteCurrentViewCountProvider)),
                scrollDirection: Axis.horizontal,
                children: feedData.imgList!.asMap().entries.map((entry) {
                  var imageIndex = entry.key;
                  var image = entry.value;

                  print(entry);

                  return Center(
                    child: TaggableImage(
                      imageIndex: imageIndex,
                      url: entry.value.url!,
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: DotIndicator(
                counter: ValueNotifier<int>(ref
                    .watch(feedWriteCurrentViewCountProvider.notifier)
                    .state),
                imageListLength: feedData.imgList!.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaggableImage extends ConsumerStatefulWidget {
  final int imageIndex;
  final String url;

  final GlobalKey imageKey = GlobalKey();

  TaggableImage({
    super.key,
    required this.imageIndex,
    required this.url,
  });

  @override
  _TaggableImageState createState() => _TaggableImageState();
}

class _TaggableImageState extends ConsumerState<TaggableImage>
    with AutomaticKeepAliveClientMixin {
  Tag? draggingTag;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PostFeedState state = ref.watch(feedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;
    TagImages tagImages = taggedImages.firstWhere(
        (tagImage) => tagImage.index == widget.imageIndex,
        orElse: () => TagImages(index: widget.imageIndex, tag: []));

    List<Tag> tags = tagImages.tag;

    return GestureDetector(
      onTapDown: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset tapLocation = box.globalToLocal(details.globalPosition);

        List<TagImages> newTagImage = List.from(state.tagImage);
        int existingIndex = -1;

        for (int i = 0; i < newTagImage.length; i++) {
          if (newTagImage[i].index == widget.imageIndex) {
            existingIndex = i;
            break;
          }
        }

        if (existingIndex != -1) {
          if (newTagImage[existingIndex].tag.length >= 10) {
            toast(
              context: context,
              text: '한 이미지에는 태그를 10개까지만 할 수 있습니다.',
              type: ToastType.red,
            );
            return;
          }
        }
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => FeedWriteTagSearchScreen(
              offset: tapLocation,
              imageIndex: widget.imageIndex,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                "https://dev-imgs.devlabs.co.kr${widget.url}",
                fit: BoxFit.cover,
                key: widget.imageKey,
              ),
            ),
          ),
          ...tags
              .map((tag) => Positioned(
                    top: tag.position.dy,
                    left: tag.position.dx,
                    child: buildDraggableTag(tag),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Draggable<Tag> buildDraggableTag(Tag tag) {
    return Draggable<Tag>(
      data: tag,
      feedback: Material(
        color: Colors.transparent,
        child: MentionTagWidget(
          color: kTextSubTitleColor.withOpacity(0.8),
          textStyle: kBody11RegularStyle.copyWith(color: kNeutralColor100),
          text: tag.username,
          onDelete: () {},
        ),
      ),
      onDragStarted: () {
        setState(() {
          draggingTag = tag;
        });
      },
      onDragEnd: (dragDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        RenderBox imageBox =
            widget.imageKey.currentContext!.findRenderObject() as RenderBox;

        double imageHeight = imageBox.size.height - 40;
        double imageWidth = imageBox.size.width - 50;

        Offset localPosition = box.globalToLocal(dragDetails.offset);

        double xPos = localPosition.dx;
        double yPos = localPosition.dy;

        if (xPos < 10) xPos = 10;
        if (yPos < 0) yPos = 0;
        if (xPos > imageWidth) xPos = imageWidth;
        if (yPos > imageHeight) yPos = imageHeight;

        final newTag = tag.copyWith(position: Offset(xPos, yPos));

        ref
            .read(feedWriteProvider.notifier)
            .updateTag(tag, newTag, widget.imageIndex);

        setState(() {
          draggingTag = null;
        });
      },
      child: draggingTag == tag
          ? Container()
          : MentionTagWidget(
              color: kTextSubTitleColor.withOpacity(0.8),
              textStyle: kBody11RegularStyle.copyWith(color: kNeutralColor100),
              text: tag.username,
              onDelete: () {
                ref.read(feedWriteProvider.notifier).removeTag(tag);
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
