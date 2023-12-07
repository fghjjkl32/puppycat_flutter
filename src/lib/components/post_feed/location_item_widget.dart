import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/location_item.dart';

class LocationUserItemWidget extends StatelessWidget {
  const LocationUserItemWidget({
    required this.locationItem,
    Key? key,
  }) : super(key: key);

  final LocationItem locationItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 6.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0.w),
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPreviousNeutralColor300,
                  ),
                  child: const Center(
                    child: Icon(
                      Puppycat_social.icon_place,
                      size: 22,
                      color: kPreviousTextBodyColor,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationItem.name,
                    style: kBody14BoldStyle.copyWith(color: kPreviousTextTitleColor),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    locationItem.subName,
                    style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
