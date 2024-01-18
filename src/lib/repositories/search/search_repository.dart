import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:pet_mobile_social_flutter/services/search/search_service.dart';

class SearchRepository {
  late final SearchService _searchService;

  final Dio dio;

  SearchRepository({
    required this.dio,
  }) {
    _searchService = SearchService(dio, baseUrl: baseUrl);
  }

  Future<SearchDataListModel> getMentionRecommendList({
    required int page,
    int limit = 10,
  }) async {
    SearchResponseModel responseModel = await _searchService.getMentionRecommendList(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getMentionRecommendList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getMentionRecommendList',
      );
    }

    return responseModel.data!;
  }

  Future<SearchDataListModel> getImageTagRecommendList({
    required int page,
    int limit = 10,
  }) async {
    SearchResponseModel responseModel = await _searchService.getImageTagRecommendList(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getImageTagRecommendList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getImageTagRecommendList',
      );
    }

    return responseModel.data!;
  }

  Future<SearchDataListModel> getNickSearchList({
    required int page,
    required String searchWord,
    int limit = 20,
  }) async {
    print("searchWordsearchWordsearchWord" "${searchWord}");

    SearchResponseModel responseModel = await _searchService.getNickSearchList(page, searchWord, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getNickSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getNickSearchList',
      );
    }

    return responseModel.data!;
  }

  Future<SearchDataListModel> getTagSearchList({
    required int page,
    required String searchWord,
    int limit = 20,
  }) async {
    SearchResponseModel responseModel = await _searchService.getTagSearchList(page, searchWord, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getTagSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getTagSearchList',
      );
    }

    return responseModel.data!;
  }

  Future<SearchDataListModel> getFullSearchList({
    required String searchWord,
    int? page,
    int? limit,
  }) async {
    SearchResponseModel responseModel = await _searchService.getFullSearchList(searchWord, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getFullSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'SearchRepository',
        caller: 'getFullSearchList',
      );
    }

    return responseModel.data!;
  }
}
