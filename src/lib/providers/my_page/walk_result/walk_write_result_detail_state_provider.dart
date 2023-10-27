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
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/walk_result/walk_result_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final walkWriteResultDetailStateProvider = StateNotifierProvider<WalkWriteResultDetailStateNotifier, WalkWriteResultDetailListModel>((ref) {
  return WalkWriteResultDetailStateNotifier(ref);
});

class WalkWriteResultDetailStateNotifier extends StateNotifier<WalkWriteResultDetailListModel> {
  WalkWriteResultDetailStateNotifier(this.ref) : super(const WalkWriteResultDetailListModel(list: []));

  final Ref ref;

  Future<void> getWalkWriteResultDetail({
    required String walkUuid,
  }) async {
    WalkWriteResultDetailResponseModel lists = await WalkResultRepository(dio: ref.read(dioProvider)).getWalkWriteResultDetail(
      memberUuid: ref.read(userInfoProvider).userModel!.uuid,
      walkUuid: walkUuid,
    );

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.data.list,
    );
  }

  Future<ResponseModel> postWalkResult({
    required Map<String, dynamic> formDataMap,
  }) async {
    final result = await WalkResultRepository(dio: ref.read(dioProvider)).postWalkResult(
      formDataMap: formDataMap,
    );

    return result;
  }
}
