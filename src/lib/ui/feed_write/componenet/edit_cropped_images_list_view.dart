import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_carousel_controller_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_tag_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_current_view_count_provider.dart';
import 'package:pet_mobile_social_flutter/providers/feed_write/feed_write_provider.dart';
import 'package:thumbor/thumbor.dart';

class EditCroppedImagesListView extends ConsumerStatefulWidget {
  const EditCroppedImagesListView({
    Key? key,
    required this.feedData,
  }) : super(key: key);

  final FeedData feedData;

  @override
  CroppedImagesListViewState createState() => CroppedImagesListViewState();
}

class CroppedImagesListViewState extends ConsumerState<EditCroppedImagesListView> {
  bool alreadyLoaded = false;

  @override
  Widget build(BuildContext context) {
    PostFeedState state = ref.watch(feedWriteProvider);
    List<TagImages> taggedImages = state.tagImage;

    // final providerCroppedFiles = ref.watch(feedWriteCroppedFilesProvider);

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
            itemCount: widget.feedData.imgList!.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              // File file = providerCroppedFiles[index];

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
                        child: Image.network(
                          Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${widget.feedData.imgList![index].url!}").toUrl(),
                        ),
                      ),
                    ),
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
                  //         ref
                  //             .read(feedWriteProvider.notifier)
                  //             .removeTag(item);
                  //         ref
                  //             .watch(
                  //                 feedWriteCurrentTagCountProvider.notifier)
                  //             .state = taggedImages
                  //                 .firstWhere(
                  //                     (tagImage) => tagImage.index == index,
                  //                     orElse: () =>
                  //                         TagImages(index: index, tag: []))
                  //                 .tag
                  //                 .length -
                  //             1;
                  //       },
                  //       child: MentionTagWidget(
                  //         color: kTextSubTitleColor.withOpacity(0.8),
                  //         textStyle: kBody11RegularStyle.copyWith(
                  //             color: kNeutralColor100),
                  //         text: item.username,
                  //         onDelete: () {
                  //           ref
                  //               .read(feedWriteProvider.notifier)
                  //               .removeTag(item);
                  //
                  //           ref
                  //               .watch(
                  //                   feedWriteCurrentTagCountProvider.notifier)
                  //               .state = taggedImages
                  //                   .firstWhere(
                  //                       (tagImage) => tagImage.index == index,
                  //                       orElse: () =>
                  //                           TagImages(index: index, tag: []))
                  //                   .tag
                  //                   .length -
                  //               1;
                  //         },
                  //       ),
                  //     ),
                  //   );
                  // }).toList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
