import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/follow/follow_service.dart';
import 'package:pet_mobile_social_flutter/services/my_page/content_like_user_list/content_like_user_list_service.dart';

class FollowRepository {
  late final FollowService _followService; // = FollowService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  FollowRepository({
    required this.dio,
  }) {
    _followService = FollowService(dio, baseUrl: baseUrl);
  }

  Future<FollowResponseModel> getFollowerSearchList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowerSearchList(loginMemberIdx, memberIdx, page, searchWord);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerSearchList',
      );
    }

    return responseModel;
  }

  Future<FollowResponseModel> getFollowSearchList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowSearchList(loginMemberIdx, memberIdx, page, searchWord);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowSearchList',
      );
    }

    return responseModel;
  }

  Future<FollowResponseModel> getFollowerList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowerList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowerList',
      );
    }

    return responseModel;
  }

  Future<FollowResponseModel> getFollowList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
  }) async {
    FollowResponseModel responseModel = await _followService.getFollowList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FollowRepository',
        caller: 'getFollowList',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteFollow({
    required int followIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _followService.deleteFollow(followIdx, memberIdx);

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
    required int followIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _followService.deleteFollower(followIdx, memberIdx);

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
    required int followIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _followService.postFollow(followIdx, body);

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
