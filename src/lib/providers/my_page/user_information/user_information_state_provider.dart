import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_information_state_provider.g.dart';

final userInformationFutureProvider =
    FutureProvider.autoDispose<List<UserInformationItemModel>>((ref) async {
  final userInformation = ref.read(userInformationStateProvider.notifier);
  final userIndex = ref.read(userModelProvider)!.idx;
  return await userInformation.getUserInformation(userIndex);
});

@riverpod
class UserInformationState extends _$UserInformationState {
  @override
  List<UserInformationItemModel> build() {
    return [];
  }

  Future<List<UserInformationItemModel>> getUserInformation(
      int memberIdx) async {
    final UserInformationRepository myInformationRepository =
        UserInformationRepository();
    try {
      var result = await myInformationRepository.getUserInformation(memberIdx);

      state = result.data.info;
      return result.data.info;
    } catch (e) {
      print(e);
      state = [];
      throw Exception('Failed to load information');
    }
  }
}
