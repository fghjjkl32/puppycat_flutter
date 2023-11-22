import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/post_feed_state.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag.dart';
import 'package:pet_mobile_social_flutter/models/post_feed/tag_images.dart';
import 'package:pet_mobile_social_flutter/services/main/feed/feed_service.dart';

class FeedRepository {
  late final FeedService _feedService; // = FeedService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  FeedRepository({
    required this.dio,
  }) {
    _feedService = FeedService(dio, baseUrl: baseUrl);
  }

  //user page feed list - my
  Future<ContentResponseModel> getMyContentList({
    required page,
    required loginMemberIdx,
  }) async {
    ContentResponseModel responseModel = await _feedService.getMyContentList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getMyContentList',
      );
    }

    return responseModel;
  }

  Future<ContentResponseModel> getMyTagContentList({
    required page,
    required loginMemberIdx,
  }) async {
    ContentResponseModel responseModel = await _feedService.getMyTagContentList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getMyTagContentList',
      );
    }

    return responseModel;
  }

  //user page feed list - user
  Future<ContentResponseModel> getUserContentList({
    required page,
    required loginMemberIdx,
    required memberIdx,
  }) async {
    ContentResponseModel responseModel;

    loginMemberIdx == null ? responseModel = await _feedService.getLogoutUserContentList(memberIdx, page) : responseModel = await _feedService.getUserContentList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserContentList',
      );
    }

    return responseModel;
  }

  Future<ContentResponseModel> getUserTagContentList({
    required page,
    required loginMemberIdx,
    required memberIdx,
  }) async {
    ContentResponseModel responseModel;

    loginMemberIdx == null
        ? responseModel = await _feedService.getLogoutUserTagContentList(memberIdx, page)
        : responseModel = await _feedService.getUserTagContentList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserTagContentList',
      );
    }

    return responseModel;
  }

  Future<ContentResponseModel> getUserHashtagContentList({
    required memberIdx,
    required searchWord,
    required page,
  }) async {
    ContentResponseModel responseModel;

    memberIdx == null
        ? responseModel = await _feedService.getLogoutUserHashtagContentList(searchWord, page)
        : responseModel = await _feedService.getUserHashtagContentList(memberIdx, searchWord, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserHashtagContentList',
      );
    }

    return responseModel;
  }

  //user contents detail
  Future<FeedResponseModel> getUserContentsDetailList({
    required memberIdx,
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null
        ? responseModel = await _feedService.getLogoutUserContentDetailList(memberIdx, page)
        : responseModel = await _feedService.getUserContentDetailList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserContentsDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getUserTagContentDetail({
    required int memberIdx,
    required int page,
    required int? loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null
        ? responseModel = await _feedService.getLogoutUserTagContentDetail(memberIdx, page)
        : responseModel = await _feedService.getUserTagContentDetail(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserTagContentDetail',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getUserHashtagContentDetailList({
    required int? loginMemberIdx,
    required String searchWord,
    required int page,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null
        ? responseModel = await _feedService.getLogoutUserHashtagContentDetailList(searchWord, page)
        : responseModel = await _feedService.getUserHashtagContentDetailList(loginMemberIdx, searchWord, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getUserHashtagContentDetailList',
      );
    }

    return responseModel;
  }

  //my contents
  Future<FeedResponseModel> getMyContentsDetail({
    required int contentIdx,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel responseModel = await _feedService.getMyContentDetail(contentIdx, loginMemberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getMyContentsDetail',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getMyContentsDetailList({
    required memberIdx,
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel = await _feedService.getMyContentDetailList(loginMemberIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getMyContentsDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getContentDetail({
    required int contentIdx,
    required int? loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null ? responseModel = await _feedService.getLogoutContentDetail(contentIdx) : responseModel = await _feedService.getContentDetail(contentIdx, loginMemberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getContentDetail',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getMyTagContentsDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel = await _feedService.getMyTagContentDetailList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getMyTagContentsDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getPopularWeekDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    responseModel = await _feedService.getPopularWeekDetailList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getPopularWeekDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getPopularHourDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null ? responseModel = await _feedService.getLogoutPopularHourDetailList(page) : responseModel = await _feedService.getPopularHourDetailList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getPopularHourDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getFollowDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel = await _feedService.getFollowDetailList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getFollowDetailList',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getRecentDetailList({
    required page,
    required loginMemberIdx,
  }) async {
    FeedResponseModel responseModel;

    loginMemberIdx == null ? responseModel = await _feedService.getRecentLogoutDetailList(page) : responseModel = await _feedService.getRecentDetailList(loginMemberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'getRecentDetailList',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postLike({
    required int memberIdx,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _feedService.postLike(contentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'postLike',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteLike({
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _feedService.deleteLike(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteLike',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postSave({
    required int memberIdx,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _feedService.postSave(contentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'postSave',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteSave({
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _feedService.deleteSave(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteSave',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postHide({
    required int memberIdx,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _feedService.postHide(contentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'postHide',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteHide({
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _feedService.deleteHide(
      contentsIdx: contentsIdx,
      memberIdx: memberIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteHide',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteContents({required int memberIdx, required String idx}) async {
    ResponseModel responseModel = await _feedService.deleteContents(memberIdx, idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteOneContents({required int memberIdx, required int idx}) async {
    ResponseModel responseModel = await _feedService.deleteOneContents(memberIdx, idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteOneContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postContentReport({
    required int memberIdx,
    required int contentIdx,
    required int reportCode,
    required String? reason,
    required String reportType,
  }) async {
    final Map<String, dynamic> body;

    reportCode == 8
        ? body = {
            "reportCode": reportCode,
            "memberIdx": memberIdx,
            "reason": reason,
          }
        : body = {
            "reportCode": reportCode,
            "memberIdx": memberIdx,
          };

    ResponseModel responseModel = await _feedService.postContentReport(reportType, contentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'postContentReport',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteContentReport({
    required String reportType,
    required int contentsIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _feedService.deleteContentReport(
      reportType,
      contentsIdx,
      memberIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'deleteContentReport',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postFeed({
    required List<File> files,
    required int memberIdx,
    required int isView,
    String? location,
    String? contents,
    required PostFeedState feedState,
  }) async {
    List<MultipartFile> multiPartFiles = await Future.wait(
      files.map((file) async {
        return MultipartFileRecreatable.fromFileSync(
          file.path,
          contentType: MediaType('image', 'jpg'),
        );
      }).toList(),
    );

    Map<String, dynamic> formDataMap = {
      "memberIdx": memberIdx,
      "menuIdx": 1,
      "contents": contents ?? "",
      "isView": isView,
      "uploadFile": multiPartFiles,
    };

    int tagCounter = 0;
    for (var tagImage in feedState.tagImage) {
      for (var tag in tagImage.tag) {
        String baseKey = "imgTagList[$tagCounter]";
        formDataMap["$baseKey.imgIdx"] = tagImage.index;
        formDataMap["$baseKey.memberIdx"] = tag.memberIdx;
        formDataMap["$baseKey.width"] = tag.position.dx;
        formDataMap["$baseKey.height"] = tag.position.dy;
        tagCounter++;
      }
    }

    if (location != null) {
      formDataMap["location"] = location;
    }

    final formData = FormData.fromMap(formDataMap);

    ResponseModel responseModel = await _feedService.postFeed(formData);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'postFeed',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> putFeed({
    required int memberIdx,
    required int isView,
    String? location,
    String? contents,
    required PostFeedState feedState,
    required int contentIdx,
    required List<TagImages> initialTagList,
  }) async {
    Map<String, dynamic> formDataMap = {
      "memberIdx": memberIdx,
      "menuIdx": 1,
      "contents": contents ?? "",
      "isView": isView,
    };

    if (location != null) {
      formDataMap["location"] = location;
    }

    List<Map<String, dynamic>> imgTagList = [];
    for (var tagImage in feedState.tagImage) {
      for (var tag in tagImage.tag) {
        // 초기 태그 리스트에서 해당 태그를 찾습니다.
        var initialTag = initialTagList.where((e) => e.index == tagImage.index).expand((e) => e.tag).firstWhere((t) => t.memberIdx == tag.memberIdx,
            orElse: () => Tag(
                  username: '',
                  memberIdx: 0,
                  position: Offset(0, 0),
                  imageIndex: tag.imageIndex,
                ));

        // 태그의 상태를 결정하는 로직
        String status = "";
        if (initialTag.username == '' && initialTag.memberIdx == 0) {
          status = "new"; // 새로운 태그
        } else if (initialTag.position != tag.position) {
          status = "modi"; // 위치가 수정된 태그
        } else {
          // 변경되지 않은 태그
          status = "";
        }

        imgTagList.add({"imgIdx": tag.imageIndex, "memberIdx": tag.memberIdx, "width": tag.position.dx, "height": tag.position.dy, "status": status});
      }
    }

    // 초기 태그 리스트에만 있는 태그를 찾아서 "status": "del"로 설정합니다.
    for (var initialTagImage in initialTagList) {
      for (var initialTag in initialTagImage.tag) {
        if (!feedState.tagImage.any((ti) => ti.tag.any((t) => t.memberIdx == initialTag.memberIdx))) {
          imgTagList.add({"imgIdx": initialTag.imageIndex, "memberIdx": initialTag.memberIdx, "width": initialTag.position.dx, "height": initialTag.position.dy, "status": "del"});
        }
      }
    }

    formDataMap["imgTagList"] = imgTagList;

    ResponseModel responseModel = await _feedService.putFeed(contentIdx, formDataMap);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'FeedRepository',
        caller: 'putFeed',
      );
    }

    return responseModel;
  }
}
