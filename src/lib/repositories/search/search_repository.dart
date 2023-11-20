import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
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

  Future<SearchResponseModel> getMentionRecommendList({
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel responseModel = await _searchService.getMentionRecommendList(memberIdx, page);

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
    required int memberIdx,
    required int page,
  }) async {
    SearchResponseModel responseModel = await _searchService.getImageTagRecommendList(memberIdx, page);

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
    required int? memberIdx,
    required int page,
    required String searchWord,
    int limit = 20,
  }) async {
    SearchResponseModel responseModel;
    memberIdx == null
        ? responseModel = await _searchService.getLogoutNickSearchList(page, searchWord, limit)
        : responseModel = await _searchService.getNickSearchList(memberIdx, page, searchWord, limit);

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
    required int? memberIdx,
    required int page,
    required String searchWord,
    int limit = 20,
  }) async {
    SearchResponseModel responseModel;
    memberIdx == null
        ? responseModel = await _searchService.getLogoutTagSearchList(page, searchWord, limit)
        : responseModel = await _searchService.getTagSearchList(memberIdx, page, searchWord, limit);

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
    required int? memberIdx,
    required String searchWord,
  }) async {
    SearchResponseModel responseModel;
    memberIdx == null
        ? responseModel = await _searchService.getLogoutFullSearchList(searchWord)
        : responseModel = await _searchService.getFullSearchList(memberIdx, searchWord);

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
