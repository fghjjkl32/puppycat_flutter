import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:thumbor/thumbor.dart';

class FeedWalkInfoWidget extends StatelessWidget {
  const FeedWalkInfoWidget({
    required this.walkData,
    Key? key,
  }) : super(key: key);

  final List<WalkResultListData>? walkData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Column(
        children: [
          if (walkData != null && walkData!.isNotEmpty)
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: kNeutralColor200,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                        child: Text(
                          "날짜",
                          style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd(EEE)', 'ko_KR').format(DateTime.parse(walkData![0].startDate!)),
                      style: kBody12RegularStyle.copyWith(color: kTextSubTitleColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kNeutralColor200,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Puppycat_social.icon_comment,
                                    size: 20,
                                    color: kTextBodyColor,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "분",
                                    style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                walkData![0].walkTime!,
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 42,
                          child: VerticalDivider(
                            color: kNeutralColor100,
                            thickness: 1.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Puppycat_social.icon_comment,
                                    size: 20,
                                    color: kTextBodyColor,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "걸음",
                                    style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                NumberFormat("#,##0", "en_US").format(walkData![0].step),
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 42,
                          child: VerticalDivider(
                            color: kNeutralColor100,
                            thickness: 1.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Puppycat_social.icon_comment,
                                    size: 20,
                                    color: kTextBodyColor,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "km",
                                    style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${NumberFormat("#,##0.##", "en_US").format(walkData![0].distance)}",
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 42,
                          child: VerticalDivider(
                            color: kNeutralColor100,
                            thickness: 1.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Puppycat_social.icon_comment,
                                    size: 20,
                                    color: kTextBodyColor,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "kcal",
                                    style: kBadge10MediumStyle.copyWith(color: kTextBodyColor),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                "${NumberFormat("#,##0", "en_US").format(walkData![0].calorie!.floor())}",
                                style: kBody11SemiBoldStyle.copyWith(color: kTextSubTitleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
