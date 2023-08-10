import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:pet_mobile_social_flutter/services/search/search_service.dart';

class SearchRepository {
  final SearchService _searchService =
      SearchService(DioWrap.getDioWithCookie());

  Future<SearchResponseModel> getMentionRecommendList({
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel? searchResponseModel = await _searchService
        .getMentionRecommendList(memberIdx, page)
        .catchError((Object obj) async {});

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
    SearchResponseModel? searchResponseModel = await _searchService
        .getImageTagRecommendList(memberIdx, page)
        .catchError((Object obj) async {});

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

  Future<SearchResponseModel> getSearchList({
    required int memberIdx,
    required int page,
    required String searchWord,
    int limit = 10,
  }) async {
    SearchResponseModel? searchResponseModel = await _searchService
        .getSearchList(memberIdx, page, searchWord, limit)
        .catchError((Object obj) async {});

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
