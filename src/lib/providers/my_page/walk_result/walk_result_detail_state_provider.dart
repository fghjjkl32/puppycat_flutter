import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/walk_result/walk_result_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final walkResultDetailStateProvider = StateNotifierProvider<WalkResultDetailStateNotifier, WalkResultDetailListModel>((ref) {
  return WalkResultDetailStateNotifier(ref);
});

class WalkResultDetailStateNotifier extends StateNotifier<WalkResultDetailListModel> {
  WalkResultDetailStateNotifier(this.ref) : super(const WalkResultDetailListModel(data: []));

  final Ref ref;

  Future<void> getWalkResultDetail({
    required String walkUuid,
  }) async {
    WalkResultDetailResponseModel lists = await WalkResultRepository(dio: ref.read(dioProvider)).getWalkResultDetail(
      memberUuid: ref.read(userInfoProvider).userModel!.uuid,
      walkUuid: walkUuid,
    );

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      data: lists.data.data,
    );
  }

  Future<ResponseModel> putWalkResult({
    required Map<String, dynamic> formDataMap,
  }) async {
    final result = await WalkResultRepository(dio: ref.read(dioProvider)).putWalkResult(
      formDataMap: formDataMap,
    );

    return result;
  }
}
