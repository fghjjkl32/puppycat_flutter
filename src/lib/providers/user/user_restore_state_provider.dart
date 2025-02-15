import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_restore_state_provider.g.dart';

@riverpod
class UserRestoreState extends _$UserRestoreState {
  @override
  bool build() {
    return false;
  }

  Future<bool> restoreAccount() async {
    final loginInfo = ref.read(signUpUserInfoProvider);
    state = await ref.read(userInfoRepositoryProvider(ref.read(dioProvider))).restoreAccount(loginInfo?.simpleId ?? '');
    return state;
  }
}
