import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_room_screen.dart';
import 'package:thumbor/thumbor.dart';
import 'package:widget_mask/widget_mask.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> contextProvider = GlobalKey<NavigatorState>();
final GlobalKey<ChatRoomScreenState> chatScreenKey = GlobalKey<ChatRoomScreenState>();
final GlobalKey rowKey = GlobalKey();

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
        thumborUrl(avatarUrl),
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

Widget getProfileAvatarWithBadge(
  String avatarUrl, [
  bool isBadge = false,
  double width = 48,
  double height = 48,
]) {
  return Stack(
    children: [
      getProfileAvatar(avatarUrl, width, height),
      Visibility(
          visible: isBadge,
          child: Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/image/feed/icon/small_size/icon_special.png',
              height: 13,
            ),
          )),
    ],
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
            thumborUrl(avatarUrl),
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

String convertToJsonStringQuotes({required String raw}) {
  String jsonString = raw;

  /// add quotes to json string
  jsonString = jsonString.replaceAll('{', '{"');
  jsonString = jsonString.replaceAll(': ', '": "');
  jsonString = jsonString.replaceAll(', ', '", "');
  jsonString = jsonString.replaceAll('}', '"}');

  /// remove quotes on object json string
  jsonString = jsonString.replaceAll('"{"', '{"');
  jsonString = jsonString.replaceAll('"}"', '"}');

  /// remove quotes on array json string
  jsonString = jsonString.replaceAll('"[{', '[{');
  jsonString = jsonString.replaceAll('}]"', '}]');

  return jsonString;
}

String thumborUrl(String url) {
  return Thumbor(host: thumborHostUrl, key: thumborKey).buildImage(url).toUrl();
}
