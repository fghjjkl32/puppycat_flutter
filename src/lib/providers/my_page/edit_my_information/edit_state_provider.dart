import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/edit_my_information/edit_my_information_state.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/authentication/auth_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_state_provider.g.dart';

@Riverpod(keepAlive: true)
class EditState extends _$EditState {
  @override
  EditMyInformationState build() {
    return EditMyInformationState(
      authModel: null,
      userInfoModel: ref.read(userInfoProvider),
    );
  }

  void saveAuthModel() {
    state = state.copyWith(authModel: ref.read(authModelProvider.notifier).state);
  }

  void resetState() {
    state = state.copyWith(
      authModel: null,
      userInfoModel: ref.read(userInfoProvider),
    );

    ref.watch(nickNameProvider.notifier).state = NickNameStatus.none;
  }

  Future<ResponseModel> putMyInfo({
    required UserModel userInfoModel,
    required XFile? file,
    required String beforeNick,
  }) async {
    final result = await ref.read(userInfoRepositoryProvider(ref.read(dioProvider))).updateMyInfo(userInfoModel, file, beforeNick);

    return result;
  }
}
