import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedTitleWidget extends StatelessWidget {
  const FeedTitleWidget({
    required this.image,
    required this.name,
    required this.position,
    required this.time,
    required this.isEdit,
    Key? key,
  }) : super(key: key);

  final String? image;
  final String name;
  final String position;
  final DateTime time;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w, right: 10.w, bottom: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              image == null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        color: kNeutralColor300,
                        child: Image.asset(
                          'assets/image/feed/icon/large_size/icon_taguser.png',
                          height: 32.h,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        image!,
                        height: 32.h,
                      ),
                    ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: kTitle14BoldStyle.copyWith(color: kTextTitleColor),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      Text(
                        position,
                        style:
                            kBody11RegularStyle.copyWith(color: kTextBodyColor),
                      ),
                      Row(
                        children: [
                          Text(
                            " · ",
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                          Text(
                            displayedAt(time),
                            style: kBody11RegularStyle.copyWith(
                                color: kTextBodyColor),
                          ),
                        ],
                      ),
                      isEdit
                          ? Row(
                              children: [
                                Text(
                                  " · ",
                                  style: kBody11RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                                Text(
                                  "수정됨",
                                  style: kBody11RegularStyle.copyWith(
                                      color: kTextBodyColor),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            'assets/image/feed/icon/small_size/icon_more.png',
            height: 32.w,
          ),
        ],
      ),
    );
  }
}
