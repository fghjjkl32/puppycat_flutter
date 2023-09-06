import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

enum ListAPIStatus {
  idle,
  loading,
  loaded,
  error,
}

Widget getProfileAvatar(
  String avatarUrl, [
  double width = 48,
  double height = 48,
]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: Image.network(
        Thumbor(host: thumborHostUrl, key: thumborKey)
            .buildImage("$imgDomain$avatarUrl")
            .toUrl(),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) {
          return const Icon(
            Puppycat_social.icon_profile_small,
            size: 30,
            color: kNeutralColor400,
          );
        },
      ),
    ),
    child: SvgPicture.asset(
      'assets/image/feed/image/squircle.svg',
      width: width,
      height: height,
      fit: BoxFit.fill,
    ),
  );

  // return WidgetMask(
  //   blendMode: BlendMode.srcATop,
  //   childSaveLayer: true,
  //   mask: Center(
  //     child: isAsset ? Image.asset(
  //       // avatarUrl,
  //       avatarUrl  == '' ? 'assets/image/common/icon_profile_medium.png' : avatarUrl,
  //       width: width,
  //       height: height,
  //       fit: BoxFit.fill,
  //     ) : Image.network(
  //       avatarUrl,
  //       width: width,
  //       height: height,
  //       fit: BoxFit.fill,
  //     ),
  //   ),
  //   child: SvgPicture.asset(
  //     'assets/image/feed/image/squircle.svg',
  //     width: width,
  //     height: height,
  //     fit: BoxFit.fill,
  //   ),
  // );
}
