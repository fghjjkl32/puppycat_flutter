import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';

// import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';

final myInformationStateProvider = StateNotifierProvider<MyInformationStateNotifier, UserInformationItemModel>((ref) {
  return MyInformationStateNotifier(ref);
});

class MyInformationStateNotifier extends StateNotifier<UserInformationItemModel> {
  MyInformationStateNotifier(this.ref) : super(UserInformationItemModel());

  final Ref ref;

  getInitUserInformation({
    required String memberUuid,
  }) async {
    try {
      final userInformationItemModel = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(memberUuid);

      state = userInformationItemModel;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = UserInformationItemModel();
    } catch (e) {
      print('getInitUserInformation error $e');
      state = UserInformationItemModel();
    }
  }
}
