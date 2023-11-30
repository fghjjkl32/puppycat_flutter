import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

final policyCheckProvider = StateProvider.autoDispose<bool>((ref) => false);

class PolicyCheckBoxWidget extends ConsumerWidget {
  final int idx;
  final bool isEssential;
  final String title;
  final String detail;
  final ValueChanged<bool>? onChanged;
  final Function? onViewDetail;
  final bool isAgreed;

  final int menuIdx;

  final String menuName;

  const PolicyCheckBoxWidget({
    Key? key,
    required this.idx,
    required this.isEssential,
    required this.title,
    required this.detail,
    required this.menuIdx,
    required this.menuName,
    this.onChanged,
    this.onViewDetail,
    this.isAgreed = false,
  }) : super(key: key);

  // final bool isChecked = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Theme(
        //   data: Theme.of(context).copyWith(
        //     unselectedWidgetColor:  Colors.transparent,
        //     disabledColor: Colors.transparent,
        //   ),
        //   child: Checkbox(
        //     value: isAgreed,
        //     onChanged: (value) {
        //       if (onChanged != null) {
        //         onChanged!(value!);
        //       }
        //     },
        //     side: const BorderSide(color: Colors.transparent),
        //     checkColor: isAgreed ? kSignUpPrimaryColor: Colors.red,
        //     activeColor: Colors.transparent,
        //     // fillColor: Colors.transparent,
        //   ),
        // ),
        IconButton(
          onPressed: () {
            if (onChanged != null) {
              onChanged!(!isAgreed);
            }
          },
          icon: Icon(
            Icons.check,
            color: isAgreed ? kPrimaryColor : kNeutralColor400,
          ),
          splashRadius: 1,
        ),
        Text(
          '[${isEssential ? '회원가입.필수'.tr() : '회원가입.선택'.tr()}] $title',
          style: kBody13RegularStyle.copyWith(color: kTextSubTitleColor),
        ),
        const Spacer(),
        Visibility(
          visible: idx != 0,
          child: TextButton(
            onPressed: () {
              Map<String, dynamic> extraMap = {
                'dateList': null,
                'idx': menuIdx,
                'menuName': menuName,
              };

              context.push("/home/myPage/setting/policy", extra: extraMap);
            },
            child: Text(
              '회원가입.보기'.tr(),
              style: kBody11SemiBoldStyle.copyWith(color: kTextBodyColor),
            ),
          ),
        ),
      ],
    );
  }
}
