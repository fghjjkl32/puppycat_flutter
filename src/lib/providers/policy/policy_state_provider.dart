import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
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
final policyMarketingStateProvider = StateProvider<bool>((ref) => false);

// @Riverpod(keepAlive: true)
@riverpod
class PolicyState extends _$PolicyState {
  @override
  List<PolicyItemModel> build() {
    return [];
  }

  Future getPolicies() async {
    try {
      final PolicyRepository policyRepository = PolicyRepository(dio: ref.read(dioProvider));
      List<PolicyItemModel> result = [];

      PolicyItemModel firstPolicy = PolicyItemModel(idx: 0, required: 'Y', title: '만 14세 이상');
      result.insert(0, firstPolicy);

      final policies = await policyRepository.getPolicies();
      result.addAll(policies);

      state = result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = [];
    } catch (e) {
      print('get Policy Error $e');
      state = [];
    }
  }

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
    _setAllAgreed(isAgreed);
    _setEssentialAgreed(isAgreed);
    state = policies.map((e) => e.copyWith(isAgreed: isAgreed)).toList();
  }

  List<PolicyItemModel> getSelectPolicy() {
    List<PolicyItemModel> policies = state;
    // List<String> result = policies.where((e) {
    //   if(e.required == 'N' && e.isAgreed) {
    //     return e.idx.toString();
    //   }
    // }).toList();

    // List<String> result = policies.where((element) => element.required == 'N').map((e) => e.idx.toString()).toList();
    List<PolicyItemModel> result = policies.where((element) => element.required == 'N').toList();
    return result;
  }

  void policyStateReset() {
    ref.read(policyAllAgreeStateProvider.notifier).state = false;
    ref.read(policyAgreeStateProvider.notifier).state = false;
    ref.read(policyMarketingStateProvider.notifier).state = false;
  }
}
