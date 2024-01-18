import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/policy/policy_repository.dart';
import 'package:riverpod/riverpod.dart';

// part 'policy_detail_state_provider.g.dart';
//
// @riverpod
// class PolicyDetailState extends _$PolicyDetailState {
//   @override
//   List<PolicyItemModel> build() {
//     return [];
//   }
//
//   void getPoliciesDetail(int type, String date) async {
//     try {
//       final PolicyRepository policyRepository = PolicyRepository(dio: ref.read(dioProvider));
//       List<PolicyItemModel> result = await policyRepository.getPoliciesDetail(type, date);
//
//       state = result;
//     } on APIException catch (apiException) {
//       await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
//       state = [];
//     } catch (e) {
//       print('get PoliciesDetail Error');
//       state = [];
//     }
//   }
// }

final policyDetailStateProvider = StateNotifierProvider<PolicyDetailStateNotifier, List<PolicyItemModel>>((ref) {
  return PolicyDetailStateNotifier(ref);
});

class PolicyDetailStateNotifier extends StateNotifier<List<PolicyItemModel>> {
  PolicyDetailStateNotifier(this.ref) : super([]);

  final Ref ref;

  void getPoliciesDetail(int type, String date) async {
    try {
      final PolicyRepository policyRepository = PolicyRepository(dio: ref.read(dioProvider));
      List<PolicyItemModel> result = await policyRepository.getPoliciesDetail(type, date);

      state = result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = [];
    } catch (e) {
      print('get PoliciesDetail Error');
      state = [];
    }
  }
}
