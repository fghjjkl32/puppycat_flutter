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
        Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$avatarUrl").toUrl(),
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
}

Widget getSquircleImage(
  String avatarUrl, [
  double width = 48,
  double height = 48,
  Color colorFilter = Colors.transparent,
]) {
  return WidgetMask(
    blendMode: BlendMode.srcATop,
    childSaveLayer: true,
    mask: Center(
      child: Stack(
        children: [
          Image.network(
            Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$avatarUrl").toUrl(),
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stackTrace) {
              return Icon(
                Puppycat_social.icon_profile_small,
                size: 30,
                color: colorFilter == kPrimaryColor ? colorFilter : kNeutralColor400,
              );
            },
          ),
          Visibility(
            visible: colorFilter == kPrimaryColor,
            child: const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: kNeutralColor100,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    child: SvgPicture.asset(
      'assets/image/feed/image/squircle.svg',
      width: width,
      height: height,
      fit: BoxFit.fill,
      colorFilter: colorFilter == kPrimaryColor ? ColorFilter.mode(colorFilter.withAlpha(50), BlendMode.srcATop) : null,
    ),
  );
}
