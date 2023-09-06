import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/edit_my_information/edit_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/authentication/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

final passUrlProvider = StateProvider<String>((ref) => 'about:blank');
final authModelProvider = StateProvider<SignUpAuthModel?>((ref) => null);

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  bool build() {
    return false;
  }

  void getPassAuthUrl() async {
    final authRepository = AuthRepository(dio: ref.read(dioProvider));
    try {
      String passUrl = await authRepository.getPassAuthUrl();
      // passUrl = "http://172.16.4.8:3037";
      ref.read(passUrlProvider.notifier).state = passUrl;
    } catch (e) {
      print(e);
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
}
