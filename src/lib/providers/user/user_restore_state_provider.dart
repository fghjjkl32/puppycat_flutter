import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_restore_state_provider.g.dart';


@riverpod
class UserRestoreState extends _$UserRestoreState {
  @override
  bool build() {
    return false;
  }

  void restoreAccount(String simpleId) async {
    state = await ref.read(userInfoRepositoryProvider).restoreAccount(simpleId);
  }
}



