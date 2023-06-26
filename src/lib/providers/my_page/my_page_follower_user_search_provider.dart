import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageFollowerUserSearchNotifier extends StateNotifier<String> {
  MyPageFollowerUserSearchNotifier() : super('');

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

final myPageFollowerUserSearchProvider =
    StateNotifierProvider<MyPageFollowerUserSearchNotifier, String>(
  (ref) => MyPageFollowerUserSearchNotifier(),
);
