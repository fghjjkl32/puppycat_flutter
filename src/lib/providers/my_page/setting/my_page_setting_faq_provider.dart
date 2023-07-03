import 'package:flutter_riverpod/flutter_riverpod.dart';

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
