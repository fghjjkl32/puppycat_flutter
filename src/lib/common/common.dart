import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

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
        width: width,
        height: height,
        fit: BoxFit.fill,
        errorBuilder: (context, exception, stackTrace) {
          return Image.asset(
            "assets/image/chat/icon_profile_small.png",
            // width: width,
            // height: height,
            // fit: BoxFit.fill,
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
