import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class SelectButton extends StatelessWidget {
  final bool isDirectInput;
  final VoidCallback onPressed;
  final bool isSelected;
  final String title;
  final ValueSetter<String?>? onTextChanged;

  const SelectButton({
    super.key,
    required this.isDirectInput,
    required this.title,
    required this.onPressed,
    required this.isSelected,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      onTap: onPressed,
      child: Container(
        decoration: isSelected
            ? const BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: isSelected
                        ? kBody14BoldStyle.copyWith(color: kPrimaryColor)
                        : kBody14RegularStyle.copyWith(
                            color: kTextSubTitleColor),
                  ),
                  Row(
                    children: [
                      isDirectInput && isSelected
                          ? Padding(
                              padding: EdgeInsets.only(right: 8.0.w),
                              child: Text(
                                "최대 200자",
                                style: kBody11RegularStyle.copyWith(
                                    color: kTextBodyColor),
                              ),
                            )
                          : Container(),
                      Icon(
                        Icons.check,
                        color: isSelected ? kPrimaryColor : kNeutralColor400,
                      ),
                    ],
                  ),
                ],
              ),
              if (isDirectInput && isSelected)
                Padding(
                  padding: EdgeInsets.only(
                      top: 8.h, left: 4.w, right: 4.w, bottom: 4.h),
                  child: FormBuilderTextField(
                    onChanged: onTextChanged,
                    scrollPhysics: const ClampingScrollPhysics(),
                    maxLength: 200,
                    scrollPadding: EdgeInsets.only(bottom: 500.h),
                    maxLines: 6,
                    decoration: InputDecoration(
                      fillColor: kNeutralColor100,
                      border: InputBorder.none,
                      counterText: "",
                      hintText: '이유를 입력해주세요',
                      hintStyle:
                          kBody12RegularStyle.copyWith(color: kNeutralColor500),
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    name: 'isDirectInput',
                    style:
                        kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
