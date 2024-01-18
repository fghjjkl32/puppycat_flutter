import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/report/user_list_repository.dart';
import 'package:riverpod/riverpod.dart';

final reportStateProvider = StateNotifierProvider<ReportStateNotifier, ReasonListModel>((ref) {
  return ReportStateNotifier(ref);
});

class ReportStateNotifier extends StateNotifier<ReasonListModel> {
  ReportStateNotifier(this.ref) : super(const ReasonListModel());

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
