import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/appbar/defalut_on_will_pop_scope.dart';
import 'package:pet_mobile_social_flutter/ui/components/toast/toast.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/feed_write_tag_search_screen.dart';

//사용자가 이미지에 태그를 추가할 수 있는 화면을 정의합니다.
// 화면은 여러 개의 이미지를 탐색할 수 있는 PageView를 포함하며,
// 사용자가 이미지를 탭하면 태그를 추가할 수 있는 위치를 선택할 수 있습니다.
// 사용자가 "등록" 버튼을 누르면 태그가 저장됩니다.
class TagScreen extends ConsumerWidget {
  TagScreen({
    super.key,
  });

  // _counter는 사용자가 현재 보고 있는 이미지의 인덱스를 추적하는데 사용됩니다.
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // croppedFiles는 사용자가 태그를 추가할 이미지 목록을 담고 있습니다.
    List<File> croppedFiles = ref.watch(feedWriteCroppedFilesProvider);

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
                      // 태그 정보를 저장하는 로직입니다.
                      ref.read(feedWriteProvider.notifier).saveTag();

                      // 사용자가 현재 보고 있는 이미지로 carousel을 이동시킵니다.
                      ref.watch(feedWriteCarouselControllerProvider.notifier).jumpToPage(ref.watch(feedWriteCurrentViewCountProvider.notifier).state);

                      // 현재 보고 있는 이미지의 인덱스를 가져옵니다.
                      int currentIndex = ref.watch(feedWriteCurrentViewCountProvider.notifier).state;

                      // 현재 이미지에 추가된 태그 정보를 가져옵니다.
                      List<TagImages> tagImages = ref.watch(feedWriteProvider).tagImage;

                      // 현재 이미지의 태그 정보를 찾습니다.
                      TagImages? currentTagImage = tagImages.firstWhere(
                        (tagImage) => tagImage.index == currentIndex,
                        orElse: () => TagImages(index: 0, tag: []),
                      );

                      // 현재 이미지에 추가된 태그의 수를 업데이트합니다.
                      ref.watch(feedWriteCurrentTagCountProvider.notifier).state = currentTagImage.tag.length;

