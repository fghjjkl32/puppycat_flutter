import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data.dart';
import 'package:widget_mask/widget_mask.dart';

class FeedFollowCardWidget extends StatelessWidget {
  const FeedFollowCardWidget({
    required this.profileImage,
    required this.userName,
    required this.imageList,
    required this.followCount,
    required this.isSpecialUser,
    required this.memberIdx,
    Key? key,
  }) : super(key: key);

  final List<ContentsListData> imageList;
  final String? profileImage;
  final String userName;
  final int followCount;
  final bool isSpecialUser;
  final int memberIdx;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: kNeutralColor300,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        width: 230.w,
        height: 202.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                context.push(
                    "/home/myPage/followList/$memberIdx/userPage/$userName/$memberIdx");
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      top: 12.h,
                      bottom: 12.h,
                      right: 8.w,
                    ),
                    child: profileImage == null
                        ? WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: Center(
                              child: Image.asset(
                                'assets/image/feed/icon/large_size/icon_taguser.png',
                                height: 32.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/image/feed/image/squircle.svg',
                              height: 32.h,
                            ),
                          )
                        : WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: Center(
                              child: Image.network(
                                "https://dev-imgs.devlabs.co.kr${profileImage!}",
                                height: 32.h,
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/image/feed/image/squircle.svg',
                              height: 32.h,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          isSpecialUser
                              ? Row(
                                  children: [
                                    Image.asset(
                                      'assets/image/feed/icon/small_size/icon_special.png',
                                      height: 13.h,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                  ],
                                )
                              : Container(),
                          Text(
                            userName,
                            style: kBody13BoldStyle.copyWith(
                                color: kTextTitleColor),
                          ),
                          Text(
                            "  ·  ",
                            style: kBody11RegularStyle.copyWith(
                                color: kNeutralColor400),
                          ),
                          Text(
                            "팔로우",
                            style: kButton12BoldStyle.copyWith(
                                color: kPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "팔로워 ${NumberFormat('###,###,###,###').format(followCount)}",
                        style:
                            kBody11RegularStyle.copyWith(color: kTextBodyColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (imageList.length == 1)
              ...[]
            else if (imageList.length == 2)
              ...[]
            else if (imageList.length == 3) ...[
              Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            "https://dev-imgs.devlabs.co.kr${imageList[0].imgUrl!}",
                            fit: BoxFit.cover,
                            height: 147.h,
                          ),
                        ),
                        Positioned(
                          right: 4.w,
                          top: 4.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff414348).withOpacity(0.75),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            width: 18.w,
                            height: 14.w,
                            child: Center(
                              child: Text(
                                "${imageList[0].imageCnt}",
                                style: kBadge9RegularStyle.copyWith(
                                    color: kNeutralColor100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              "https://dev-imgs.devlabs.co.kr${imageList[1].imgUrl!}",
                              fit: BoxFit.cover,
                              height: 73.h,
                            ),
                            Positioned(
                              right: 4.w,
                              top: 4.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xff414348).withOpacity(0.75),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                width: 18.w,
                                height: 14.w,
                                child: Center(
                                  child: Text(
                                    "${imageList[1].imageCnt}",
                                    style: kBadge9RegularStyle.copyWith(
                                        color: kNeutralColor100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(12.0),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                "https://dev-imgs.devlabs.co.kr${imageList[2].imgUrl!}",
                                fit: BoxFit.cover,
                                height: 73.h,
                              ),
                              Positioned(
                                right: 4.w,
                                top: 4.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff414348)
                                        .withOpacity(0.75),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  width: 18.w,
                                  height: 14.w,
                                  child: Center(
                                    child: Text(
                                      "${imageList[2].imageCnt}",
                                      style: kBadge9RegularStyle.copyWith(
                                          color: kNeutralColor100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
