import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:widget_mask/widget_mask.dart';


enum ListAPIStatus {
  idle,
  loading,
  loaded,
  error,
}

Widget getProfileAvatar(String avatarUrl, [String defaultAssetPath = 'assets/image/common/icon_profile_medium.png', double width = 48, double height = 48]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: Image.network(
        avatarUrl,
        width: width,
        height: height,
        fit: BoxFit.fill,
        errorBuilder: (context, exception, stackTrace) {
          return Image.asset(
            defaultAssetPath,
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
