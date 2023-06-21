import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';

// final policyCheckProvider = StateProvider.autoDispose<bool>((ref) => false);

class PolicyCheckBoxWidget extends ConsumerWidget {
  final int idx;
  final bool isEssential;
  final String title;
  final String detail;
  final ValueChanged<bool>? onChanged;
  final Function? onViewDetail;
  final bool isAgreed;

  const PolicyCheckBoxWidget({
    Key? key,
    required this.idx,
    required this.isEssential,
    required this.title,
    required this.detail,
    this.onChanged,
    this.onViewDetail,
    this.isAgreed = false,
  }) : super(key: key);

  // final bool isChecked = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          value: isAgreed,
          onChanged: (value) {
            ref.read(policyStateProvider.notifier).toggle(idx);
            print('value $value');
            if(onChanged != null) {
              onChanged!(value!);
            }
          },
        ),
        Text(title),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('보기'),
        ),
      ],
    );
  }
}
