import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';

class LoadingAnimationWidget extends StatelessWidget {
  const LoadingAnimationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: kWhiteColor,
        child: Lottie.asset(
          'assets/lottie/icon_loading.json',
          fit: BoxFit.fill,
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
