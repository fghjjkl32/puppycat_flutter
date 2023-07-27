import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/main/feed/feed_service.dart';

class FeedRepository {
  final FeedService _feedService = FeedService(DioWrap.getDioWithCookie());

  //user page feed list - my
  Future<ContentResponseModel> getMyContentList({
    required page,
    required loginMemberIdx,
  }) async {
    ContentResponseModel? contentsResponseModel =
        await _feedService.getMyContentList(loginMemberIdx, page);

    if (contentsResponseModel == null) {
      return contentNullResponseModel;
    }

    return contentsResponseModel;
  }

  Future<ContentResponseModel> getMyTagContentList({
    required page,
    required loginMemberIdx,
  }) async {
    ContentResponseModel? contentsResponseModel =
        await _feedService.getMyTagContentList(loginMemberIdx, page);

    if (contentsResponseModel == null) {
      return contentNullResponseModel;
    }

    return contentsResponseModel;
  }

  //user page feed list - user
  Future<ContentResponseModel> getUserContentList({
    required page,
    required loginMemberIdx,
    required memberIdx,
  }) async {
    ContentResponseModel? contentsResponseModel =
        await _feedService.getUserContentList(loginMemberIdx, memberIdx, page);

    if (contentsResponseModel == null) {
      return contentNullResponseModel;
    }

    return contentsResponseModel;
  }

  Future<ContentResponseModel> getUserTagContentList({
    required page,
    required loginMemberIdx,
    required memberIdx,
  }) async {
    ContentResponseModel? contentsResponseModel = await _feedService
        .getUserTagContentList(loginMemberIdx, memberIdx, page);

    if (contentsResponseModel == null) {
      return contentNullResponseModel;
    }

    return contentsResponseModel;
  }

  //user contents detail
  Future<FeedResponseModel> getUserContentsDetailList({
    required memberIdx,
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel? contentsResponseModel = await _feedService
        .getUserContentDetailList(loginMemberIdx, memberIdx, page);

    if (contentsResponseModel == null) {
      return feedNullResponseModel;
    }

    return contentsResponseModel;
  }

  Future<FeedResponseModel> getUserTagContents({
    required int memberIdx,
    required int page,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel? tagResponseModel = await _feedService
        .getUserTagContentDetail(loginMemberIdx, memberIdx, page);

    if (tagResponseModel == null) {
      return feedNullResponseModel;
    }

    return tagResponseModel;
  }

  //my contents
  Future<FeedResponseModel> getMyContentsDetail({
    required int contentIdx,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel? myContentResponseModel =
        await _feedService.getMyContentDetail(contentIdx, loginMemberIdx);

    if (myContentResponseModel == null) {
      return feedNullResponseModel;
    }

    return myContentResponseModel;
  }

  Future<FeedResponseModel> getMyContentsDetailList({
    required memberIdx,
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel? myContentResponseModel = await _feedService
        .getMyContentDetailList(loginMemberIdx, memberIdx, page);

    if (myContentResponseModel == null) {
      return feedNullResponseModel;
    }

    return myContentResponseModel;
  }

  Future<FeedResponseModel> getContentDetail({
    required int contentIdx,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel? myContentResponseModel =
        await _feedService.getContentDetail(contentIdx, loginMemberIdx);

    if (myContentResponseModel == null) {
      return feedNullResponseModel;
    }

    return myContentResponseModel;
  }

  Future<FeedResponseModel> getMyTagContentsDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel? myContentResponseModel =
        await _feedService.getMyTagContentDetailList(loginMemberIdx, page);

    if (myContentResponseModel == null) {
      return feedNullResponseModel;
    }

    return myContentResponseModel;
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
