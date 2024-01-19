import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';

class LoadingAnimationWidget extends StatelessWidget {
  const LoadingAnimationWidget({
    required this.controller,
    required this.child,
    Key? key,
  }) : super(key: key);

  final IndicatorController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, _) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            if (!controller.isIdle)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Lottie.asset(
                  'assets/lottie/icon_loading.json',
                  fit: BoxFit.fill,
                  width: 80,
                  height: 80,
                ),
              ),
            Transform.translate(
              offset: Offset(
                0,
                80 * controller.value,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
