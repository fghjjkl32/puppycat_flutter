import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
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

  Future<SearchResponseModel> getMentionRecommendList({
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

    return responseModel;
  }

  Future<SearchResponseModel> getImageTagRecommendList({
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

    return responseModel;
  }

  Future<SearchResponseModel> getNickSearchList({
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

    return responseModel;
  }

  Future<SearchResponseModel> getTagSearchList({
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

    return responseModel;
  }

  Future<SearchResponseModel> getFullSearchList({
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

    return responseModel;
  }
}
