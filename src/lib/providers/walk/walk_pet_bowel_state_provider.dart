import 'package:collection/collection.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walk_pet_bowel_state_provider.g.dart';

@Riverpod(keepAlive: true)
class WalkPetBowelState extends _$WalkPetBowelState {
  @override
  List<PetState> build() {
    return [];
  }

  void setPetList(List<WalkPetList> petList) {
    state.clear();

    List<PetState> petStates = [
      ...petList.map((e) {
        final peeAmount = peeAmountList.indexWhere((element) => element == e.peeAmountText);
        final peeColor = peeColorList.indexWhere((element) => element == e.peeColorText);
        final poopAmount = poopAmountList.indexWhere((element) => element == e.poopAmountText);
        final poopColor = poopColorList.indexWhere((element) => element == e.poopColorText);
        final poopForm = poopFormList.indexWhere((element) => element == e.poopFormText);

        return PetState(
          petUuid: e.petUuid!,
          peeCount: e.peeCount ?? 0,
          peeAmount: peeAmount >= 0 ? peeAmount : 0,
          peeColor: peeColor >= 0 ? peeColor : 0,
          poopCount: e.poopCount ?? 0,
          poopAmount: poopAmount >= 0 ? poopAmount : 0,
          poopColor: poopColor >= 0 ? poopColor : 0,
          poopForm: poopForm >= 0 ? poopForm : 0,
        );
      }).toList()
    ];

    state.addAll(petStates);
  }

  PetState? findPetState(String uuid) {
    return state.singleWhereOrNull((element) => element.petUuid == uuid);
  }

  int findPetStateIndex(String uuid) {
    final petStates = state;
    final targetIndex = petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return -1;
    }

    return targetIndex;
  }

  void setPeeCount(String uuid, int count) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    print('setpeecount targetIndex $targetIndex');
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].peeCount = count;
    print('petStates[targetIndex].peeCount ${petStates[targetIndex].peeCount} / $count');
    state = [...petStates];
    // state[targetIndex] = targetState;
  }

  void setPeeAmount(String uuid, int amountIdx) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); // petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].peeAmount = amountIdx;
    state = [...petStates];
  }

  void setPeeColor(String uuid, int colorIdx) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].peeColor = colorIdx;
    state = [...petStates];
  }

  void setPoopCount(String uuid, int count) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].poopCount = count;
    state = [...petStates];
  }

  void setPoopAmount(String uuid, int amountIdx) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].poopAmount = amountIdx;
    state = [...petStates];
  }

  void setPoopColor(String uuid, int colorIdx) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].poopColor = colorIdx;
    state = [...petStates];
  }

  void setPoopForm(String uuid, int formIdx) {
    final petStates = state;
    final targetIndex = findPetStateIndex(uuid); //petStates.indexWhere((element) => element.petUuid == uuid);
    if (targetIndex < 0) {
      return;
    }

    petStates[targetIndex].poopForm = formIdx;
    state = [...petStates];
  }
}

class PetState {
  String petUuid;
  int peeCount;
  int peeAmount;
  int peeColor;
  int poopCount;
  int poopAmount;
  int poopColor;
  int poopForm;

  PetState({
    required this.petUuid,
    required this.peeCount,
    required this.peeAmount,
    required this.peeColor,
    required this.poopCount,
    required this.poopAmount,
    required this.poopColor,
    required this.poopForm,
  });
}