                      // 현재 상태를 저장합니다.
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
                  children: croppedFiles.asMap().entries.map((entry) {
                    var imageIndex = entry.key;
                    var image = entry.value;

                    return Center(
                      child: TaggableImage(
                        image: image,
                        imagePositionIndex: imageIndex,
                        imageIdx: 0,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DotIndicator(
                  counter: ValueNotifier<int>(ref.watch(feedWriteCurrentViewCountProvider.notifier).state),
                  imageListLength: croppedFiles.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 이미지에 태그를 추가할 수 있는 위젯입니다.
// 사용자가 이미지를 탭하면, 태그를 추가할 위치를 선택하고,
// FeedWriteTagSearchScreen으로 넘어가 태그할 유저를 검색할 수 있습니다.
class TaggableImage extends ConsumerStatefulWidget {
  final File image;
  final int imagePositionIndex;
  final int imageIdx;
  final GlobalKey imageKey = GlobalKey();

  TaggableImage({
    super.key,
    required this.image,
    required this.imagePositionIndex,
    required this.imageIdx,
  });

  @override
  _TaggableImageState createState() => _TaggableImageState();
}

class _TaggableImageState extends ConsumerState<TaggableImage> with AutomaticKeepAliveClientMixin {
  Tag? draggingTag; // 현재 드래그 중인 태그 (null이면 드래그 중인 태그 없음)
  Size? _imageSize; // 이미지의 크기

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // 이미지 위젯의 렌더링 박스(RenderBox)를 가져옵니다.
      final RenderBox? imageBox = widget.imageKey.currentContext?.findRenderObject() as RenderBox?;
      if (imageBox != null) {
        setState(() {
          _imageSize = imageBox.size; // 이미지의 크기를 상태 변수에 저장
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PostFeedState state = ref.watch(feedWriteProvider);

    // 현재 이미지 위치에 해당하는 태그 이미지를 찾습니다.
    List<TagImages> taggedImages = state.tagImage;
    TagImages tagImages = taggedImages.firstWhere((tagImage) => tagImage.index == widget.imagePositionIndex, orElse: () => TagImages(index: widget.imagePositionIndex, tag: []));

    List<Tag> tags = tagImages.tag;

    return GestureDetector(
      onTapUp: (details) {
        RenderBox box = context.findRenderObject() as RenderBox; // 현재 위젯의 렌더링 박스

        // 탭된 위치를 상대적인 이미지 위치로 변환합니다.
        final Offset localPosition = box.globalToLocal(details.globalPosition);
        final RenderBox imageBox = widget.imageKey.currentContext!.findRenderObject() as RenderBox;
        final Size displayedImageSize = imageBox.size;

        final double xRatio = localPosition.dx / displayedImageSize.width;
        final double yRatio = localPosition.dy / displayedImageSize.height;

        // 새로운 태그 이미지 목록을 생성합니다.
        List<TagImages> newTagImage = List.from(state.tagImage);
        int existingIndex = -1;

        // 현재 이미지 위치에 해당하는 태그 이미지의 인덱스를 찾습니다.
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
              // tapLocation,
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
              child: Image.file(
                widget.image,
                key: widget.imageKey,
              ),
            ),
          ),
          // 태그된 위치에 태그를 표시합니다.
          ...tags.map((tag) {
            if (_imageSize == null) {
              return Container();
            }

            return Positioned(
              top: _imageSize!.height * tag.position.dy, // 태그의 y 위치
              left: _imageSize!.width * tag.position.dx, // 태그의 x 위치
              child: buildDraggableTag(tag), // 드래그 가능한 태그 위젯
            );
          }).toList(),
        ],
      ),
    );
  }

  //TaggableImage 클래스의 일부로,
  // Flutter에서 이미지 위에 태그를
  // 드래그 앤 드롭으로 이동시킬 수 있는 Draggable<Tag> 위젯을 생성하는 함수 buildDraggableTag를 정의합니다.
  // 각 태그는 사용자 이름을 표시하고, 태그의 위치를 조정합니다.
  Draggable<Tag> buildDraggableTag(Tag tag) {
    return Draggable<Tag>(
      // 드래그되는 데이터는 Tag 객체입니다.
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
      // 드래그가 시작될 때 호출되는 함수입니다.
      onDragStarted: () {
        setState(() {
          draggingTag = tag; // 현재 드래그 중인 태그를 상태로 설정합니다.
        });
      },
      // 드래그가 끝났을 때 호출되는 함수입니다.
      onDragEnd: (dragDetails) {
        RenderBox box = context.findRenderObject() as RenderBox; // 현재 위젯의 위치와 크기 정보를 가져옵니다.
        RenderBox imageBox = widget.imageKey.currentContext!.findRenderObject() as RenderBox; // 이미지 위젯의 위치와 크기 정보를 가져옵니다.

        // 이미지의 높이와 너비에서 여백을 고려하여 조정합니다.
        double imageHeight = imageBox.size.height - 40;
        double imageWidth = imageBox.size.width - 50;

        // 드래그가 끝난 지점의 상대 위치를 계산합니다.
        Offset localPosition = box.globalToLocal(dragDetails.offset);

        print(" localPosition.dx ${localPosition.dx}");
        print(" localPosition.dy ${localPosition.dy}");

        // 새로운 태그의 위치를 계산합니다. 이미지 바깥으로 나가지 않도록 조정합니다.
        double xPos = localPosition.dx;
        double yPos = localPosition.dy;

        if (xPos < 10) xPos = 10;
        if (yPos < 0) yPos = 0;
        if (xPos > imageWidth) xPos = imageWidth;
        if (yPos > imageHeight) yPos = imageHeight;

        print("xPos / _imageSize!.width ${xPos / _imageSize!.width}");
        print("xPos / _imageSize!.width ${yPos / _imageSize!.height}");

        // 새 위치를 기준으로 태그 객체를 업데이트합니다.
        final newTag = tag.copyWith(position: Offset(xPos / _imageSize!.width, yPos / _imageSize!.height));

        // 업데이트된 태그 정보를 상태에 반영합니다.
        ref.read(feedWriteProvider.notifier).updateTag(tag, newTag, widget.imagePositionIndex);

        setState(() {
          // 드래그 작업이 완료된 후, draggingTag 상태를 null로 설정합니다.
          draggingTag = null;
        });
      },
      // 드래그되지 않을 때 보여지는  위젯입니다.
      child: draggingTag == tag
          ? Container() // 드래그 중인 태그는 숨깁니다.
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
