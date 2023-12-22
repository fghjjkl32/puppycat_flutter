import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/main/report/user_list_repository.dart';
import 'package:riverpod/riverpod.dart';

final reportStateProvider = StateNotifierProvider<ReportStateNotifier, SelectButtonListModel>((ref) {
  return ReportStateNotifier(ref);
});

class ReportStateNotifier extends StateNotifier<SelectButtonListModel> {
  ReportStateNotifier(this.ref) : super(const SelectButtonListModel());

  final Ref ref;

  getInitCommentReportList() async {
    final lists = await ReportRepository(dio: ref.read(dioProvider)).getCommentReportList();

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.list,
    );
  }

  getInitContentReportList() async {
    final lists = await ReportRepository(dio: ref.read(dioProvider)).getContentReportList();

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      list: lists.list,
    );
  }
}
