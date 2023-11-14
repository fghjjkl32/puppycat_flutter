import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/walk_result/walk_result_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final walkResultStateProvider = StateNotifierProvider<WalkResultStateNotifier, WalkResultListModel>((ref) {
  return WalkResultStateNotifier(ref);
});

class WalkResultStateNotifier extends StateNotifier<WalkResultListModel> {
  WalkResultStateNotifier(this.ref) : super(const WalkResultListModel(list: []));

  final Ref ref;

  Future<void> getWalkResult({
    required String searchStartDate,
    required String searchEndDate,
  }) async {
    WalkResultResponseModel lists = await WalkResultRepository(dio: ref.read(dioProvider)).getWalkResult(
      memberUuid: ref.read(userInfoProvider).userModel!.uuid,
      together: 0,
      searchStartDate: searchStartDate,
      searchEndDate: searchEndDate,
    );

    if (lists == null) {
      state = state.copyWith(
        isLoading: false,
        totalCalorie: 0,
        totalWalkTime: "00:00:00",
        totalDistance: 0,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.data.list,
      totalCalorie: lists.data.totalCalorie,
      totalWalkTime: lists.data.totalWalkTime,
      totalDistance: lists.data.totalDistance,
    );
  }

  Future<void> getWalkResultForMap() async {
    WalkResultResponseModel lists = await WalkResultRepository(dio: ref.read(dioProvider)).getWalkResultForMap(
      memberUuid: ref.read(userInfoProvider).userModel!.uuid,
      together: 0,
    );

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.data.list,
      totalCalorie: lists.data.totalCalorie,
      totalWalkTime: lists.data.totalWalkTime,
      totalDistance: lists.data.totalDistance,
    );
  }
}
