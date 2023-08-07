import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/main/user_list/user_list_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final favoriteUserListStateProvider =
    StateNotifierProvider<FavoriteUserListStateNotifier, UserListDataListModel>(
        (ref) {
  return FavoriteUserListStateNotifier();
});

class FavoriteUserListStateNotifier
    extends StateNotifier<UserListDataListModel> {
  FavoriteUserListStateNotifier() : super(const UserListDataListModel());

  getInitUserList(
    loginMemberIdx,
  ) async {
    final lists = await UserListRepository()
        .getFavoriteUserList(loginMemberIdx: loginMemberIdx);

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      memberList: lists.data.memberList,
    );
  }
}
