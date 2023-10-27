import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/main/feed/feed_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/my_pet/my_pet_list/my_pet_list_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/save_contents/save_contents_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_pet_list_state_provider.g.dart';

final expandedHeightProvider = StateProvider<double>((ref) => 190.0);

@Riverpod(keepAlive: true)
class MyPetListState extends _$MyPetListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  int? memberIdx;

  String? imgDomain;

  @override
  PagingController<int, MyPetItemModel> build() {
    PagingController<int, MyPetItemModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
      var result = await MyPetListRepository(dio: ref.read(dioProvider)).getMyPetList(
        memberIdx: memberIdx ?? loginMemberIdx,
        loginMemberIdx: loginMemberIdx,
        page: pageKey,
      );

      imgDomain = result.data.imgDomain;

      result.data.list.isEmpty ? ref.watch(expandedHeightProvider.notifier).state = 190 : ref.watch(expandedHeightProvider.notifier).state = 300;

      List<MyPetItemModel> petList = result.data.list
          .map(
            (e) => MyPetItemModel(
              idx: e.idx,
              imgSort: e.imgSort,
              imgWidth: e.imgWidth,
              imgHeight: e.imgHeight,
              personalityIdx: e.personalityIdx,
              memberIdx: e.memberIdx,
              typeName: e.typeName,
              birth: e.birth,
              weight: e.weight,
              genderText: e.genderText,
              personalityEtc: e.personalityEtc,
              url: e.url,
              breedName: e.breedName,
              personality: e.personality,
              sizeText: e.sizeText,
              breedNameEtc: e.breedNameEtc,
              name: e.name,
              breedIdx: e.breedIdx,
              ageText: e.ageText,
              uuid: e.uuid,
            ),
          )
          .toList();

      ///NOTE
      ///산책 시 기본 선택값
      ///TODO
      ///선택항목 따로 관리하고 거기서 보고 판단 다시 해야함
      petList.first = petList.first.copyWith(selected: true);
      ref.read(walkSelectedPetStateProvider.notifier).state.add(petList.first);

      try {
        _lastPage = result.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = petList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(petList);
      } else {
        state.appendPage(petList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void changedPetSelectState(MyPetItemModel itemModel) {
    int targetIdx = state.itemList!.indexWhere((element) => element == itemModel);
    // int targetIdx = Random().nextInt(state.itemList!.length ?? 4);
    print('targetIdx $targetIdx / uuid ${state.itemList}');
    if (targetIdx >= 0) {
      bool selectedState = state.itemList![targetIdx].selected;

      if (selectedState) {
        if (ref.read(walkSelectedPetStateProvider.notifier).state.length == 1) {
          return;
        } else {
          ref.read(walkSelectedPetStateProvider.notifier).state.remove(state.itemList![targetIdx]);
        }
      }

      state.itemList![targetIdx] = state.itemList![targetIdx].copyWith(
        selected: !selectedState,
      );

      state.notifyListeners();

      if (!selectedState) {
        ref.read(walkSelectedPetStateProvider.notifier).state.add(state.itemList![targetIdx]);
      }
    }
  }
}
