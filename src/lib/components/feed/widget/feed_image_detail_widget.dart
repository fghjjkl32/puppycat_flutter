import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/show_custom_modal_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/components/feed/widget/dot_indicator.dart';
import 'package:pet_mobile_social_flutter/components/post_feed/mention_tag_widget.dart';
import 'package:pet_mobile_social_flutter/components/user_list/widget/favorite_item_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

class FeedImageDetailWidget extends StatelessWidget {
  FeedImageDetailWidget({
    required this.imageList,
    required this.contentIdx,
    required this.contentType,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;
  final int contentIdx;
  final String contentType;

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 266.0.h,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              _counter.value = index;
            },
          ),
          items: imageList.map((i) {
            return Stack(
              children: [
                Padding(
                  padding: kPrimarySideFeedImagePadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${i.url!}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                ...i.imgMemberTagList!.map((tag) {
                  return Positioned(
                    left: tag.width!.toDouble(),
                    top: tag.height!.toDouble(),
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                            "/home/myPage/followList/${tag.memberIdx}/userPage/${tag.nick}/${tag.memberIdx}");
                      },
                      child: MentionTagWidget(
                        isCanClose: false,
                        color: kTextSubTitleColor.withOpacity(0.8),
                        textStyle: kBody11RegularStyle.copyWith(
                            color: kNeutralColor100),
                        text: tag.nick!,
                        onDelete: () {},
                      ),
                    ),
                  );
                }).toList(),
                if (i.imgMemberTagList!.isNotEmpty)
                  Positioned(
                    left: 20,
                    bottom: 20,
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
                                                  0,
                                              followerIdx: i
                                                  .imgMemberTagList![index]
                                                  .memberIdx!,
                                              contentsIdx: contentIdx,
                                              contentType: contentType,
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
                        child: Icon(Icons.people, color: Colors.black)),
                  ),
              ],
            );
          }).toList(),
        ),
        if (imageList.length != 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: DotIndicator(
              counter: _counter,
              imageListLength: imageList.length,
            ),
          ),
      ],
    );
  }
}
