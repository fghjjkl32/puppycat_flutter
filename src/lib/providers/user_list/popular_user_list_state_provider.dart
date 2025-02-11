import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/user_list/popular_user_list/popular_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/user_list/user_list_repository.dart';
import 'package:riverpod/riverpod.dart';

final popularUserListStateProvider = StateNotifierProvider<PopularUserListStateNotifier, PopularUserListDataListModel>((ref) {
  return PopularUserListStateNotifier(ref);
});

class PopularUserListStateNotifier extends StateNotifier<PopularUserListDataListModel> {
  PopularUserListStateNotifier(this.ref) : super(const PopularUserListDataListModel());

  final Ref ref;

  getInitUserList() async {
    try {
      final lists = await UserListRepository(dio: ref.read(dioProvider)).getPopularUserList();

      if (lists == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        list: lists.list,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('popular getInitUserList error $e');
    }
  }
}
