import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/repositories/policy/policy_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'policy_state_provider.g.dart';

//
// final policyListProvider = FutureProvider.autoDispose<List<PolicyItemModel>>((ref) async {
//   List<PolicyItemModel> policies = await ref.watch(policyRepositoryProvider).getPolicies();
//   // ref.read(policyStateProvider.notifier).state = policies;
//   return policies;
// });

final policyAllAgreeStateProvider = StateProvider<bool>((ref) => false);

final policyAgreeStateProvider = StateProvider<bool>((ref) => false);

// @Riverpod(keepAlive: true)
@riverpod
class PolicyState extends _$PolicyState {
  @override
  List<PolicyItemModel> build() {
    return [];
  }

  void getPolicies() async {
    final PolicyRepository policyRepository = PolicyRepository();
    try {
      var result = await policyRepository.getPolicies();
      state = result;
    } catch (e) {
      print('get Policy Error');
      state = [];
    }
  }

  void toggle(int idx) {
    List<PolicyItemModel> policies = state;
    policies = policies.map((e) {
      if (e.idx == idx) {
        return e.copyWith(isAgreed: !e.isAgreed);
      }
      return e;
    }).toList();

    _checkAllAgreed(policies);
    _checkEssentialAgreed(policies);
    state = policies;
  }

  void _checkAllAgreed(List<PolicyItemModel> policies) {
    bool isAllAgreed = policies.any((element) => element.isAgreed == false);
    _setAllAgreed(!isAllAgreed);
  }

  void _setAllAgreed(bool isAll) {
    if (isAll) {
      ref.read(policyAllAgreeStateProvider.notifier).state = true;
    } else {
      ref.read(policyAllAgreeStateProvider.notifier).state = false;
    }
  }

  void _checkEssentialAgreed(List<PolicyItemModel> policies) {
    bool isEssentialAgreed = !policies.any((element) => element.required == 'Y' && element.isAgreed == false);
    _setEssentialAgreed(isEssentialAgreed);
  }

  void _setEssentialAgreed(bool isEssentialAgreed) {
    if (isEssentialAgreed) {
      ref.read(policyAgreeStateProvider.notifier).state = true;
    } else {
      ref.read(policyAgreeStateProvider.notifier).state = false;
    }
  }

  void toggleAll(bool isAgreed) {
    List<PolicyItemModel> policies = state;
    state = policies.map((e) => e.copyWith(isAgreed: isAgreed)).toList();
    _setAllAgreed(isAgreed);
    _setEssentialAgreed(isAgreed);
  }
}
