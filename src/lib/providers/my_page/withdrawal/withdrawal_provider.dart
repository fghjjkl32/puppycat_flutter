import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/withdrawal/withdrawal_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum WithdrawalStatus {
  none,
  success,
  failure,
}

final withdrawalCodeProvider = StateProvider<int>((ref) => 0);

final withdrawalReasonProvider = StateProvider<String?>((ref) => null);

final withdrawalStateProvider = StateNotifierProvider<WithdrawalStateNotifier, SelectButtonListModel>((ref) {
  return WithdrawalStateNotifier(ref);
});

class WithdrawalStateNotifier extends StateNotifier<SelectButtonListModel> {
  WithdrawalStateNotifier(this.ref) : super(const SelectButtonListModel());

  final Ref ref;

  getWithdrawalReasonList() async {
    final lists = await WithdrawalRepository(dio: ref.read(dioProvider)).getWithdrawalReasonList();

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.data.list,
    );
  }

  Future<bool> withdrawalUser({required int idx, required int code, String? reason}) async {
    final withdrawalRepository = WithdrawalRepository(dio: ref.read(dioProvider));

    var result = await withdrawalRepository.withdrawalUser(
      idx: idx,
      code: code,
      reason: reason,
    );

    if (result == WithdrawalStatus.success) {
      // ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
      ref.read(userModelProvider.notifier).state = null;
      ref.read(userInfoProvider.notifier).state = UserInfoModel(
        userModel: null,
        chatUserModel: null,
      );

      ref.read(loginStateProvider.notifier).saveUserModel(null);

      return true;
    } else {
      return false;
    }
  }
}
