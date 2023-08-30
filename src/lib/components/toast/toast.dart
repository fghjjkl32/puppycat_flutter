import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

enum ToastType { red, purple, grey }

void toast({
  required BuildContext context,
  required String text,
  String? secondText,
  String? buttonText,
  VoidCallback? buttonOnTap,
  required ToastType type,
  int milliseconds = 3000,
}) {
  final fToast = FToast();
  fToast.init(context);
  fToast.removeCustomToast();

  Widget iconImage = Container();
  Color color = kPrimaryColor.withOpacity(0.8);

  if (ToastType.red == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1-2.png',
    );
    color = kBadgeColor.withOpacity(0.8);
  } else if (ToastType.purple == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1.png',
    );
    color = kPrimaryColor.withOpacity(0.8);
  } else if (ToastType.grey == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1-1.png',
    );
    color = const Color(0xff98a0b0).withOpacity(0.8);
  }

  Widget toast = Container(
    width: 335.w,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: color,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: kNeutralColor100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: iconImage,
              ),
            ),
            SizedBox(
              width: 14.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: kBody13BoldStyle.copyWith(color: kNeutralColor100),
                ),
                secondText == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          secondText,
                          style: kBody11RegularStyle.copyWith(
                              color: kNeutralColor100),
                        ),
                      ),
              ],
            ),
          ],
        ),
        buttonText == null
            ? Container()
            : InkWell(
                onTap: buttonOnTap,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      Text(
                        buttonText,
                        style: kBody11SemiBoldStyle.copyWith(
                            color: kNeutralColor100),
                      ),
                      const Icon(
                        Puppycat_social.icon_take_back,
                        color: kNeutralColor100,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(milliseconds: milliseconds),
    positionedToastBuilder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
            child: Container(
              child: child,
            ),
          ),
        ],
      );
    },
  );
}
