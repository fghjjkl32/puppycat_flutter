import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/common/library/wechat_assets_picker/delegates/asset_picker_builder_delegate.dart';
import 'package:pet_mobile_social_flutter/common/library/wechat_assets_picker/widget/asset_picker.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/ui/feed/comment/comment_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/detail/feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_edit/feed_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_unknown/feed_not_found_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/feed_write/feed_write_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/not_follow/feed_not_follow_screen.dart';
import 'package:pet_mobile_social_flutter/ui/feed/report/main_feed_report_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class FeedRoute extends GoRouteData {
  final Ref ref;

  FeedRoute({
    required this.ref,
  });

  GoRoute createRoute() {
    return GoRoute(
      path: '/feed',
      name: 'feed',
      builder: (BuildContext context, GoRouterState state) {
        return Container();
      },
      routes: [
        DetailRoute().createRoute(),
        WriteRoute().createRoute(),
        EditRoute().createRoute(),
        CommentRoute().createRoute(),
        ReportRoute(ref: ref).createRoute(),
        FeedUnknownRoute().createRoute(),
        NotFollowRoute().createRoute(),
        SelectImageRoute().createRoute(),
      ],
    );
  }
}

class DetailRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'detail',
      name: 'detail',
      builder: (BuildContext context, GoRouterState state) {
        String firstTitle = '';
        String secondTitle = '';
        String memberUuid = '';
        int contentIdx = 0;
        String contentType = '';
        String? oldMemberUuid;

        bool isRouteComment = false;
        int? commentFocusIndex;
        final extraData = state.extra;
        print('11');
        if (extraData != null) {
          Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
          if (extraMap.keys.contains('isRouteComment')) {
            isRouteComment = extraMap['isRouteComment'];
          }
          if (extraMap.keys.contains('focusIdx')) {
            print('33');
            final fIdx = extraMap['focusIdx'];
            if (fIdx is int) {
              commentFocusIndex = extraMap['focusIdx'];
            } else {
              commentFocusIndex = int.parse(extraMap['focusIdx']);
            }
            print('44');
          }
          if (extraMap.keys.contains('firstTitle')) {
            firstTitle = extraMap['firstTitle'];
          }
          if (extraMap.keys.contains('secondTitle')) {
            secondTitle = extraMap['secondTitle'];
          }
          if (extraMap.keys.contains('memberUuid')) {
            memberUuid = extraMap['memberUuid'];
          }
          if (extraMap.keys.contains('contentIdx')) {
            final cIdx = extraMap['contentIdx'];
            if (cIdx is int) {
              contentIdx = extraMap['contentIdx'];
            } else {
              contentIdx = int.parse(extraMap['contentIdx']);
            }
          }
          if (extraMap.keys.contains('contentType')) {
            contentType = extraMap['contentType'];
          }
          if (extraMap.keys.contains('oldMemberUuid')) {
            oldMemberUuid = extraMap['oldMemberUuid'];
          }
        }

        print('22');
        return FeedDetailScreen(
          firstTitle: firstTitle,
          secondTitle: secondTitle,
          memberUuid: memberUuid,
          contentIdx: contentIdx,
          contentType: contentType,
          isRouteComment: isRouteComment,
          commentFocusIndex: commentFocusIndex,
          oldMemberUuid: oldMemberUuid ?? '',
        );
      },
    );
  }
}

class WriteRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'write',
      name: 'write',
      builder: (BuildContext context, GoRouterState state) {
        return FeedWriteScreen(cropStream: state.extra as Stream<InstaAssetsExportDetails>);
      },
    );
  }
}

class EditRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'edit',
      name: 'edit',
      builder: (BuildContext context, GoRouterState state) {
        FeedData? feedData;
        int? contentIdx;
        if (state.extra != null) {
          Map<dynamic, dynamic> extraMap = {};
          extraMap = state.extra! as Map<String, dynamic>;

          if (extraMap.containsKey('feedData')) {
            feedData = extraMap['feedData'];
          }

          if (extraMap.containsKey('contentIdx')) {
            contentIdx = extraMap['contentIdx'];
          }
        }
        return FeedEditScreen(
          feedData: feedData!,
          contentIdx: contentIdx!,
        );
      },
    );
  }
}

class CommentRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'comment/:contentIdx/:oldMemberUuid',
      name: 'comment/:contentIdx/:oldMemberUuid',
      builder: (BuildContext context, GoRouterState state) {
        final contentIdx = state.pathParameters['contentIdx']!;
        final oldMemberUuid = state.pathParameters['oldMemberUuid']!;

        final extraData = state.extra;
        int? commentFocusIndex;
        if (extraData != null) {
          Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
          if (extraMap.keys.contains('focusIndex')) {
            commentFocusIndex = extraMap['focusIndex'];
          }
        }

        return CommentDetailScreen(
          contentsIdx: int.parse(contentIdx),
          commentFocusIndex: commentFocusIndex,
          oldMemberUuid: oldMemberUuid,
        );
      },
    );
  }
}

class ReportRoute extends GoRouteData {
  final Ref ref;

  ReportRoute({
    required this.ref,
  });

  GoRoute createRoute() {
    return GoRoute(
      path: 'report/:isComment/:contentIdx',
      name: 'report/:isComment/:contentIdx',
      builder: (BuildContext context, GoRouterState state) {
        final isComment = state.pathParameters['isComment']!;
        final contentIdx = state.pathParameters['contentIdx']!;
        return ReportScreen(
          isComment: bool.parse(isComment),
          contentIdx: int.parse(contentIdx),
          onTapReport: () {
            onTapReport(
              context: context,
              ref: ref,
              contentIdx: int.parse(contentIdx),
              reportType: bool.parse(isComment),
            );
          },
        );
      },
    );
  }
}

class FeedUnknownRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'feedUnknown',
      name: 'feedUnknown',
      builder: (BuildContext context, GoRouterState state) {
        return const FeedNotFoundScreen();
      },
    );
  }
}

class NotFollowRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'notFollow',
      name: 'notFollow',
      builder: (BuildContext context, GoRouterState state) {
        String nick = '';
        String memberUuid = '';
        if (state.extra != null) {
          Map<String, dynamic> extraMap = {};
          extraMap = state.extra! as Map<String, dynamic>;

          if (extraMap.containsKey('memberUuid')) {
            memberUuid = extraMap['memberUuid'];
          }

          if (extraMap.containsKey('nick')) {
            nick = extraMap['nick'];
          }
        }

        return FeedNotFollowScreen(
          nick: nick,
          memberUuid: memberUuid,
        );
      },
    );
  }
}

class SelectImageRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'selectImage',
      name: 'selectImage',
      builder: (BuildContext context, GoRouterState state) {
        Key? key;
        AssetPickerBuilderDelegate<AssetEntity, AssetPathEntity>? assetPickerBuilderDelegate;
        if (state.extra != null) {
          Map<dynamic, dynamic> extraMap = {};
          extraMap = state.extra! as Map<String, dynamic>;

          if (extraMap.containsKey('key')) {
            key = extraMap['key'];
          }

          if (extraMap.containsKey('assetPickerBuilderDelegate')) {
            assetPickerBuilderDelegate = extraMap['assetPickerBuilderDelegate'];
          }
        }
        return AssetPicker<AssetEntity, AssetPathEntity>(
          key: key,
          builder: assetPickerBuilderDelegate!,
        );
      },
    );
  }
}
