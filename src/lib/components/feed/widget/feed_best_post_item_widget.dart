import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class FeedBestPostItemWidget extends StatelessWidget {
  const FeedBestPostItemWidget({
    required this.imageCount,
    required this.image,
    Key? key,
  }) : super(key: key);

  final int imageCount;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: Image.network(
              thumborUrl(image ?? ''),
              fit: BoxFit.cover,
              height: 112,
              width: 154,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff414348).withOpacity(0.75),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              width: 18,
              height: 14,
              child: Center(
                child: Text(
                  "$imageCount",
                  style: kBadge9RegularStyle.copyWith(color: kPreviousNeutralColor100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
