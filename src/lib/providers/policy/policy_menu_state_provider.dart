import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_menu_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/policy/policy_repository.dart';

// part 'policy_menu_state_provider.g.dart';
//
// @riverpod
// class PolicyMenuState extends _$PolicyMenuState {
//   @override
//   List<PolicyMenuItemModel> build() {
//     return [];
//   }
//
//   Future<void> getPoliciesMenu() async {
//     try {
//       final PolicyRepository policyRepository = PolicyRepository(dio: ref.read(dioProvider));
//       List<PolicyMenuItemModel> result = await policyRepository.getPoliciesMenu();
//
//       print("result ${result}");
//       // state = result;
//       state = result;
//
//       print("state ${state}");
//     } on APIException catch (apiException) {
//       await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
//       state = [];
//     } catch (e) {
//       print('get PoliciesMenu Error');
//       state = [];
//     }
//   }
// }

final policyMenuStateProvider = StateNotifierProvider<PolicyMenuStateNotifier, List<PolicyMenuItemModel>>((ref) {
  return PolicyMenuStateNotifier(ref);
});

class PolicyMenuStateNotifier extends StateNotifier<List<PolicyMenuItemModel>> {
  PolicyMenuStateNotifier(this.ref) : super([]);

  final Ref ref;

  Future<void> getPoliciesMenu() async {
    try {
      final PolicyRepository policyRepository = PolicyRepository(dio: ref.read(dioProvider));
      List<PolicyMenuItemModel> result = await policyRepository.getPoliciesMenu();

      state = result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = [];
    } catch (e) {
      print('get PoliciesMenu Error');
      state = [];
    }
  }
}
