import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/customer_support/customer_support_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notice_list_state_provider.g.dart';

final noticeFocusIdxStateProvider = StateProvider<int>((ref) => 0);
final noticeExpansionIdxStateProvider = StateProvider<int>((ref) => 0);

enum NoticeType {
  all,
  normal,
  event,
}

@Riverpod(keepAlive: true)
class NoticeListState extends _$NoticeListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  NoticeType _noticeType = NoticeType.all;

  @override
  PagingController<int, CustomerSupportItemModel> build() {
    PagingController<int, CustomerSupportItemModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if(_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      CustomerSupportRepository customerSupportRepository = CustomerSupportRepository(dio: ref.read(dioProvider));
      var searchResult = await customerSupportRepository.getNoticeList(pageKey, _noticeType == NoticeType.all ? null : _noticeType.index);

      if(searchResult == null) {
        _apiStatus = ListAPIStatus.loaded;
        state.appendPage([], 0);
        return;
      }

      var searchList = searchResult!.data.list;


      try {
        _lastPage = searchResult!.data.params!.pagination?.totalPageCount! ?? 0;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? 0 : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }

      var focusIdx = ref.read(noticeFocusIdxStateProvider);
      if(focusIdx > 0) {
        List<CustomerSupportItemModel> currentList = state.itemList ?? [];
        if(currentList.indexWhere((element) => element.idx == focusIdx) < 0) {
          print('nextPageKey $nextPageKey');
          state.notifyPageRequestListeners(nextPageKey);
        }
      }

      _apiStatus = ListAPIStatus.loaded;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      _apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }

  void setNoticeType(NoticeType type) {
    _noticeType = type;
    state.refresh();
  }
}
