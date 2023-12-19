import 'package:flutter/material.dart';

class BottomSheetPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final CapturedThemes? capturedThemes;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final bool? showDragHandle;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;
  final bool useSafeArea;
  final String? barrierOnTapHint;
  final String? barrierLabel;

  const BottomSheetPage({
    super.key,
    required this.builder,
    this.capturedThemes,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    required this.isScrollControlled,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
        capturedThemes: capturedThemes,
        barrierLabel: barrierLabel,
        barrierOnTapHint: barrierOnTapHint,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        modalBarrierColor: modalBarrierColor,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        transitionAnimationController: transitionAnimationController,
        anchorPoint: anchorPoint,
        settings: this,
        useSafeArea: true,
        builder: builder,
        isScrollControlled: isScrollControlled,
      );
}
