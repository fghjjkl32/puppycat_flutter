import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/main/feed/detail/feed_detail_state_provider.dart';
import 'package:thumbor/thumbor.dart';

class FeedImageDetailWidget extends ConsumerStatefulWidget {
  FeedImageDetailWidget({
    required this.imageList,
    required this.contentIdx,
    required this.contentType,
    required this.isLike,
    required this.memberIdx,
    required this.imgDomain,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;
  final int contentIdx;
  final String contentType;
  final bool isLike;
  final int? memberIdx;
  final String imgDomain;

  @override
  FeedImageDetailWidgetState createState() => FeedImageDetailWidgetState();
}

class FeedImageDetailWidgetState extends ConsumerState<FeedImageDetailWidget>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isTagVisible = ValueNotifier<bool>(true);

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 1.0);

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        if (_isTagVisible.value) {
          _fadeController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (_isTagVisible.value) {
              _fadeController.reverse();
            } else {
              _fadeController.forward();
            }
            _isTagVisible.value = !_isTagVisible.value;
          },
          onDoubleTap: () {
            widget.isLike
                ? null
                : ref.watch(feedDetailStateProvider.notifier).postLike(
                      loginMemberIdx: ref.read(userModelProvider)!.idx,
                      memberIdx: widget.memberIdx,
                      contentIdx: widget.contentIdx,
                      contentType: widget.contentType,
                    );
          },
          child: CarouselSlider(
            options: CarouselOptions(
              height: 266.0.h,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                _counter.value = index;
              },
            ),
            items: widget.imageList.map((i) {
              return Stack(
                children: [
                  Padding(
                    padding: kPrimarySideFeedImagePadding,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        Thumbor(host: thumborHostUrl, key: thumborKey)
                            .buildImage("$imgDomain${i.url}")
                            .toUrl(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // ZoomOverlay(
                      //   modalBarrierColor: Colors.black12, // Optional
                      //   minScale: 0.5, // Optional
                      //   maxScale: 3.0, // Optional
                      //   animationCurve: Curves
                      //       .fastOutSlowIn, // Defaults to fastOutSlowIn which mimics IOS instagram behavior
                      //   animationDuration: Duration(
                      //       milliseconds:
                      //           300), // Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
                      //   twoTouchOnly: true, // Defaults to false
                      //   onScaleStart: () {}, // optional VoidCallback
                      //   onScaleStop: () {}, // optional VoidCallback
                      //   child: Image.network(
                      //     Thumbor(host: thumborHostUrl, key: thumborKey)
                      //         .buildImage("$imgDomain${i.url}")
                      //         .toUrl(),
                      //     fit: BoxFit.cover,
                      //     width: double.infinity,
                      //     height: double.infinity,
                      //   ),
                      // ),
                    ),
                  ),
                  ...i.imgMemberTagList!.map((tag) {
                    return Positioned(
                      left: tag.width!.toDouble(),
                      top: tag.height!.toDouble(),
                      child: FadeTransition(
                        opacity: _fadeController,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isTagVisible,
                          builder: (BuildContext context, bool isTagVisible,
                              Widget? child) {
                            return isTagVisible
                                ? GestureDetector(
                                    onTap: () {
                                      _isTagVisible.value =
                                          !_isTagVisible.value;
                                    },
                                    child: MentionTagWidget(
                                      isCanClose: false,
                                      color:
                                          kTextSubTitleColor.withOpacity(0.8),
                                      textStyle: kBody11RegularStyle.copyWith(
                                          color: kNeutralColor100),
                                      text: tag.nick!,
                                      onDelete: () {},
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  if (i.imgMemberTagList!.isNotEmpty)
                    Positioned(
                      left: 20,
                      bottom: 10,
                      child: InkWell(
                        onTap: () {
                          showCustomModalBottomSheet(
                            context: context,
                            widget: SizedBox(
                              height: 500.h,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 8.0.h,
                                          bottom: 10.0.h,
                                        ),
                                        child: Text(
                                          "태그된 대상",
                                          style:
                                              kTitle16ExtraBoldStyle.copyWith(
                                                  color: kTextSubTitleColor),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: i.imgMemberTagList!.length,
                                          padding:
                                              EdgeInsets.only(bottom: 80.h),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return FavoriteItemWidget(
                                              profileImage: i
                                                  .imgMemberTagList![index]
                                                  .profileImgUrl,
                                              userName: i
                                                  .imgMemberTagList![index]
                                                  .nick!,
                                              content: i
                                                  .imgMemberTagList![index]
                                                  .intro!,
                                              isSpecialUser: i
                                                      .imgMemberTagList![index]
                                                      .isBadge ==
                                                  1,
                                              isFollow: i
                                                      .imgMemberTagList![index]
                                                      .followState ==
                                                  1,
                                              followerIdx: i
                                                  .imgMemberTagList![index]
                                                  .memberIdx!,
                                              contentsIdx: widget.contentIdx,
                                              contentType: widget.contentType,
                                              oldMemberIdx: widget.memberIdx!,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                              color: kNeutralColor100,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        if (widget.imageList.length != 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: DotIndicator(
              counter: _counter,
              imageListLength: widget.imageList.length,
            ),
          ),
      ],
    );
  }
}
