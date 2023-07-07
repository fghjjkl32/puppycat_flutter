import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_information_repository.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_information_state_provider.g.dart';

final myInformationFutureProvider =
    FutureProvider.autoDispose<List<MyInformationItemModel>>((ref) async {
  final myInformation = ref.read(myInformationStateProvider.notifier);
  final userIndex = ref.read(userModelProvider)!.idx;
  return await myInformation.getMyInformation(userIndex);
});

@riverpod
class MyInformationState extends _$MyInformationState {
  @override
  List<MyInformationItemModel> build() {
    return [];
  }

  Future<List<MyInformationItemModel>> getMyInformation(int memberIdx) async {
    final MyInformationRepository myInformationRepository =
        MyInformationRepository();
    try {
      var result = await myInformationRepository.getMyInformation(memberIdx);
      state = result;
      return result;
    } catch (e) {
      state = [];
      throw Exception('Failed to load information');
    }
  }
}
