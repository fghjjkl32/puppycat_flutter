import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/main/user_list/user_list_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod/riverpod.dart';

final popularUserListStateProvider = StateNotifierProvider<PopularUserListStateNotifier, PopularUserListDataListModel>((ref) {
  return PopularUserListStateNotifier(ref);
});

class PopularUserListStateNotifier extends StateNotifier<PopularUserListDataListModel> {
  PopularUserListStateNotifier(this.ref) : super(const PopularUserListDataListModel());

  final Ref ref;

  getInitUserList(
    loginMemberIdx,
  ) async {
    try {
      final lists = await UserListRepository(dio: ref.read(dioProvider)).getPopularUserList(loginMemberIdx: loginMemberIdx);

      if (lists == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        list: lists.data.list,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('popular getInitUserList error $e');
    }
  }
}
