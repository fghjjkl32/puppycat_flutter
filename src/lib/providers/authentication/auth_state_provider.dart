import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/authentication/auth_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/authentication/bearer_token_auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

final passUrlProvider = StateProvider<String>((ref) => 'about:blank');
final authModelProvider = StateProvider<SignUpAuthModel?>((ref) => null);
// final tossTxIdProvider = StateProvider<String>((ref) => "");
// final tossAccessTokenProvider = StateProvider<String>((ref) => "");

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  late final AuthRepository _authRepository = AuthRepository(dio: ref.read(dioProvider));

  @override
  bool build() {
    return false;
  }

  void getPassAuthUrl({required bool isEditProfile}) async {
    try {
      String passUrl = await _authRepository.getPassAuthUrl(isEditProfile: isEditProfile);
      ref.read(passUrlProvider.notifier).state = passUrl;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      ref.read(passUrlProvider.notifier).state = 'about:blank';
    } catch (e) {
      ref.read(passUrlProvider.notifier).state = 'about:blank';
    }
  }

  void setPassAuthData(String data) {
    Map<String, dynamic> authMap = {};
    if (data == null) {
      ref.read(authModelProvider.notifier).state = null;
      state = false;
      return;
    } else if (data is Map) {
      authMap = data as Map<String, dynamic>;
    } else if (data is String) {
      authMap = jsonDecode(data);
    }

    SignUpAuthModel signUpAuthModel = _parseAuthModel(authMap);

    if (signUpAuthModel.di != null && signUpAuthModel.di!.isNotEmpty) {
      ref.read(authModelProvider.notifier).state = signUpAuthModel;
      ref.read(editStateProvider.notifier).saveAuthModel();
      state = true;
    } else {
      ref.read(authModelProvider.notifier).state = null;
      state = false;
    }
  }

  SignUpAuthModel _parseAuthModel(Map<String, dynamic> jsonData) {
    SignUpAuthModel signUpAuthModel = SignUpAuthModel();

    jsonData.forEach((key, value) {
      switch (key) {
        case 'ci':
        case 'CI':
          signUpAuthModel = signUpAuthModel.copyWith(ci: value);
        case 'di':
        case 'DI':
          signUpAuthModel = signUpAuthModel.copyWith(di: value);
        case 'RSLT_BIRTHDAY':
          signUpAuthModel = signUpAuthModel.copyWith(birth: value);
        case 'RSLT_SEX_CD':
          signUpAuthModel = signUpAuthModel.copyWith(gender: value);
        case 'RSLT_NAME':
          signUpAuthModel = signUpAuthModel.copyWith(name: value);
        case 'TEL_NO':
          signUpAuthModel = signUpAuthModel.copyWith(phone: value);
      }
    });

    return signUpAuthModel;
  }

// Future<String> getTossAuthUrl(String txId) async {
//   final authRepository = BearerTokenAuthRepository(dio: ref.read(dioProvider));
//   try {
//     // String txId = await authRepository.getTossAuthUrl();
//
//     // ref.read(tossAccessTokenProvider.notifier).state = txId;
//
//     // ref.read(tossTxIdProvider.notifier).state = txId;
//
//     String url = await authRepository.getTossTransactionsUrl(txId);
//
//     return url;
//   } catch (e) {
//     print(e);
//     return "";
//   }
// }
//
// Future<String> getTossUserResult(sessionKey) async {
//   final authRepository = BearerTokenAuthRepository(dio: ref.read(dioProvider));
//   try {
//     String txId = await authRepository.getTossAuthUrl();
//
//     ref.read(tossAccessTokenProvider.notifier).state = txId;
//
//     ref.read(tossTxIdProvider.notifier).state = txId;
//
//     String url = await authRepository.getTossUserResult(sessionKey: '', accessToken: ref.read(tossAccessTokenProvider.notifier).state, txId: ref.read(tossAccessTokenProvider.notifier).state);
//
//     return url;
//   } catch (e) {
//     print(e);
//     return "";
//   }
// }
}
