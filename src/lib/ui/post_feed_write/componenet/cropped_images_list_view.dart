import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/cropped_files_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/viewmodels/post_feed/post_feed_write_provider.dart';

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
      ref.read(croppedFilesProvider.notifier).addAll(widget.croppedFiles);
      alreadyLoaded = true;
    }

    PostFeedState state = ref.watch(postFeedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;

    final providerCroppedFiles = ref.watch(croppedFilesProvider);

    if (widget.progress == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          CarouselSlider.builder(
            carouselController: ref.watch(carouselControllerProvider),
            options: CarouselOptions(
              initialPage: ref.watch(currentViewCountProvider),
              height: 260.0.h,
              enableInfiniteScroll: false,
              aspectRatio: 1,
              padEnds: false,
              onPageChanged: (index, reason) {
                ref.watch(currentTagCountProvider.notifier).state = taggedImages
                    .firstWhere((tagImage) => tagImage.index == index,
                        orElse: () => TagImages(index: index, tag: []))
                    .tag
                    .length;

                ref.watch(currentViewCountProvider.notifier).state = index;
              },
            ),
            itemCount: providerCroppedFiles.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              File file = providerCroppedFiles[index];

              TagImages tagImages = taggedImages.firstWhere(
                  (tagImage) => tagImage.index == index,
                  orElse: () => TagImages(index: index, tag: []));

              List<Tag> tags = tagImages.tag;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.file(
                          width: 300.w,
                          height: 225.h,
                          file,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: -10,
                      child: providerCroppedFiles.length > 1
                          ? GestureDetector(
                              onTap: () {
                                ref
                                    .read(croppedFilesProvider.notifier)
                                    .removeAt(index);

                                ref
                                    .read(postFeedWriteProvider.notifier)
                                    .removeTagsFromImage(index);

                                if (index >= 0 &&
                                    index < taggedImages.length - 1) {
                                  ref
                                      .watch(currentTagCountProvider.notifier)
                                      .state = taggedImages[
                                          index + 1]
                                      .tag
                                      .length;
                                } else {
                                  ref
                                      .watch(currentTagCountProvider.notifier)
                                      .state = 0;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: kTextSubTitleColor.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                height: 28.h,
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: kNeutralColor100,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    ...tags.map((item) {
                      return Positioned(
                        top: item.position.dy,
                        left: item.position.dx,
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(postFeedWriteProvider.notifier)
                                .removeTag(item);
                            ref
                                .watch(currentTagCountProvider.notifier)
                                .state = taggedImages
                                    .firstWhere(
                                        (tagImage) => tagImage.index == index,
                                        orElse: () =>
                                            TagImages(index: index, tag: []))
                                    .tag
                                    .length -
                                1;
                          },
                          child: MentionTagWidget(
                            color: kTextSubTitleColor.withOpacity(0.8),
                            textStyle: kBody11RegularStyle.copyWith(
                                color: kNeutralColor100),
                            text: item.username,
                            onDelete: () {
                              ref
                                  .read(postFeedWriteProvider.notifier)
                                  .removeTag(item);

                              ref
                                  .watch(currentTagCountProvider.notifier)
                                  .state = taggedImages
                                      .firstWhere(
                                          (tagImage) => tagImage.index == index,
                                          orElse: () =>
                                              TagImages(index: index, tag: []))
                                      .tag
                                      .length -
                                  1;
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
          if (widget.progress! < 1.0)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
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
