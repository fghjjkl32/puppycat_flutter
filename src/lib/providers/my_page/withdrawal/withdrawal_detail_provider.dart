import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/repositories/withdrawal/withdrawal_repository.dart';
import 'package:riverpod/riverpod.dart';

final withdrawalDetailStateProvider = StateNotifierProvider<WithdrawalDetailStateNotifier, WithdrawalDetailListModel>((ref) {
  return WithdrawalDetailStateNotifier(ref);
});

class WithdrawalDetailStateNotifier extends StateNotifier<WithdrawalDetailListModel> {
  WithdrawalDetailStateNotifier(this.ref) : super(const WithdrawalDetailListModel());

  final Ref ref;

  getWithdrawalDetailList() async {
    try {
      final lists = await WithdrawalRepository(dio: ref.read(dioProvider)).getWithdrawalDetailList();

      state = lists;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('getWithdrawalDetailList error $e');
    }
  }
}
