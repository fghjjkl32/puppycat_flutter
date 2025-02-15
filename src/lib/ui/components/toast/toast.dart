import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

enum ToastType { red, purple, grey, white }

void toast({
  required BuildContext context,
  required String text,
  String? secondText,
  String? buttonText,
  VoidCallback? buttonOnTap,
  Widget? toastWidget,
  required ToastType type,
  Duration toastDuration = const Duration(milliseconds: 3000),
}) {
  final fToast = FToast();
  fToast.init(context);
  fToast.removeCustomToast();

  Widget iconImage = Container();
  Color color = kPreviousPrimaryColor.withOpacity(0.8);

  if (ToastType.red == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1-2.png',
    );
    color = kPreviousErrorColor.withOpacity(0.8);
  } else if (ToastType.purple == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1.png',
    );
    color = kPreviousPrimaryColor.withOpacity(0.8);
  } else if (ToastType.grey == type) {
    iconImage = Image.asset(
      'assets/image/toast/icon/Layer_1-1.png',
    );
    color = const Color(0xff98a0b0).withOpacity(0.8);
  } else if (ToastType.white == type) {
    color = const Color(0xffffffff).withOpacity(0.8);
  }

  Widget toast = Container(
    width: 335,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: color,
    ),
    child: toastWidget ??
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: kPreviousNeutralColor100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: iconImage,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: kBody13BoldStyle.copyWith(color: kPreviousNeutralColor100),
                    ),
                    secondText == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              secondText,
                              style: kBody11RegularStyle.copyWith(color: kPreviousNeutralColor100),
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
                            style: kBody11SemiBoldStyle.copyWith(color: kPreviousNeutralColor100),
                          ),
                          const Icon(
                            Puppycat_social.icon_take_back,
                            color: kPreviousNeutralColor100,
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
    toastDuration: toastDuration,
    positionedToastBuilder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            child: Container(
              child: child,
            ),
          ),
        ],
      );
    },
  );
}
