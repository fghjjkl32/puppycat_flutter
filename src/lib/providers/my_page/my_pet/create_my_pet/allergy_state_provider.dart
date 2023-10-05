import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final allergyStateProvider = StateNotifierProvider<AllergyStateNotifier, ListModel>((ref) {
  return AllergyStateNotifier(ref);
});

class AllergyStateNotifier extends StateNotifier<ListModel> {
  AllergyStateNotifier(this.ref) : super(const ListModel(list: []));

  final Ref ref;

  getAllergyList() async {
    ListResponseModel lists = await CreateMyPetRepository(dio: ref.read(dioProvider)).getAllergyList(loginMemberIdx: ref.read(userInfoProvider).userModel!.idx);

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: false, list: lists.data.list);
  }
}
