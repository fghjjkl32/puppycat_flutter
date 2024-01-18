import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class CustomDialog extends StatelessWidget {
  final Widget content;
  final VoidCallback? confirmTap;
  final VoidCallback? cancelTap;
  final Widget confirmWidget;
  final Widget? cancelWidget;

  const CustomDialog({
    Key? key,
    required this.content,
    required this.confirmTap,
    this.cancelTap,
    required this.confirmWidget,
    this.cancelWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 40,
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
              height: 54,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  cancelWidget != null
                      ? Expanded(
                          child: InkWell(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                            onTap: cancelTap,
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
                                ),
                              ),
                              child: Center(child: cancelWidget),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: cancelTap != null,
                          child: Expanded(
                            child: InkWell(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                              onTap: cancelTap,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(width: 1.0, color: kPreviousNeutralColor300),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "취소",
                                    style: kButton14MediumStyle.copyWith(color: kPreviousTextSubTitleColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
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
