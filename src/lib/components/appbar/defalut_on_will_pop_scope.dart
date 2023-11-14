import 'dart:io';

import 'package:flutter/material.dart';

class DefaultOnWillPopScope extends StatelessWidget {
  const DefaultOnWillPopScope({
    required this.child,
    this.onWillPop,
    super.key,
  });

  final Widget child;
  final WillPopCallback? onWillPop;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Listener(
            onPointerMove: (event) {
              if (event.delta.dx > 10 && event.delta.dy >= 0 && event.delta.dy <= 10) {
                Future.delayed(const Duration(milliseconds: 500), () async {
                  onWillPop;
                  await Future.value(true);
                });
              }
            },
            child: child,
          )
        : WillPopScope(
            onWillPop: onWillPop,
            child: child,
          );
  }
}
