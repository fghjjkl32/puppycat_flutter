import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_response_model.dart';
import 'package:pet_mobile_social_flutter/services/follow/follow_service.dart';

class FollowRepository {
  late final FollowService _followService; // = FollowService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  FollowRepository({
    required this.dio,
  }) {
    _followService = FollowService(dio, baseUrl: baseUrl);
  }

  Future<FollowDataListModel> getFollowerSearchList({
    required String memberUuid,
    required int page,
    required String searchWord,
    String searchType = 'nick',
    int limit = 30,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowerSearchList(memberUuid, page, searchWord, searchType, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerSearchList',
      );
    }

    return responseModel.data!;
  }

  Future<FollowDataListModel> getFollowSearchList({
    required String memberUuid,
    required int page,
    required String searchWord,
    String searchType = 'nick',
    int limit = 30,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowSearchList(memberUuid, page, searchWord, searchType, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowSearchList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowSearchList',
      );
    }

    return responseModel.data!;
  }

  Future<FollowDataListModel> getFollowerList({
    required String memberUuid,
    required int page,
    int limit = 30,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowerList(memberUuid, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerList',
      );
    }

    return responseModel.data!;
  }

  Future<FollowDataListModel> getFollowList({
    required String memberUuid,
    required int page,
    int limit = 30,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowList(memberUuid, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowList',
      );
    }

    return responseModel.data!;
  }

  Future<ResponseModel> deleteFollow({
    required String followUuid,
  }) async {
    ResponseModel responseModel = await _followService.deleteFollow(followUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'deleteFollow',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteFollower({
    required String followUuid,
  }) async {
    ResponseModel responseModel = await _followService.deleteFollower(followUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'deleteFollower',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postFollow({
    required String followUuid,
  }) async {
    ResponseModel responseModel = await _followService.postFollow(followUuid);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'postFollow',
      );
    }

    return responseModel;
  }
}
