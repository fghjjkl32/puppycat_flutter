import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/pet_detail/pet_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/create_my_pet/create_my_pet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_my_pet_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CreateMyPetState extends _$CreateMyPetState {
  @override
  List build() {
    return [];
  }

  Future<ResponseModel> postMyPet({
    required PetDetailItemModel petDetailItemModel,
    required XFile? file,
  }) async {
    final result = await CreateMyPetRepository(dio: ref.read(dioProvider)).postMyPet(petDetailItemModel, file);

    return result;
  }

  Future<ResponseModel> updateMyPet({
    required PetDetailItemModel petDetailItemModel,
    required XFile? file,
  }) async {
    final result = await CreateMyPetRepository(dio: ref.read(dioProvider)).updateMyPet(petDetailItemModel, file);

    return result;
  }

  Future<ResponseModel> deleteMyPet({
    required int idx,
    required int memberIdx,
  }) async {
    final result = await CreateMyPetRepository(dio: ref.read(dioProvider)).deleteMyPet(idx, memberIdx);

    return result;
  }
}
