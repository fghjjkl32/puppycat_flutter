import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class SelectButton extends StatelessWidget {
  final bool isDirectInput;
  final VoidCallback onPressed;
  final bool isSelected;
  final String title;
  final ValueSetter<String?>? onTextChanged;
  final TextEditingController textController;

  const SelectButton({
    super.key,
    required this.isDirectInput,
    required this.title,
    required this.onPressed,
    required this.isSelected,
    required this.textController,
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
                color: kPreviousPrimaryLightColor,
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
                    style: isSelected ? kBody14BoldStyle.copyWith(color: kPreviousPrimaryColor) : kBody14RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
                  ),
                  Row(
                    children: [
                      isDirectInput && isSelected
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "피드.최대 200자".tr(),
                                style: kBody11RegularStyle.copyWith(color: kPreviousTextBodyColor),
                              ),
                            )
                          : Container(),
                      Icon(
                        Puppycat_social.icon_check_single,
                        size: 28,
                        color: isSelected ? kPreviousPrimaryColor : kPreviousNeutralColor400,
                      ),
                    ],
                  ),
                ],
              ),
              if (isDirectInput && isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 4),
                  child: FormBuilderTextField(
                    controller: textController,
                    onChanged: onTextChanged,
                    scrollPhysics: const ClampingScrollPhysics(),
                    maxLength: 200,
                    scrollPadding: const EdgeInsets.only(bottom: 500),
                    maxLines: 6,
                    decoration: InputDecoration(
                      fillColor: kPreviousNeutralColor100,
                      border: InputBorder.none,
                      counterText: "",
                      hintText: '피드.이유를 입력해주세요'.tr(),
                      hintStyle: kBody14RegularStyle.copyWith(color: kTextTertiary),
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
                    style: kBody13RegularStyle.copyWith(color: kPreviousTextSubTitleColor),
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
