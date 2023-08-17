import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/follow/follow_service.dart';
import 'package:pet_mobile_social_flutter/services/my_page/content_like_user_list/content_like_user_list_service.dart';

class FollowRepository {
  final FollowService _followService =
      FollowService(DioWrap.getDioWithCookie());

  Future<FollowResponseModel> getFollowerSearchList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    FollowResponseModel? followResponseModel = await _followService
        .getFollowerSearchList(loginMemberIdx, memberIdx, page, searchWord)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      return FollowResponseModel(
        result: false,
        code: "",
        data: const FollowDataListModel(
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

    return followResponseModel;
  }

  Future<FollowResponseModel> getFollowSearchList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
    required String searchWord,
  }) async {
    FollowResponseModel? followResponseModel = await _followService
        .getFollowSearchList(loginMemberIdx, memberIdx, page, searchWord)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      return FollowResponseModel(
        result: false,
        code: "",
        data: const FollowDataListModel(
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

    return followResponseModel;
  }

  Future<FollowResponseModel> getFollowerList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
  }) async {
    FollowResponseModel? followResponseModel = await _followService
        .getFollowerList(loginMemberIdx, memberIdx, page)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      return FollowResponseModel(
        result: false,
        code: "",
        data: const FollowDataListModel(
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

    return followResponseModel;
  }

  Future<FollowResponseModel> getFollowList({
    required int loginMemberIdx,
    required int memberIdx,
    required int page,
  }) async {
    FollowResponseModel? followResponseModel = await _followService
        .getFollowList(loginMemberIdx, memberIdx, page)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      return FollowResponseModel(
        result: false,
        code: "",
        data: const FollowDataListModel(
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

    return followResponseModel;
  }

  Future<ResponseModel> deleteFollow({
    required int followIdx,
    required int memberIdx,
  }) async {
    ResponseModel? followResponseModel = await _followService
        .deleteFollow(followIdx, memberIdx)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      throw "error";
    }

    return followResponseModel;
  }

  Future<ResponseModel> deleteFollower({
    required int followIdx,
    required int memberIdx,
  }) async {
    ResponseModel? followResponseModel = await _followService
        .deleteFollower(followIdx, memberIdx)
        .catchError((Object obj) async {});

    if (followResponseModel == null) {
      throw "error";
    }

    return followResponseModel;
  }

  Future<ResponseModel> postFollow({
    required int followIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel? followResponseModel =
        await _followService.postFollow(followIdx, body);

    if (followResponseModel == null) {
      throw "error";
    }

    return followResponseModel;
  }
}
