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
        Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain$avatarUrl").toUrl(),
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, exception, stackTrace) {
          return const Icon(
            Puppycat_social.icon_profile_small,
            size: 30,
            color: kPreviousNeutralColor400,
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
            Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("$imgDomain$avatarUrl").toUrl(),
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stackTrace) {
              return Icon(
                Puppycat_social.icon_profile_small,
                size: 30,
                color: colorFilter == kPreviousPrimaryColor ? colorFilter : kPreviousNeutralColor400,
              );
            },
          ),
          Visibility(
            visible: colorFilter == kPreviousPrimaryColor,
            child: const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: kPreviousNeutralColor100,
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
      colorFilter: colorFilter == kPreviousPrimaryColor ? ColorFilter.mode(colorFilter.withAlpha(50), BlendMode.srcATop) : null,
    ),
  );
}
