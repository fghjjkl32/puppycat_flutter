import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/tag_contents/tag_contents_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:pet_mobile_social_flutter/services/my_page/user_information/user_information_service.dart';
import 'package:riverpod/riverpod.dart';

final userInformationStateProvider = StateNotifierProvider<
    UserInformationStateNotifier, UserInformationListModel>((ref) {
  return UserInformationStateNotifier();
});

class UserInformationStateNotifier
    extends StateNotifier<UserInformationListModel> {
  UserInformationStateNotifier() : super(const UserInformationListModel());

  getInitUserInformation([
    memberIdx,
  ]) async {
    final lists =
        await UserInformationRepository().getUserInformation(memberIdx);

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: false, list: lists.data.info);
  }

  Future<ResponseModel> postBlock({
    required memberIdx,
    required blockIdx,
  }) async {
    final result = await BlockRepository().postBlock(
      memberIdx: memberIdx,
      blockIdx: blockIdx,
    );

    return result;
  }
}
