import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';

class MyPageSettingFaqNotifier extends StateNotifier<String> {
  MyPageSettingFaqNotifier() : super('');

  void onTextChanged(String newText) {
    state = newText;
    searchUser(newText);
  }

  List<String> _searchResult = [];
  List<String> get searchResult => _searchResult;

  void searchUser(String query) async {
    _searchResult = [
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?',
      '프로필 설정은 어떻게 하나요?'
    ].where((user) => user.contains(query)).toList();
  }
}

final myPageSettingFaqProvider =
    StateNotifierProvider<MyPageSettingFaqNotifier, String>(
  (ref) => MyPageSettingFaqNotifier(),
);
