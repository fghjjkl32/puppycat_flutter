import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';

class CroppedImagesListView extends ConsumerStatefulWidget {
  const CroppedImagesListView({
    Key? key,
    required this.progress,
    required this.croppedFiles,
  }) : super(key: key);

  final double? progress;
  final List<File> croppedFiles;

  @override
  CroppedImagesListViewState createState() => CroppedImagesListViewState();
}

class CroppedImagesListViewState extends ConsumerState<CroppedImagesListView> {
  bool alreadyLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.progress == 1.0 && !alreadyLoaded) {
      ref.read(feedWriteCroppedFilesProvider.notifier).addAll(widget.croppedFiles);
      alreadyLoaded = true;
    }

    PostFeedState state = ref.watch(feedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;

    final providerCroppedFiles = ref.watch(feedWriteCroppedFilesProvider);

    if (widget.progress == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          CarouselSlider.builder(
            carouselController: ref.watch(feedWriteCarouselControllerProvider),
            options: CarouselOptions(
              initialPage: ref.watch(feedWriteCurrentViewCountProvider),
              viewportFraction: getViewportFractionCalculateValue(MediaQuery.of(context).size.width),
              height: getImageHeightCalculateValue(MediaQuery.of(context).size.width),
              enableInfiniteScroll: false,
              padEnds: false,
              onPageChanged: (index, reason) {
                ref.watch(feedWriteCurrentTagCountProvider.notifier).state = taggedImages.firstWhere((tagImage) => tagImage.index == index, orElse: () => TagImages(index: index, tag: [])).tag.length;

                ref.watch(feedWriteCurrentViewCountProvider.notifier).state = index;
              },
            ),
            itemCount: providerCroppedFiles.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              File file = providerCroppedFiles[index];

              TagImages tagImages = taggedImages.firstWhere((tagImage) => tagImage.index == index, orElse: () => TagImages(index: index, tag: []));

              List<Tag> tags = tagImages.tag;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: kBlackColor,
                        child: Image.file(
                          file,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: providerCroppedFiles.length > 1
                        ? GestureDetector(
                            onTap: () {
                              ref.read(feedWriteCroppedFilesProvider.notifier).removeAt(index);

                              ref.read(feedWriteProvider.notifier).removeTagsFromImage(index);

                              if (index >= 0 && index < taggedImages.length - 1) {
                                ref.watch(feedWriteCurrentTagCountProvider.notifier).state = taggedImages[index + 1].tag.length;
                              } else {
                                ref.watch(feedWriteCurrentTagCountProvider.notifier).state = 0;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: kPreviousTextSubTitleColor.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              height: 28,
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: kPreviousNeutralColor100,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  if (tags.isNotEmpty)
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff414348).withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Puppycat_social.icon_taguser,
                            size: 24,
                            color: kPreviousNeutralColor100,
                          ),
                        ),
                      ),
                    ),

                  // ...tags.map((item) {
                  //   return Positioned(
                  //     top: item.position.dy,
                  //     left: item.position.dx,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         ref.read(feedWriteProvider.notifier).removeTag(item);
                  //         ref.watch(feedWriteCurrentTagCountProvider.notifier).state =
                  //             taggedImages.firstWhere((tagImage) => tagImage.index == index, orElse: () => TagImages(index: index, tag: [])).tag.length - 1;
                  //       },
                  //       child: MentionTagWidget(
                  //         color: kTextSubTitleColor.withOpacity(0.8),
                  //         textStyle: kBody11RegularStyle.copyWith(color: kNeutralColor100),
                  //         text: item.username,
                  //         onDelete: () {
                  //           ref.read(feedWriteProvider.notifier).removeTag(item);
                  //
                  //           ref.watch(feedWriteCurrentTagCountProvider.notifier).state =
                  //               taggedImages.firstWhere((tagImage) => tagImage.index == index, orElse: () => TagImages(index: index, tag: [])).tag.length - 1;
                  //         },
                  //       ),
                  //     ),
                  //   );
                  // }).toList(),
                ],
              );
            },
          ),
          if (widget.progress! < 1.0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
                ),
              ),
            ),
          if (widget.progress! < 1.0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    backgroundColor: kPrimaryColor600.withOpacity(.5),
                    color: kPrimaryColor600,
                    value: widget.progress,
                    semanticsLabel: '${widget.progress! * 100}%',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
