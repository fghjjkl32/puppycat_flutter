import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/feed_write_tag_search_screen.dart';

class EditTagScreen extends ConsumerWidget {
  EditTagScreen({
    Key? key,
    required this.feedData,
  }) : super(key: key);

  final FeedData feedData;

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultOnWillPopScope(
      onWillPop: () {
        ref.read(feedWriteProvider.notifier).revertToLastSavedState();
        context.pop();

        return Future.value(true);
      },
      child: Scaffold(
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
                      ref.read(feedWriteProvider.notifier).revertToLastSavedState();
                      context.pop();
                    },
                    icon: const Icon(
                      Puppycat_social.icon_close_large,
                      color: kPreviousNeutralColor100,
                    ),
                  ),
                  Text(
                    "피드.유저 태그하기".tr(),
                    style: kTitle18BoldStyle.copyWith(color: kPreviousNeutralColor100),
                  ),
                  // "등록" 버튼을 정의합니다. 사용자가 이 버튼을 누르면 태그를 저장하고,
                  // carousel을 현재 보고 있는 이미지로 이동시킵니다. 그리고 태그 개수를
                  // 업데이트하고, 현재 스크린을 종료합니다.
                  TextButton(
                    child: Text(
                      '피드.등록'.tr(),
                      style: kTitle14BoldStyle.copyWith(color: kPreviousPrimaryColor),
                    ),
                    onPressed: () {
                      ref.read(feedWriteProvider.notifier).saveTag();
                      ref.watch(feedWriteCarouselControllerProvider.notifier).jumpToPage(ref.watch(feedWriteCurrentViewCountProvider.notifier).state);

                      int currentIndex = ref.watch(feedWriteCurrentViewCountProvider.notifier).state;
                      List<TagImages> tagImages = ref.watch(feedWriteProvider).tagImage;

                      TagImages? currentTagImage = tagImages.firstWhere(
                        (tagImage) => tagImage.index == currentIndex,
                        orElse: () => TagImages(index: 0, tag: []),
                      );

                      ref.watch(feedWriteCurrentTagCountProvider.notifier).state = currentTagImage.tag.length;

                      ref.read(feedWriteProvider.notifier).saveState();

                      context.pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 103),
              Text(
                "피드.태그 할 위치를 눌러보세요".tr(),
                style: kBody14BoldStyle.copyWith(color: kPreviousNeutralColor100),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 280,
                // PageView를 사용하여 사용자가 태그를 추가할 이미지를 넘겨볼 수 있게 합니다.
                // 사용자가 페이지를 넘길 때마다, counter를 업데이트합니다.
                child: PageView(
                  padEnds: false,
                  onPageChanged: (index) {
                    _counter.value = index;
                    ref.watch(feedWriteCurrentViewCountProvider.notifier).state = index;
                  },
                  controller: PageController(initialPage: ref.watch(feedWriteCurrentViewCountProvider)),
                  scrollDirection: Axis.horizontal,
                  children: feedData.imgList!.asMap().entries.map((entry) {
                    var imageIndex = entry.key;
                    var image = entry.value;

                    return Center(
                      child: TaggableImage(
                        imagePositionIndex: imageIndex,
                        url: entry.value.url!,
                        imageIdx: entry.value.idx!,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DotIndicator(
                  counter: ValueNotifier<int>(ref.watch(feedWriteCurrentViewCountProvider.notifier).state),
                  imageListLength: feedData.imgList!.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaggableImage extends ConsumerStatefulWidget {
  final int imagePositionIndex;
  final String url;
  final int imageIdx;

  final GlobalKey imageKey = GlobalKey();

  TaggableImage({
    super.key,
    required this.imagePositionIndex,
    required this.imageIdx,
    required this.url,
  });

  @override
  _TaggableImageState createState() => _TaggableImageState();
}

class _TaggableImageState extends ConsumerState<TaggableImage> with AutomaticKeepAliveClientMixin {
  Tag? draggingTag;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final RenderBox? imageBox = widget.imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (imageBox != null) {
        setState(() {
          _imageSize = imageBox.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PostFeedState state = ref.watch(feedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;
    TagImages tagImages = taggedImages.firstWhere((tagImage) => tagImage.index == widget.imagePositionIndex, orElse: () => TagImages(index: widget.imagePositionIndex, tag: []));

    List<Tag> tags = tagImages.tag;

    return GestureDetector(
      onTapDown: (details) {
        RenderBox box = context.findRenderObject() as RenderBox;

        final Offset localPosition = box.globalToLocal(details.globalPosition);
        final RenderBox imageBox = widget.imageKey.currentContext!.findRenderObject() as RenderBox;
        final Size displayedImageSize = imageBox.size;

        final double xRatio = localPosition.dx / displayedImageSize.width;
        final double yRatio = localPosition.dy / displayedImageSize.height;

        List<TagImages> newTagImage = List.from(state.tagImage);
        int existingIndex = -1;

        for (int i = 0; i < newTagImage.length; i++) {
          if (newTagImage[i].index == widget.imagePositionIndex) {
            existingIndex = i;
            break;
          }
        }

        if (existingIndex != -1) {
          if (newTagImage[existingIndex].tag.length >= 10) {
            toast(
              context: context,
              text: '피드.사진 당 태그는 10명까지 가능해요'.tr(),
              type: ToastType.red,
            );
            return;
          }
        }
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false, // set to false
            pageBuilder: (_, __, ___) => FeedWriteTagSearchScreen(
              offset: Offset(xRatio, yRatio),
              imagePositionIndex: widget.imagePositionIndex,
              imageIdx: widget.imageIdx,
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
                thumborUrl(widget.url ?? ''),
                fit: BoxFit.cover,
                key: widget.imageKey,
              ),
            ),
          ),
          ...tags.map((tag) {
            if (_imageSize == null) {
              return Container();
            }

            return Positioned(
              top: _imageSize!.height * tag.position.dy,
              left: _imageSize!.width * tag.position.dx,
              child: buildDraggableTag(tag),
            );
          }).toList(),
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
          color: kPreviousTextSubTitleColor.withOpacity(0.8),
          textStyle: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor100),
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
        RenderBox imageBox = widget.imageKey.currentContext!.findRenderObject() as RenderBox;

        double imageHeight = imageBox.size.height - 40;
        double imageWidth = imageBox.size.width - 50;

        Offset localPosition = box.globalToLocal(dragDetails.offset);

        double xPos = localPosition.dx;
        double yPos = localPosition.dy;

        if (xPos < 10) xPos = 10;
        if (yPos < 0) yPos = 0;
        if (xPos > imageWidth) xPos = imageWidth;
        if (yPos > imageHeight) yPos = imageHeight;

        print("xPos / _imageSize!.width ${xPos / _imageSize!.width}");
        print("xPos / _imageSize!.width ${yPos / _imageSize!.height}");

        final newTag = tag.copyWith(position: Offset(xPos / _imageSize!.width, yPos / _imageSize!.height));

        ref.read(feedWriteProvider.notifier).updateTag(tag, newTag, widget.imagePositionIndex);

        setState(() {
          draggingTag = null;
        });
      },
      child: draggingTag == tag
          ? Container()
          : MentionTagWidget(
              color: kPreviousTextSubTitleColor.withOpacity(0.8),
              textStyle: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor100),
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
