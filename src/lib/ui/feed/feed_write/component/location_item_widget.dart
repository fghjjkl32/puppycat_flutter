import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed_write/location_item.dart';

class LocationUserItemWidget extends StatelessWidget {
  const LocationUserItemWidget({
    required this.locationItem,
    Key? key,
  }) : super(key: key);

  final LocationItem locationItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 36,
                  height: 36,
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
                  const SizedBox(
                    height: 2,
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
