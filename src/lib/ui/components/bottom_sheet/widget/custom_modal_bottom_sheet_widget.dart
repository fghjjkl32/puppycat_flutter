import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    required this.widget,
    required this.context,
    this.isTopWidget = true,
    Key? key,
  }) : super(key: key);

  final Widget widget;
  final BuildContext context;

  final bool isTopWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        color: kPreviousNeutralColor100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isTopWidget
                ? Container(
                    width: 70,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: kPreviousNeutralColor200,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                    ),
                  )
                : Container(),
            widget
          ],
        ),
      ),
    );
  }
}
