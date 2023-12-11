// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
// import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
// import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_item_model.dart';
// import 'package:pet_mobile_social_flutter/models/restrain/restrain_write_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
// import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
// import 'package:pet_mobile_social_flutter/repositories/restrain/restrain_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/withdrawal/withdrawal_repository.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// final restrainWriteStateProvider = StateNotifierProvider<RestrainWriteStateNotifier, RestrainWriteListModel>((ref) {
//   return RestrainWriteStateNotifier(ref);
// });
//
// class RestrainWriteStateNotifier extends StateNotifier<RestrainWriteListModel> {
//   RestrainWriteStateNotifier(this.ref) : super(RestrainWriteListModel(restrain: RestrainWriteItemModel()));
//
//   final Ref ref;
//
//   getWriteRestrain() async {
//     try {
//       final lists = await RestrainRepository(dio: ref.read(dioProvider)).getWriteRestrain(memberIdx);
//
//       if (lists == null) {
//         state = state.copyWith(isLoading: false);
//         return;
//       }
//
//       state = state.copyWith(
//         isLoading: false,
//         restrain: lists.data.restrain,
//       );
//     } on APIException catch (apiException) {
//       await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
//       state = state.copyWith(isLoading: false);
//     } catch (e) {
//       print('getWriteRestrain error $e');
//       state = state.copyWith(isLoading: false);
//     }
//   }
// }
