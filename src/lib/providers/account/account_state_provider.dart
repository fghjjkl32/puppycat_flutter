
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/repositories/account/account_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_state_provider.g.dart';

// final accountRestoreProvider = StateProvider.family<Future<bool>, (String, String)>((ref, restoreInfo) {
//   return ref.read(accountRepositoryProvider).restoreAccount(restoreInfo.$1, restoreInfo.$2);
// });

// @Riverpod(keepAlive: true
@riverpod
class AccountRestoreState extends _$AccountRestoreState {
  @override
  bool build() {
    return false;
  }

  void restoreAccount(String memberIdx, String simpleId) async {
    state = await ref.read(accountRepositoryProvider).restoreAccount(memberIdx, simpleId);
  }
}


// @Riverpod(keepAlive: true)
// class AccountState extends _$AccountState {
//   @override
//   bool build() {
//     return false;
//   }
//
//   void restoreAccount(String memberIdx, String simpleId) async {
//     var result = await ref.read(accountRepositoryProvider).restoreAccount(memberIdx, simpleId);
//   }
// }
