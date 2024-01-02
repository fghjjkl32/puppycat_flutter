import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/withdrawal/withdrawal_repository.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:riverpod/riverpod.dart';

enum WithdrawalStatus {
  none,
  success,
  failure,
}

final withdrawalCodeProvider = StateProvider<int>((ref) => 0);

final withdrawalReasonProvider = StateProvider<String?>((ref) => null);

final withdrawalStateProvider = StateNotifierProvider<WithdrawalStateNotifier, SelectButtonListModel>((ref) {
  return WithdrawalStateNotifier(ref);
});

class WithdrawalStateNotifier extends StateNotifier<SelectButtonListModel> {
  WithdrawalStateNotifier(this.ref) : super(const SelectButtonListModel());

  final Ref ref;

  getWithdrawalReasonList() async {
    try {
      final lists = await WithdrawalRepository(dio: ref.read(dioProvider)).getWithdrawalReasonList();

      if (lists == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        list: lists.list,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('getWithdrawalReasonList error $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> withdrawalUser({required int code, String? reason}) async {
    try {
      final withdrawalRepository = WithdrawalRepository(dio: ref.read(dioProvider));

      var result = await withdrawalRepository.withdrawalUser(
        code: code,
        reason: reason,
      );

      if (result == WithdrawalStatus.success) {
        // ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
        //TODO
        //탈퇴 후 처리 고도화 필요
        await TokenController.clearTokens();
        ref.read(loginStateProvider.notifier).state = LoginStatus.none;
        ref.read(myInfoStateProvider.notifier).state = UserInformationItemModel();
        // ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
        ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
        ref.read(signUpUserInfoProvider.notifier).state = null;
        ref.read(authStateProvider.notifier).state = false;
        ref.read(checkButtonProvider.notifier).state = false;
        ref.read(policyStateProvider.notifier).policyStateReset();
        ref.read(nickNameProvider.notifier).state = NickNameStatus.none;
        // ref.read(loginStateProvider.notifier).saveUserModel(null);
        ref.read(routerProvider).push("/home/myPage/profileEdit/withdrawalSelect/withdrawalDetail/withdrawalSuccess");
        return true;
      } else {
        return false;
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('initContentLikeUserList error $e');
      rethrow;
    }
  }
}
