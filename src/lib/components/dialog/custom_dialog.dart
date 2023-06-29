import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class CustomDialog extends StatelessWidget {
  final Widget content;
  final VoidCallback? confirmTap;
  final VoidCallback? cancelTap;
  final Widget confirmWidget;

  const CustomDialog({
    Key? key,
    required this.content,
    required this.confirmTap,
    required this.cancelTap,
    required this.confirmWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 40.w,
      ),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            content,
            Container(
              height: 54.h,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kNeutralColor300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20)),
                      onTap: cancelTap,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(width: 1.0, color: kNeutralColor300),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "취소",
                            style: kButton14MediumStyle.copyWith(
                                color: kTextSubTitleColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20)),
                      onTap: confirmTap,
                      child: Center(child: confirmWidget),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      content: null,
      actions: <Widget>[],
    );
  }
}
