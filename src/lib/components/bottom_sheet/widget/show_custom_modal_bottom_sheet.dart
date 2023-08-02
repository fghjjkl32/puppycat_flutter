import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/components/bottom_sheet/widget/custom_modal_bottom_sheet_widget.dart';

void showCustomModalBottomSheet(
    {required BuildContext context, required Widget widget}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext modalContext) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom),
        child: SingleChildScrollView(
          child: CustomModalBottomSheet(
            widget: widget,
            context: modalContext,
          ),
        ),
      );
    },
  );
}
