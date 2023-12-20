import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/customer_support_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/customer_support/menu_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/customer_support/customer_support_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'faq_list_state_provider.g.dart';

enum FaqType {
  all,
  account,
  service,
  event,
  etc,
}

@Riverpod(keepAlive: true)
class FaqListState extends _$FaqListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;
  FaqType _faqType = FaqType.all;

  String? searchWord;
  late CustomerSupportRepository _customerSupportRepository; // = CustomerSupportRepository(dio: ref.read(dioProvider));

  @override
  PagingController<int, CustomerSupportItemModel> build() {
    _customerSupportRepository = CustomerSupportRepository(dio: ref.read(dioProvider));
    PagingController<int, CustomerSupportItemModel> pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      var searchResult = await _customerSupportRepository.getFaqList(pageKey, _faqType == FaqType.all ? null : _faqType.index, searchWord);

      if (searchResult == null) {
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

      final nextPageKey = searchList.isEmpty ? null : pageKey + 1;

      if (pageKey == _lastPage) {
        state.appendLastPage(searchList);
      } else {
        state.appendPage(searchList, nextPageKey);
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

  void search(String keyword) {
    if (keyword.isEmpty) {
      state.refresh();
      return;
    }
    searchWord = keyword;

    print("searchWord ${searchWord}");
    state.refresh();

    // print("keywordkeyword ${keyword}");

    // List<CustomerSupportItemModel> currentList = state.itemList ?? [];
    // List<CustomerSupportItemModel> filterList = [];
    //
    // for (var element in currentList) {
    //   if (element.title != null) {
    //     print('keyword $keyword');
    //     if (element.title!.contains(keyword)) {
    //       filterList.add(element);
    //     }
    //   }
    // }
    //
    // print('filterList $filterList');
    // _apiStatus = ListAPIStatus.loaded;
    // state.itemList = [];
    // state.appendLastPage(filterList);
    // print('state ${state.itemList!.length} / ${currentList.length}');
  }

  void setFaqType(FaqType type) {
    _faqType = type;
    state.refresh();
  }

  Future<List<MenuItemModel>> getFaqMenuList() async {
    List<MenuItemModel> menuList = [
      MenuItemModel(menuName: '전체', idx: 0),
    ];
    menuList.addAll(await _customerSupportRepository.getFaqMenuList());
    return menuList;
  }
}
