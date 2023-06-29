import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/components/toast/toast.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';

class MyPageSettingBlockUserNotifier extends StateNotifier<String> {
  MyPageSettingBlockUserNotifier() : super('');

  void onTextChanged(String newText) {
    state = newText;
    searchUser(newText);
  }

  List<String> _searchResult = [];
  List<String> get searchResult => _searchResult;

  void searchUser(String query) async {
    _searchResult = [
      '말티푸달콩',
      '테테_te',
      '아지다멍',
      'baejji',
      'bichon_딩동',
      '로로님',
      'mygumi',
      'live는리브',
      '꼬동모모'
    ].where((user) => user.contains(query)).toList();
  }
}

final myPageSettingBlockUserProvider =
    StateNotifierProvider<MyPageSettingBlockUserNotifier, String>(
  (ref) => MyPageSettingBlockUserNotifier(),
);
