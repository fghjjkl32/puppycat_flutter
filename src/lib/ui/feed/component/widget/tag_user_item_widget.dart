import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:widget_mask/widget_mask.dart';

class TagUserItemWidget extends StatelessWidget {
  const TagUserItemWidget({
    required this.profileImage,
    required this.userName,
    required this.content,
    required this.isSpecialUser,
    Key? key,
  }) : super(key: key);

  final String? profileImage;
  final String userName;
  final String content;
  final bool isSpecialUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: getProfileAvatar(profileImage ?? "", 32, 32),
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
                                  height: 13,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                              ],
                            )
                          : Container(),
                      Text(
                        userName,
                        style: kBody13BoldStyle.copyWith(color: kPreviousTextTitleColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    content,
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
