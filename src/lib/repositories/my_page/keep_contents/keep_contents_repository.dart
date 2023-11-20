import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/keep_contents/keep_contents_service.dart';

class KeepContentsRepository {
  late final KeepContentsService _keepContentsService;
  final Dio dio;

  KeepContentsRepository({
    required this.dio,
  }) {
    _keepContentsService = KeepContentsService(dio, baseUrl: baseUrl);
  }

  Future<ContentResponseModel> getKeepContents({required int memberIdx, required int page}) async {
    ContentResponseModel responseModel = await _keepContentsService.getKeepContents(memberIdx, page);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'getKeepContents',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getMyKeepContentDetail({
    required int contentIdx,
    required int loginMemberIdx,
  }) async {
    FeedResponseModel responseModel = await _keepContentsService.getMyKeepContentDetail(contentIdx, loginMemberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'getMyKeepContentDetail',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteKeepContents({required int memberIdx, required String idx}) async {
    ResponseModel responseModel = await _keepContentsService.deleteKeepContents(memberIdx, idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'deleteKeepContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> deleteOneKeepContents({required int memberIdx, required int idx}) async {
    ResponseModel responseModel = await _keepContentsService.deleteOneKeepContents(memberIdx, idx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'deleteOneKeepContents',
      );
    }

    return responseModel;
  }

  Future<ResponseModel> postKeepContents({required int memberIdx, required List<int> idxList}) async {
    Map<String, dynamic> body = {
      "memberIdx": memberIdx,
      "idxList": idxList,
    };

    ResponseModel responseModel = await _keepContentsService.postKeepContents(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'KeepContentsRepository',
        caller: 'postKeepContents',
      );
    }

    return responseModel;
  }
}
