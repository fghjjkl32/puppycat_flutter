import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:pet_mobile_social_flutter/services/search/search_service.dart';

class SearchRepository {
  final SearchService _searchService = SearchService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  Future<SearchResponseModel> getMentionRecommendList({
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel? searchResponseModel = await _searchService.getMentionRecommendList(memberIdx, page).catchError((Object obj) async {});

    if (searchResponseModel == null) {
      return SearchResponseModel(
        result: false,
        code: "",
        data: const SearchDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return searchResponseModel;
  }

  Future<SearchResponseModel> getImageTagRecommendList({
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel? searchResponseModel = await _searchService.getImageTagRecommendList(memberIdx, page).catchError((Object obj) async {});

    if (searchResponseModel == null) {
      return SearchResponseModel(
        result: false,
        code: "",
        data: const SearchDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return searchResponseModel;
  }

  Future<SearchResponseModel> getNickSearchList({
    required int? memberIdx,
    required int page,
    required String searchWord,
    int limit = 10,
  }) async {
    SearchResponseModel? searchResponseModel;
    memberIdx == null
        ? searchResponseModel = await _searchService.getLogoutNickSearchList(page, searchWord, limit).catchError((Object obj) async {})
        : searchResponseModel = await _searchService.getNickSearchList(memberIdx, page, searchWord, limit).catchError((Object obj) async {});

    if (searchResponseModel == null) {
      return SearchResponseModel(
        result: false,
        code: "",
        data: const SearchDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return searchResponseModel;
  }

  Future<SearchResponseModel> getTagSearchList({
    required int? memberIdx,
    required int page,
    required String searchWord,
    int limit = 10,
  }) async {
    SearchResponseModel? searchResponseModel;
    memberIdx == null
        ? searchResponseModel = await _searchService.getLogoutTagSearchList(page, searchWord, limit).catchError((Object obj) async {})
        : searchResponseModel = await _searchService.getTagSearchList(memberIdx, page, searchWord, limit).catchError((Object obj) async {});

    if (searchResponseModel == null) {
      return SearchResponseModel(
        result: false,
        code: "",
        data: const SearchDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return searchResponseModel;
  }

  Future<SearchResponseModel> getFullSearchList({
    required int? memberIdx,
    required String searchWord,
  }) async {
    SearchResponseModel? searchResponseModel;
    print(await _searchService.getLogoutFullSearchList(searchWord).catchError((Object obj) async {}));
    memberIdx == null
        ? searchResponseModel = await _searchService.getLogoutFullSearchList(searchWord).catchError((Object obj) async {})
        : searchResponseModel = await _searchService.getFullSearchList(memberIdx, searchWord).catchError((Object obj) async {});

    if (searchResponseModel == null) {
      return SearchResponseModel(
        result: false,
        code: "",
        data: const SearchDataListModel(
          list: [],
          params: ParamsModel(
            memberIdx: 0,
            pagination: Pagination(
              startPage: 0,
              limitStart: 0,
              totalPageCount: 0,
              existNextPage: false,
              endPage: 0,
              existPrevPage: false,
              totalRecordCount: 0,
            ),
            offset: 0,
            limit: 0,
            pageSize: 0,
            page: 0,
            recordSize: 0,
          ),
        ),
        message: "",
      );
    }

    return searchResponseModel;
  }
}
