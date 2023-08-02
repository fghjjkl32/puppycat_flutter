import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/main/comment/comment_service.dart';

class CommentRepository {
  final CommentService _contentsService =
      CommentService(DioWrap.getDioWithCookie());

  Future<CommentResponseModel> getComment(
      {required int contentIdx,
      required int memberIdx,
      required int page}) async {
    try {
      CommentResponseModel? commentResponseModel =
          await _contentsService.getComment(contentIdx, memberIdx, page);

      if (commentResponseModel == null) {
        return _getDefaultCommentResponseModel();
      }

      return commentResponseModel;
    } catch (error) {
      return _getDefaultCommentResponseModel();
    }
  }

  Future<CommentResponseModel> getReplyComment(
      {required int contentIdx,
      required int commentIdx,
      required int memberIdx,
      required int page}) async {
    try {
      CommentResponseModel? commentResponseModel = await _contentsService
          .getReplyComment(contentIdx, commentIdx, memberIdx, page);

      if (commentResponseModel == null) {
        return _getDefaultCommentResponseModel();
      }

      return commentResponseModel;
    } catch (error) {
      return _getDefaultCommentResponseModel();
    }
  }

  CommentResponseModel _getDefaultCommentResponseModel() {
    return CommentResponseModel(
      result: false,
      code: "",
      data: const CommentDataListModel(
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

  Future<ResponseModel> postComment({
    required int memberIdx,
    required String contents,
    required int contentIdx,
    int? parentIdx,
  }) async {
    final Map<String, dynamic> body;
    if (parentIdx == null) {
      body = {
        "memberIdx": memberIdx,
        "contents": contents,
      };
    } else {
      body = {
        "memberIdx": memberIdx,
        "contents": contents,
        "parentIdx": parentIdx,
      };
    }

    ResponseModel? commentResponseModel =
        await _contentsService.postComment(contentIdx, body);

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> editComment({
    required int memberIdx,
    required int commentIdx,
    required String contents,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
      "contents": contents,
    };

    ResponseModel? commentResponseModel =
        await _contentsService.editComment(contentIdx, commentIdx, body);

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> deleteComment({
    required int contentsIdx,
    required int commentIdx,
    required int memberIdx,
  }) async {
    ResponseModel? commentResponseModel = await _contentsService.deleteComment(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
      memberIdx: memberIdx,
    );

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> postCommentLike({
    required int commentIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel? commentResponseModel =
        await _contentsService.postCommentLike(commentIdx, body);

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> deleteCommentLike({
    required int commentIdx,
    required int memberIdx,
  }) async {
    ResponseModel? commentResponseModel =
        await _contentsService.deleteCommentLike(
      commentIdx: commentIdx,
      memberIdx: memberIdx,
    );

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<(ResponseModel?, bool)> errorHandler(Object obj) async {
    ResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;

        if (res?.data == null) {
        } else if (res?.data is Map) {
          print('res data : ${res?.data}');
          responseModel = ResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = ResponseModel.fromJson(valueMap);
        }

        if (res?.statusCode == 204) {}

        // print('responseModel $responseModel');
        break;
      default:
        break;
    }
    return (responseModel, true);
  }
}
