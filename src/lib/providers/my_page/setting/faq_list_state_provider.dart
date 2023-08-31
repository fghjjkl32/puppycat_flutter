import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/customer_support/customer_support_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'faq_list_state_provider.g.dart';

@Riverpod(keepAlive: true)
class FaqListState extends _$FaqListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

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
      var searchResult = await customerSupportRepository.getFaqList(page:pageKey);

      if(searchResult == null) {
        _apiStatus = ListAPIStatus.loaded;
        state.appendPage([], 0);
        return;
      }

      var searchList = searchResult!.data.list;

      try {
        _lastPage = searchResult!.data.params!.pagination!.totalPageCount!;
      } catch (_) {
        _lastPage = 1;
      }

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
    } catch (e) {
      _apiStatus = ListAPIStatus.error;
      state.error = e;
    }
  }
  
  void search(String keyword) {
    if(keyword.isEmpty) {
      state.refresh();
      return;
    }
    
    List<CustomerSupportItemModel> currentList = state.itemList ?? [];
    List<CustomerSupportItemModel> filterList = [];

    for (var element in currentList) {
      if(element.title != null) {
        print('keyword $keyword');
        if (element.title!.contains(keyword)) {
          filterList.add(element);
        }
      }
    }

    print('filterList $filterList');
    _apiStatus = ListAPIStatus.loaded;
    state.itemList = [];
    state.appendLastPage(filterList);
    print('state ${state.itemList!.length} / ${currentList.length}');
  }
}
