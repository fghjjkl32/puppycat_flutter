import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/services/main/comment/comment_service.dart';

class CommentRepository {
  late final CommentService _contentsService; // = CommentService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  final Dio dio;

  CommentRepository({
    required this.dio,
  }) {
    _contentsService = CommentService(dio, baseUrl: baseUrl);
  }

  Future<CommentResponseModel> getComment({
    required int contentIdx,
    required int page,
    int limit = 10,
  }) async {
    CommentResponseModel responseModel = await _contentsService.getComment(contentIdx, page, limit);

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

  Future<CommentResponseModel> getReplyComment({
    required int contentIdx,
    required int commentIdx,
    required int page,
    int limit = 10,
  }) async {
    CommentResponseModel responseModel = await _contentsService.getReplyComment(contentIdx, commentIdx, page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'CommentRepository',
        caller: 'getReplyComment',
        // arguments: ['${memberIdx == null}'],
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
    required String contents,
    required int contentIdx,
    int? parentIdx,
  }) async {
    final Map<String, dynamic> body;
    if (parentIdx == null) {
      body = {
        "contents": contents,
      };
    } else {
      body = {
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
    required int commentIdx,
    required String contents,
    required int contentIdx,
  }) async {
    final Map<String, dynamic> body = {
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
    required int parentIdx,
  }) async {
    ResponseModel responseModel = await _contentsService.deleteComment(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
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
  }) async {
    ResponseModel responseModel = await _contentsService.postCommentLike(commentIdx);

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
  }) async {
    ResponseModel responseModel = await _contentsService.deleteCommentLike(
      commentIdx: commentIdx,
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

  Future<CommentResponseModel> getFocusComments(int contentsIdx, int commentIdx, [int page = 1, int limit = 10]) async {
    Map<String, dynamic> queries = {
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
