// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_data_list_model.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/customer_support/customer_support_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/like_contents/like_contents_repository.dart';
// import 'package:riverpod/riverpod.dart';
//
// final faqStateProvider =
//     StateNotifierProvider<FaqStateNotifier, MenuDataListModel>((ref) {
//   return FaqStateNotifier();
// });
//
// class FaqStateNotifier extends StateNotifier<MenuDataListModel> {
//   FaqStateNotifier() : super(const MenuDataListModel());
//
//   initFaqMenu() async {
//     final lists = await CustomerSupportRepository().getFaqMenuList();
//
//     if (lists == null) {
//       state = state.copyWith(isLoading: false);
//       return;
//     }
//
//     state = state.copyWith(isLoading: false, list: lists.data);
//   }
// }
