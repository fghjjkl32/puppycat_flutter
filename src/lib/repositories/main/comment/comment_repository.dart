import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/main/comment/comment_service.dart';

class CommentRepository {
  late final CommentService _contentsService; // = CommentService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  final Dio dio;

  CommentRepository({
    required this.dio,
  }) {
    _contentsService = CommentService(dio, baseUrl: baseUrl);
  }

  Future<CommentResponseModel> getComment({required int contentIdx, required int? memberIdx, required int page}) async {
    CommentResponseModel responseModel;
    memberIdx == null ? responseModel = await _contentsService.getLogoutComment(contentIdx, page) : responseModel = await _contentsService.getComment(contentIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'getComment',
      );
    }

    return responseModel;
  }

  Future<CommentResponseModel> getReplyComment({required int contentIdx, required int commentIdx, required int? memberIdx, required int page}) async {
    CommentResponseModel responseModel;

    memberIdx == null
        ? responseModel = await _contentsService.getLogoutReplyComment(contentIdx, commentIdx, page)
        : responseModel = await _contentsService.getReplyComment(contentIdx, commentIdx, memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'getReplyComment',
        arguments: ['${memberIdx == null}'],
      );
    }

    return responseModel;
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

    ResponseModel responseModel = await _contentsService.postComment(contentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'postComment',
      );
    }

    return responseModel;
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

    ResponseModel responseModel = await _contentsService.editComment(contentIdx, commentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'editComment',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteComment({
    required int contentsIdx,
    required int commentIdx,
    required int memberIdx,
    required int parentIdx,
  }) async {
    ResponseModel responseModel = await _contentsService.deleteComment(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
      memberIdx: memberIdx,
      parentIdx: parentIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'deleteComment',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postCommentLike({
    required int commentIdx,
    required int memberIdx,
  }) async {
    final Map<String, dynamic> body = {
      "memberIdx": memberIdx,
    };

    ResponseModel responseModel = await _contentsService.postCommentLike(commentIdx, body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'postCommentLike',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteCommentLike({
    required int commentIdx,
    required int memberIdx,
  }) async {
    ResponseModel responseModel = await _contentsService.deleteCommentLike(
      commentIdx: commentIdx,
      memberIdx: memberIdx,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'deleteCommentLike',
      );
    }

    return responseModel;
  }

  Future<CommentResponseModel> getFocusComments(int memberIdx, int contentsIdx, int commentIdx, [int page = 1, int limit = 10]) async {
    Map<String, dynamic> queries = {
      "memberIdx": memberIdx,
      "page": page,
      "limit": limit,
    };

    CommentResponseModel responseModel = await _contentsService.getFocusComments(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
      queries: queries,
    );

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'getFocusComments',
      );
    }

    return responseModel;
  }
}
