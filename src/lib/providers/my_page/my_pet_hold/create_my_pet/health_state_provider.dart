///NOTE
///2023.11.16.
///산책하기 보류로 전체 주석 처리
// import 'dart:math';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/list_response_model.dart';
// import 'package:pet_mobile_social_flutter/providers/chat/chat_favorite_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/search/search_repository.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// final healthStateProvider = StateNotifierProvider<HealthStateNotifier, ListModel>((ref) {
//   return HealthStateNotifier(ref);
// });
//
// class HealthStateNotifier extends StateNotifier<ListModel> {
//   HealthStateNotifier(this.ref) : super(const ListModel(list: []));
//
//   final Ref ref;
//
//   getHealthList() async {
//     ListResponseModel lists = await CreateMyPetRepository(dio: ref.read(dioProvider)).getHealthList(loginMemberIdx: ref.read(userInfoProvider).userModel!.idx);
//
//     if (lists == null) {
//       state = state.copyWith(isLoading: false);
//       return;
//     }
//
//     state = state.copyWith(isLoading: false, list: lists.data.list);
//   }
// }
