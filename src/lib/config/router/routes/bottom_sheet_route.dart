import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/feed_block_sheet_item.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/sheets/withDrawalPending_sheet_item.dart';
import 'package:pet_mobile_social_flutter/ui/components/bottom_sheet/widget/custom_modal_bottom_sheet_widget.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/force_update_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/recommended_update_bottom_sheet.dart';
import 'package:pet_mobile_social_flutter/ui/components/route_page/bottom_sheet_page.dart';

class BottomSheetRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: '/bottomSheet',
      name: 'bottomSheet',
      builder: (BuildContext context, GoRouterState state) {
        return Container();
      },
      routes: [
        ForceUpdateBottomSheetRoute().createRoute(),
        RecommendBottomSheetRoute().createRoute(),
        ErrorBottomSheetRoute().createRoute(),
        ErrorBlockBottomSheetRoute().createRoute(),
      ],
    );
  }
}

class ForceUpdateBottomSheetRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'forceUpdateBottomSheet',
      name: 'forceUpdateBottomSheet',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return BottomSheetPage(
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: CustomModalBottomSheet(
                    isTopWidget: false,
                    widget: ForceUpdateBottomSheet(),
                    context: context,
                  ),
                ),
              ),
            );
          },
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
        );
      },
    );
  }
}

class RecommendBottomSheetRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'recommendUpdateBottomSheet',
      name: 'recommendUpdateBottomSheet',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return BottomSheetPage(
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: CustomModalBottomSheet(
                    isTopWidget: false,
                    widget: RecommendedUpdateBottomSheet(),
                    context: context,
                  ),
                ),
              ),
            );
          },
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
        );
      },
    );
  }
}

class ErrorBottomSheetRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'errorBottomSheet',
      name: 'errorBottomSheet',
      pageBuilder: (BuildContext context, GoRouterState state) {
        String errorCode = 'unknown';
        if (state.extra != null) {
          if (state.extra is String) {
            errorCode = state.extra.toString();
          }
        }

        return BottomSheetPage(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: CustomModalBottomSheet(
                  widget: WithDrawalPendingSheetItem(),
                  context: context,
                ),
              ),
            );
          },
          isScrollControlled: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
        );
      },
    );
  }
}

class ErrorBlockBottomSheetRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'errorBlockBottomSheet',
      name: 'errorBlockBottomSheet',
      pageBuilder: (BuildContext context, GoRouterState state) {
        String name = 'unknown';
        int memberIdx = 0;

        return BottomSheetPage(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: CustomModalBottomSheet(
                  widget: FeedBlockSheetItem(),
                  context: context,
                ),
              ),
            );
          },
          isScrollControlled: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
        );
      },
    );
  }
}
