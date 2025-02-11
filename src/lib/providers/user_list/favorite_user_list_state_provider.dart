import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/user_list/user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/user_list/user_list_repository.dart';
import 'package:riverpod/riverpod.dart';

final favoriteUserListStateProvider = StateNotifierProvider<FavoriteUserListStateNotifier, UserListDataListModel>((ref) {
  return FavoriteUserListStateNotifier(ref);
});

class FavoriteUserListStateNotifier extends StateNotifier<UserListDataListModel> {
  FavoriteUserListStateNotifier(this.ref) : super(const UserListDataListModel());

  final Ref ref;

  getInitUserList() async {
    try {
      final lists = await UserListRepository(dio: ref.read(dioProvider)).getFavoriteUserList();

      if (lists == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        memberList: lists.memberList,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('getInitUserList error $e');
    }
  }
}
