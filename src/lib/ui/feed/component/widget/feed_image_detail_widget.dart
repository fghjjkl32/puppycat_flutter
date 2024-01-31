import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/providers/feed/detail/feed_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/ui/feed/component/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/component/mention_tag_widget.dart';

class FeedImageDetailWidget extends ConsumerStatefulWidget {
  FeedImageDetailWidget({
    required this.imageList,
    required this.contentIdx,
    required this.contentType,
    required this.isLike,
    required this.memberUuid,
    // required this.imgDomain,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;
  final int contentIdx;
  final String contentType;
  final bool isLike;
  final String memberUuid;

  // final String imgDomain;

  @override
  FeedImageDetailWidgetState createState() => FeedImageDetailWidgetState();
}

class FeedImageDetailWidgetState extends ConsumerState<FeedImageDetailWidget> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isTagVisible = ValueNotifier<bool>(true);

  late AnimationController _fadeController;

  double width = 0.0;
  double height = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 1), value: 1.0);

    Future.delayed(const Duration(seconds: 2), () {
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
    final myInfo = ref.read(myInfoStateProvider);
    final isLogined = ref.read(loginStatementProvider);

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
                : ref.watch(feedListStateProvider.notifier).toggleLike(
                      contentIdx: widget.contentIdx,
                    );
          },
          child: CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                _counter.value = index;
              },
            ),
            items: widget.imageList.map((i) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      Container(
                        color: kBlackColor,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  color: kPreviousNeutralColor300,
                                ),
                                imageUrl: thumborUrl(i.url ?? ''),
                                // fit: BoxFit.cover,
                              ),
                              ...i.imgMemberTagList!.map((tag) {
                                return Positioned.fill(
                                  child: Align(
                                    alignment: FractionalOffset(tag.width!.toDouble(), tag.height!.toDouble()),
                                    child: FadeTransition(
                                      opacity: _fadeController,
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable: _isTagVisible,
                                        builder: (BuildContext context, bool isTagVisible, Widget? child) {
                                          return isTagVisible
                                              ? GestureDetector(
                                                  onTap: () {
                                                    myInfo.uuid == tag.memberUuid ? context.push("/member/myPage") : context.push("/member/userPage/${tag.nick!}/${tag.memberUuid}/${tag.memberUuid}");
                                                  },
                                                  child: MentionTagWidget(
                                                    isCanClose: false,
                                                    color: kPreviousTextSubTitleColor.withOpacity(0.8),
                                                    textStyle: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor100),
                                                    text: tag.nick!,
                                                    onDelete: () {},
                                                  ),
                                                )
                                              : const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                      if (i.imgMemberTagList!.isNotEmpty)
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: InkWell(
                            onTap: () {
                              showCustomModalBottomSheet(
                                context: context,
                                widget: SizedBox(
                                  height: 500,
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 10.0,
                                            ),
                                            child: Text(
                                              "태그된 대상",
                                              style: kTitle16ExtraBoldStyle.copyWith(color: kPreviousTextSubTitleColor),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: i.imgMemberTagList!.length,
                                              padding: const EdgeInsets.only(bottom: 80),
                                              itemBuilder: (BuildContext context, int index) {
                                                return FavoriteItemWidget(
                                                  profileImage: i.imgMemberTagList![index].profileImgUrl,
                                                  userName: i.imgMemberTagList![index].nick!,
                                                  content: i.imgMemberTagList![index].intro!,
                                                  isSpecialUser: i.imgMemberTagList![index].isBadge == 1,
                                                  isFollow: i.imgMemberTagList![index].followState == 1,
                                                  followerUuid: i.imgMemberTagList![index].memberUuid!,
                                                  contentsIdx: widget.contentIdx,
                                                  contentType: widget.contentType,
                                                  oldMemberUuid: widget.memberUuid,
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
                                  color: kPreviousNeutralColor100,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.imageList.length != 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DotIndicator(
              counter: _counter,
              imageListLength: widget.imageList.length,
            ),
          ),
      ],
    );
  }
}
