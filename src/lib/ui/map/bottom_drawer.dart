import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bottom_drawer/flutter_bottom_drawer.dart';

class ExampleAppBottomDrawer {
  final BuildContext context;
  final Function(double height) onDrawerHeightChanged;
  final Function() rebuild;
  final void Function()? onPageDispose;
  final Widget widget;

  ExampleAppBottomDrawer({
    required this.context,
    required this.onDrawerHeightChanged,
    required this.rebuild,
    required this.widget,
    this.onPageDispose,
  });

  late DrawerMoveController drawerController;
  late DrawerState drawerState;
  late Function(Function()) drawerSetState;
  final scrollController = ScrollController();

  BottomDrawer get bottomDrawer => BottomDrawer(
      height: 212,
      expandedHeight: 212,
      handleSectionHeight: 0,
      shadows: const [
            BoxShadow(
              color: Colors.white,
            ),
      ],
      onReady: (controller) => drawerController = controller,
      onStateChanged: (state) => drawerState = state,
      onHeightChanged: onDrawerHeightChanged,
      builder: (state, setState, context) {
        drawerSetState = setState;
        return widget;
      });
}
