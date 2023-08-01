import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:widget_mask/widget_mask.dart';

Widget getProfileAvatar(String avatarUrl, [bool isAsset = false, double width = 48, double height = 48]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: isAsset ? Image.asset(
        // avatarUrl,
        avatarUrl  == '' ? 'assets/image/common/icon_profile_medium.png' : avatarUrl,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ) : Image.network(
        avatarUrl,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    ),
    child: SvgPicture.asset(
      'assets/image/feed/image/squircle.svg',
      width: width,
      height: height,
      fit: BoxFit.fill,
    ),
  );
}