import 'dart:io';

import 'package:flutter/material.dart';

class DefaultOnWillPopScope extends StatelessWidget {
  DefaultOnWillPopScope({
    required this.child,
    this.onWillPop,
    super.key,
  });

  final Widget child;
  final WillPopCallback? onWillPop;

  final _isProcessing = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Listener(
            onPointerMove: (event) async {
              print("event.delta ${event.delta}");
              if (event.delta.dx > 10 && event.delta.dy >= 0 && event.delta.dy <= 10) {
                // 디바운스 메커니즘을 적용합니다.
                if (!_isProcessing.value) {
                  _isProcessing.value = true;
                  if (onWillPop != null) {
                    onWillPop!.call();
                  }
                  // 플래그를 재설정합니다.
                  _isProcessing.value = false;
                }
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
