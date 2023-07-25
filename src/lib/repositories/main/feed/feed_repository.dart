import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/main/feed/feed_service.dart';

class FeedRepository {
  final FeedService _feedService = FeedService(DioWrap.getDioWithCookie());

  Future<FeedResponseModel> getUserContentsList({
    required memberIdx,
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel? contentsResponseModel = await _feedService
        .getUserContentDetailList(loginMemberIdx, memberIdx, page);

    if (contentsResponseModel == null) {
      return FeedResponseModel(
        result: false,
        code: "",
        data: const FeedDataListModel(
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

    return contentsResponseModel;
  }

  Future<FeedResponseModel> getTagContents({
    required int memberIdx,
    required int page,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel? tagResponseModel =
        await _feedService.getTagContentDetail(loginMemberIdx, memberIdx, page);

    if (tagResponseModel == null) {
      return FeedResponseModel(
        result: false,
        code: "",
        data: const FeedDataListModel(
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

    return tagResponseModel;
  }

  Future<FeedResponseModel> getUserContentsDetail({
    required int contentIdx,
    required int page,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel? tagResponseModel = await _feedService
        .getUserContentDetail(contentIdx, loginMemberIdx, page);

    if (tagResponseModel == null) {
      return FeedResponseModel(
        result: false,
        code: "",
        data: const FeedDataListModel(
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

    return tagResponseModel;
  }

  Future<ResponseModel> postLike({
    required int memberIdx,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel? feedResponseModel =
        await _feedService.postLike(contentIdx, body);

    if (feedResponseModel == null) {
      throw "error";
    }

    return feedResponseModel;
  }

  Future<ResponseModel> deleteLike({
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel? feedResponseModel = await _feedService.deleteLike(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
    );

    if (feedResponseModel == null) {
      throw "error";
    }

    return feedResponseModel;
  }

  Future<ResponseModel> postSave({
    required int memberIdx,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel? feedResponseModel =
        await _feedService.postSave(contentIdx, body);

    if (feedResponseModel == null) {
      throw "error";
    }

    return feedResponseModel;
  }

  Future<ResponseModel> deleteSave({
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel? feedResponseModel = await _feedService.deleteSave(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
    );

    if (feedResponseModel == null) {
      throw "error";
    }

    return feedResponseModel;
  }
}
