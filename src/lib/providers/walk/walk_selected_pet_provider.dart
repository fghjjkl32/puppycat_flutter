import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walk_selected_pet_provider.g.dart';


@Riverpod(keepAlive: true)
class WalkSelectedPetState extends _$WalkSelectedPetState {
  @override
  List<MyPetItemModel> build() {
    return [];
  }

  MyPetItemModel getFirstRegPet() {
    if(state.isEmpty) {
      throw 'Selected Pet List is Empty.';
    }

    final selectedPetList = state;
    final firstPet =  selectedPetList.reduce((firstPet, element) {
      return element.idx! < firstPet.idx! ? element : firstPet;
    });

    return firstPet;
  }

  // int getTodayWalkCount() {
  //
  // }
}
