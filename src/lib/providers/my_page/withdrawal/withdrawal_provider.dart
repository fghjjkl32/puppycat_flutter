import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/withdrawal/withdrawal_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'withdrawal_provider.g.dart';

enum WithdrawalStatus {
  none,
  success,
  failure,
}

final withdrawalProvider =
    StateProvider<WithdrawalStatus>((ref) => WithdrawalStatus.none);

@Riverpod(keepAlive: true)
// @riverpod
class WithdrawalState extends _$WithdrawalState {
  @override
  WithdrawalStatus build() {
    return WithdrawalStatus.none;
  }

  Future<bool> withdrawalUser(
      {required int idx, required int code, String? reason}) async {
    final withdrawalRepository = WithdrawalRepository(dio: ref.read(dioProvider));

    var result = await withdrawalRepository.withdrawalUser(
      idx: idx,
      code: code,
      reason: reason,
    );

    if (result == WithdrawalStatus.success) {
      ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
      ref.read(userModelProvider.notifier).state = null;
      ref.read(loginStateProvider.notifier).saveUserModel(null);

      state = WithdrawalStatus.none;
      return true;
    } else {
      return false;
    }
  }
}
